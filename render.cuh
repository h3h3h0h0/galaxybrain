#include <math.h>
#include <tuple>
#include <vector>
#include <stdlib.h>
#include <vector_types.h>
#include <time.h>
#include "body.cuh"
#include "cuda_runtime.h"
#include "cuda.h"
#include "device_launch_parameters.h"
#include "curand.h"
#include "curand_kernel.h"

using namespace std;


class Render {
	float3* origins;
	float3* directions; //MUST BE NORMALIZED (magnitude = 1)
	int* bounces; //how many times the ray has been reflected or scattered
	float3* rgb;
	bool* active; //is the ray still active?
	int nbodies;
	int rays_per; //how many rays to shoot per body
	float3 cam_bl; //camera bottom left
	float3 cam_h; //camera horizontal vector
	float3 cam_v; //camera vertical vector
	float3 cam_norm; //camera normal vector, for efficient intersections
	double focal_length; //distance from camera to screen (rays hitting obliquely will be dimmed)
	//if the ray hits this rectangle, it goes to the corresponding pixel of the camera
	//intensity will be subject to angle to the normal
	//the screen will be centered in the camera, and the aspect ratio of the screen will NOT be stretched to fit (whichever side is longer will touch the borders, the other will not
	float3 *bodies_pos;
	float2 *bodies_rad; //radius of the inner and outer spheres
	float3* bodies_rgb; //color of the body
	float3 *inner_ratios; //proportion of light reflected by inner sphere in rgb
	float3 *outer_ratios; //proportion of light let out of outer sphere in rgb
	double *transl_ratios; //proportion of light transmitted by the outer sphere, vs the light reflected by the outer sphere
	double* mass; //mass of the body (for gravitational lensing)
	double* event_horizon; //if the ray is passing within this distance of the center of the body, its RGB intensity will be set to 0 and it will be considered absorbed
							//this will be calculated at runtime, as it depends on the body's mass
	double *ref_idx; //refractive index of the outer sphere
	int* last_bounce; //the bay just bounced off of this body, so it should not bounce off of it again in the next iteration
	int* shuffled; //the order in which the bodies will be iterated when raytracing
	bool inited = false;
public:
	Render() = default;
	~Render() {
		int cnt = 0;
		while(inited) {
			if(cnt > 100) {
				printf("Render destructor failed to delete render after 100 tries, memory will be leaked!\n");
				break;
			}
			delete_render();
			cnt++;
		}
	}
	cudaError_t render(uchar3* image_res, int width, int height, int max_bounces, double* x, double* y, double* z, size_t nblocks, int tpb, int device = 0);
	cudaError_t init_render(vector<Body> bodies, float3 cbl, float3 ch, float3 cv, int rays_per, double fl); //norm will be calculated as the cross product of ch and cv
	cudaError_t delete_render();
};