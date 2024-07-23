#define _USE_MATH_DEFINES
#include "render.cuh"

//helper implementations
__device__ float3 operator+(const float3 &a, const float3 &b) {
	return make_float3(a.x + b.x, a.y + b.y, a.z + b.z);
}
__device__ float3 operator-(const float3 &a, const float3 &b) {
	return make_float3(a.x - b.x, a.y - b.y, a.z - b.z);
}
__device__ double dot(float3 a, float3 b) {
	return a.x * b.x + a.y * b.y + a.z * b.z;
}
__device__ float3 operator*(const float3 &a, const double &b) {
	return make_float3(a.x * b, a.y * b, a.z * b);
}
__device__ double distance(const float3 &a, const float3 &b) {
	return sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y) + (a.z - b.z) * (a.z - b.z));
}
__device__ float3 normalize(const float3 &a) {
	double mag = sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
	return make_float3(a.x / mag, a.y / mag, a.z / mag);
}
__device__ double angle(const float3 &a, const float3 &b) {
	return acos(dot(a, b) / (sqrt(dot(a, a)) * sqrt(dot(b, b))));
}

//calculation functions for determining ray intersections
__device__ void vec_point_closest(float3& result, float3& origin, float3& direction, float3& point) {
	float3 v = point - origin;
	result = v - (direction * dot(v, direction)) + point;
} //this function calculates the closest point on a line to a given point
__device__ void vec_sphere_intersect(bool& intersects, float3& result, float3& origin, float3& direction, float3& center, double radius) {
	double a = dot(direction, direction);
	double b = 2 * dot(direction, origin - center);
	double c = dot(origin - center, origin - center) - radius * radius;
	double discriminant = b * b - 4 * a * c;
	if (discriminant <= 0) { //if the ray either misses or skims the sphere, there is no need to apply any transforms to it
		intersects = false;
		return;
	}
	double t1 = (-b + sqrt(discriminant)) / (2 * a);
	double t2 = (-b - sqrt(discriminant)) / (2 * a);
	if(t1 < 0 && t2 < 0) { //ray never intersects
		intersects = false;
		return;
	}
	else if(t1 < 0) { //ray intersects at t2 only
		intersects = true;
		result = origin + direction * t2;
		return;
	}
	else if (t2 < 0) { //ray intersects at t1 only
		intersects = true;
		result = origin + direction * t1;
		return;
	}
	intersects = true;
	double dist = fmin(t1, t2);
	result = origin + direction * dist;
} //this function calculates the intersection of a ray with a sphere, if it exists
__device__ void recolor(float3& rgb, float3& rat) {
	rgb.x *= rat.x;
	rgb.y *= rat.y;
	rgb.z *= rat.z;
} //this function applies the color transformation to a ray
__device__ void shuffle(int *array, size_t n, curandState state) {
	if (n > 1) {
		size_t i;
		for (i = 0; i < n - 1; i++) {
			size_t j = i + curand_uniform_double(&state) * (n - i);
			int t = array[j];
			array[j] = array[i];
			array[i] = t;
		}
	}
} //this function shuffles an array

static __global__ void render_kernel(int rn, int bn, //number of rays and bodies
	float3* ro, float3 *rd, float3 *rgb, bool *active, // ray arrays
	float3* bpos, float2* brad, float3* irat, float3* orat, double* trat, double *m, double *eh, double *ref_idx, int *last_bounce, int *shuffled) { // body info
	const double g = 6.67430e-11;
	const double v_light = 299792458.0;

	int idx = threadIdx.x;
	int srd = blockDim.x;
	int tId = blockIdx.x * blockDim.x + threadIdx.x;
	curandState state;
	curand_init((unsigned long long)clock() + tId, 0, 0, &state);
	for (int i = idx; i < rn; i += srd) {
		if(!active[i]) continue;
		shuffle(shuffled, bn, state);
		for (int k = 0; k < bn; k++) {
			int j = shuffled[k]; //we randomize the order of the bodies to avoid bias in the calculations
			if(j == last_bounce[i]) continue; //the ray just bounced off this body!
			if(!active[i]) continue;
			float3 closest_point;
			vec_point_closest(closest_point, ro[i], rd[i], bpos[j]);
			if (distance(bpos[j], closest_point) < eh[j]) {
				rgb[i] = make_float3(0, 0, 0); //absorption
				active[i] = false;
			}
			float3 outer_intersection;
			bool outer_intersects;
			vec_sphere_intersect(outer_intersects, outer_intersection, ro[i], rd[i], bpos[j], brad[j].y);
			//outer (refractive) sphere logic
			//for simplicity, we will assume uniform refraction index
			if (!outer_intersects) { //gravitational lensing is usually minor in comparison to other effects, so we only apply it if the ray misses the outer sphere entirely
				double dist = distance(closest_point, bpos[j]);
				double alpha = 4*g*m[j]/(v_light*v_light*dist);
				float3 deflection_norm = normalize(bpos[j] - closest_point);
				last_bounce[i] = j;
				ro[i] = closest_point;
				rd[i] = normalize(rd[i] + deflection_norm * tan(alpha));
				continue;
			}
			else {
				float3 refraction_norm = normalize(bpos[j] - outer_intersection); //this points inwards as it is more convenient for the calculations
				float3 deflect = rd[i] - refraction_norm * dot(rd[i], refraction_norm);
				double outer_angle = angle(rd[i], refraction_norm);
				float3 forward = normalize((refraction_norm * dot(rd[i], refraction_norm)) + (deflect * (tan(outer_angle/ref_idx[j]) / tan(outer_angle))));
				bool reflected = trat[j] < curand_uniform_double(&state);
				bool fw_inner_intersects;
				float3 fw_inner_intersection;
				vec_sphere_intersect(fw_inner_intersects, fw_inner_intersection, outer_intersection, forward, bpos[j], brad[j].x);
				float3 start;
				if (fw_inner_intersects) {
					double where = curand_uniform_double(&state);
					start = outer_intersection * where + fw_inner_intersection * (1 - where);
				} else {
					float3 closest_point;
					vec_point_closest(closest_point, outer_intersection, forward, bpos[j]);
					double where = curand_uniform_double(&state);
					start = outer_intersection * where + fw_inner_intersection * (1 - where);
				}
				// lambertian scattering, slightly modified
				float3 x_offset = make_float3(1, 0, 0) * (curand_uniform_double(&state) - 0.5);
				float3 y_offset = make_float3(0, 1, 0) * (curand_uniform_double(&state) - 0.5);
				float3 z_offset = make_float3(0, 0, 1) * (curand_uniform_double(&state) - 0.5);
				float3 scatter_radius_vector = normalize(x_offset + y_offset + z_offset);
				float3 scatter_direction = reflected? (make_float3(0, 0, 0) - forward) : forward;
				ro[i] = start;
				rd[i] = normalize(scatter_direction + scatter_radius_vector);
				recolor(rgb[i], orat[j]);
			}
			float3 inner_intersection;
			bool inner_intersects;
			vec_sphere_intersect(inner_intersects, inner_intersection, ro[i], rd[i], bpos[j], brad[j].x);
			//inner (reflective) sphere logic
			if (inner_intersects) {
				float3 x_offset = make_float3(1, 0, 0) * (curand_uniform_double(&state) - 0.5);
				float3 y_offset = make_float3(0, 1, 0) * (curand_uniform_double(&state) - 0.5);
				float3 z_offset = make_float3(0, 0, 1) * (curand_uniform_double(&state) - 0.5);
				float3 normal = normalize(inner_intersection - bpos[j]);
				float3 scatter_radius_vector = normalize(x_offset + y_offset + z_offset);
				ro[i] = inner_intersection;
				rd[i] = normalize(normal + scatter_radius_vector);
				recolor(rgb[i], irat[j]);
				vec_sphere_intersect(inner_intersects, inner_intersection, ro[i], rd[i], bpos[j], brad[j].y);
				// if the ray started inside the outer sphere, it has to intersect with it once
				//inner intersection is now used as a temp variable
				//snell's law to calculate the "forward" direction
				float3 refraction_norm = normalize(outer_intersection - bpos[j]); //this points outwards this time
				float3 deflect = rd[i] - refraction_norm * dot(rd[i], refraction_norm);
				double outer_angle = angle(rd[i], refraction_norm);
				float3 forward = normalize((refraction_norm * dot(rd[i], refraction_norm)) + (deflect * (tan(outer_angle) / tan(outer_angle / ref_idx[j]))));
				//origin
				double where = curand_uniform_double(&state);
				ro[i] = ro[i] * where + inner_intersection * (1 - where);
				x_offset = make_float3(1, 0, 0) * (curand_uniform_double(&state) - 0.5);
				y_offset = make_float3(0, 1, 0) * (curand_uniform_double(&state) - 0.5);
				z_offset = make_float3(0, 0, 1) * (curand_uniform_double(&state) - 0.5);
				scatter_radius_vector = normalize(x_offset + y_offset + z_offset);
				rd[i] = normalize(forward + scatter_radius_vector);
			}
			//get the origin out of the sphere to avoid double intersections
			//this is done by moving the origin to the intersection point and then moving it a bit further
			vec_sphere_intersect(inner_intersects, inner_intersection, ro[i], rd[i], bpos[j], brad[j].y);
			if (inner_intersects) {
				ro[i] = inner_intersection + rd[i] * 0.0001;
			}
			last_bounce[i] = j;
		}
	}
}

__global__ void render_init(int nbodies, int rays_per, float3* bodies_pos, float3* bodies_rgb, float2* bodies_rad, float3* origins, float3* directions, float3* rgb, bool* active, int* last_bounce) {
	int idx = threadIdx.x;
	int srd = blockDim.x;
	int tId = blockIdx.x * blockDim.x + threadIdx.x;
	curandState state;
	curand_init((unsigned long long)clock() + tId, 0, 0, &state);
	for (int i = idx; i < nbodies; i += srd) {
		for (int j = 0; j < rays_per; j++) {
			float3 x_offset = make_float3(1, 0, 0) * (curand_uniform_double(&state) - 0.5);
			float3 y_offset = make_float3(0, 1, 0) * (curand_uniform_double(&state) - 0.5);
			float3 z_offset = make_float3(0, 0, 1) * (curand_uniform_double(&state) - 0.5);
			origins[i * rays_per + j] = bodies_pos[i];
			directions[i * rays_per + j] = normalize(x_offset + y_offset + z_offset);
			rgb[i * rays_per + j] = bodies_rgb[i];
			active[i * rays_per + j] = true;
			last_bounce[i * rays_per + j] = -1;
			bool tii;
			float3 ti;
			//move ray out of the body sphere
			vec_sphere_intersect(tii, ti, origins[i], directions[i], bodies_pos[j], bodies_rad[j].y);
			origins[i] = ti + directions[i] * 0.0001;
		}
	}
}

double dot_nodevice(float3 a, float3 b) {
	return a.x * b.x + a.y * b.y + a.z * b.z;
}
double angle_nodevice(float3 a, float3 b) {
	return acos(dot_nodevice(a, b) / (sqrt(dot_nodevice(a, a)) * sqrt(dot_nodevice(b, b))));
}
float3 prod_nodevice(float3 a, double b) {
	return make_float3(a.x * b, a.y * b, a.z * b);
}
float3 sum_nodevice(initializer_list<float3> a) {
	float3 result = make_float3(0, 0, 0);
	for (auto i : a) {
		result.x += i.x;
		result.y += i.y;
		result.z += i.z;
	}
	return result;
}
float3 diff_nodevice(float3 a, float3 b) {
	return make_float3(a.x - b.x, a.y - b.y, a.z - b.z);
}
double veclen_nodevice(float3 a) {
	return sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
}
float3 norm_nodevice(float3 a) {
	double mag = sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
	return make_float3(a.x / mag, a.y / mag, a.z / mag);
}
float3 cross_nodevice(float3 a, float3 b) {
	return make_float3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
}

cudaError_t Render::render(int3* image_res, int width, int height, int max_bounces, double* x, double* y, double *z, size_t nblocks, int tpb, int device) {
	cudaSetDevice(device);
	float3* bpos = new float3[nbodies];
	for (int i = 0; i < nbodies; i++) {
		bpos[i] = make_float3(x[i], y[i], z[i]);
	}
	cudaMemcpy(bodies_pos, bpos, sizeof(float3) * nbodies, cudaMemcpyHostToDevice);
	if (cudaGetLastError() != cudaSuccess) {
		return cudaGetLastError();
	}
	render_init<<<nblocks, tpb>>>(nbodies, rays_per, bodies_pos, bodies_rgb, bodies_rad, origins, directions, rgb, active, last_bounce);
	for (int i = 0; i < max_bounces; i++) {
		render_kernel << <nblocks, tpb >> > (nbodies*rays_per, nbodies, origins, directions, rgb, active, bodies_pos, bodies_rad, inner_ratios, outer_ratios, transl_ratios, mass, event_horizon, ref_idx, last_bounce, shuffled); 
		if (cudaGetLastError() != cudaSuccess) {
			return cudaGetLastError();
		}
		cudaDeviceSynchronize();
		if (cudaGetLastError() != cudaSuccess) {
			return cudaGetLastError();
		}
	}
	float3 *t_origins = new float3[nbodies * rays_per];
	float3 *t_directions = new float3[nbodies * rays_per];
	float3 *t_rgb = new float3[nbodies * rays_per];
	bool *t_active = new bool[nbodies * rays_per];
	cudaMemcpy(t_origins, origins, sizeof(float3) * nbodies * rays_per, cudaMemcpyDeviceToHost);
	if (cudaGetLastError() != cudaSuccess) {
		return cudaGetLastError();
	}
	cudaMemcpy(t_directions, directions, sizeof(float3) * nbodies * rays_per, cudaMemcpyDeviceToHost);
	if (cudaGetLastError() != cudaSuccess) {
		return cudaGetLastError();
	}
	cudaMemcpy(t_rgb, rgb, sizeof(float3) * nbodies * rays_per, cudaMemcpyDeviceToHost);
	if (cudaGetLastError() != cudaSuccess) {
		return cudaGetLastError();
	}
	cudaMemcpy(t_active, active, sizeof(bool) * nbodies * rays_per, cudaMemcpyDeviceToHost);
	if (cudaGetLastError() != cudaSuccess) {
		return cudaGetLastError();
	}
	float3 *image = new float3[width * height];
	for(int i = 0; i < width*height; i++) {
		image[i] = make_float3(0, 0, 0);
	}
	//put the rays onto the image
	for (int i = 0; i < nbodies * rays_per; i++) {
		if(!t_active[i]) continue;
		double angleToNormal = angle_nodevice(t_directions[i], cam_norm);
		if (angleToNormal > M_PI / 2) {
			continue;
		}
		float3 diff = diff_nodevice(t_origins[i], cam_bl);
		double prod1 = dot_nodevice(diff, cam_norm);
		double prod2 = dot_nodevice(t_directions[i], cam_norm);
		double prod3 = prod1 / prod2;
		float3 hit = diff_nodevice(t_origins[i], prod_nodevice(t_directions[i], prod3));
		double hd = dot_nodevice(diff_nodevice(hit, cam_bl), cam_h) / veclen_nodevice(cam_h);
		double vd = dot_nodevice(diff_nodevice(hit, cam_bl), cam_v) / veclen_nodevice(cam_v);
		if(hd < 0 || hd > veclen_nodevice(cam_h) || vd < 0 || vd > veclen_nodevice(cam_v)) { //outside the camera screen!
			continue;
		}
		float3 image_focus = sum_nodevice({ cam_bl, prod_nodevice(cam_h, 0.5), prod_nodevice(cam_v, 0.5), prod_nodevice(cam_norm, focal_length) });
		float3 image_diff_norm = norm_nodevice(diff_nodevice(image_focus, hit));
		int x = (int)(width*hd / veclen_nodevice(cam_h));
		int y = (int)(height*vd / veclen_nodevice(cam_v));
		image[y*width + x] = sum_nodevice({image[y*width + x], prod_nodevice(t_rgb[i], dot_nodevice(t_directions[i], image_diff_norm))});
	}
	//map the image to standard 0-255 range
	double abs_max_color = 0;
	for (int i = 0; i < width * height; i++) {
		abs_max_color = max(abs_max_color, (double)(image[i].x));
		abs_max_color = max(abs_max_color, (double)(image[i].y));
		abs_max_color = max(abs_max_color, (double)(image[i].z));
	}
	for(int i = 0; i < width*height; i++) {
		image_res[i].x = (int)(image[i].x * 255 / abs_max_color);
		image_res[i].y = (int)(image[i].y * 255 / abs_max_color);
		image_res[i].z = (int)(image[i].z * 255 / abs_max_color);
	}
	return cudaSuccess;
}

cudaError_t Render::init_render(vector<Body> bodies, float3 cbl, float3 ch, float3 cv, int rays_per, double fl) {
	cudaMallocManaged(&bodies_pos, sizeof(float3) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&bodies_rgb, sizeof(float3) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&bodies_rad, sizeof(float2) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&inner_ratios, sizeof(float3) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&outer_ratios, sizeof(float3) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&transl_ratios, sizeof(double) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&mass, sizeof(double) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&event_horizon, sizeof(double) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&ref_idx, sizeof(double) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&origins, sizeof(float3) * bodies.size() * rays_per);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&directions, sizeof(float3) * bodies.size() * rays_per);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&rgb, sizeof(float3) * bodies.size() * rays_per);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&active, sizeof(bool) * bodies.size() * rays_per);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&last_bounce, sizeof(int) * bodies.size() * rays_per);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMallocManaged(&shuffled, sizeof(int) * bodies.size());
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	nbodies = bodies.size();
	this->rays_per = rays_per;
	cam_bl = cbl;
	cam_h = ch;
	cam_v = cv;
	cam_norm = norm_nodevice(cross_nodevice(cam_h, cam_v));
	focal_length = fl;
	float3* bpos = new float3[nbodies];
	float3* brgb = new float3[nbodies];
	float2* brad = new float2[nbodies];
	float3* irat = new float3[nbodies];
	float3* orat = new float3[nbodies];
	double* trat = new double[nbodies];
	double* m = new double[nbodies];
	double* eh = new double[nbodies];
	double* ri = new double[nbodies];
	const double g = 6.67430e-11;
	const double v_light = 299792458.0;
	for (int i = 0; i < nbodies; i++) {
		bpos[i] = make_float3(bodies[i].x, bodies[i].y, bodies[i].z);
		brgb[i] = bodies[i].rgb;
		brad[i] = bodies[i].radius;
		irat[i] = bodies[i].inner_ratio;
		orat[i] = bodies[i].outer_ratio;
		trat[i] = bodies[i].transl_ratio;
		m[i] = bodies[i].m;
		eh[i] = 2 * g * m[i] / (v_light * v_light); //schwarzschild radius
		ri[i] = bodies[i].ref_idx;
	}
	cudaMemcpy(bodies_pos, bpos, sizeof(float3) * nbodies, cudaMemcpyHostToDevice);
	if(cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMemcpy(bodies_rgb, brgb, sizeof(float3) * nbodies, cudaMemcpyHostToDevice);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMemcpy(bodies_rad, brad, sizeof(float2) * nbodies, cudaMemcpyHostToDevice);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMemcpy(inner_ratios, irat, sizeof(float3) * nbodies, cudaMemcpyHostToDevice);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMemcpy(outer_ratios, orat, sizeof(float3) * nbodies, cudaMemcpyHostToDevice);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMemcpy(transl_ratios, trat, sizeof(double) * nbodies, cudaMemcpyHostToDevice);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMemcpy(mass, m, sizeof(double) * nbodies, cudaMemcpyHostToDevice);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMemcpy(event_horizon, eh, sizeof(double) * nbodies, cudaMemcpyHostToDevice);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaMemcpy(ref_idx, ri, sizeof(double) * nbodies, cudaMemcpyHostToDevice);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	return cudaSuccess;
}
cudaError_t Render::delete_render() {
	cudaFree(bodies_pos);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(bodies_rgb);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(bodies_rad);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(inner_ratios);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(outer_ratios);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(transl_ratios);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(mass);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(event_horizon);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(ref_idx);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(origins);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(directions);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(rgb);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(active);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(last_bounce);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();
	cudaFree(shuffled);
	if (cudaGetLastError() != cudaSuccess) return cudaGetLastError();

	return cudaSuccess;
}

