#include "nbody.cuh"

using namespace std;


//verlet integration (position and velocity tick separately)
//to get around the limited precision of doubles, we will accumulate the changes until they are large enough to be significant 
//(the errors are most significant when small and large numbers are added and subtracted together), then push them to the main arrays
static __global__ void tickp(size_t n, double deltat, double* p, double* pt, double* v, double* a, bool *bounds, double radius) {
	int idx = threadIdx.x;
	int srd = blockDim.x;
	for (int i = idx; i < n; i += srd) {
		if (!bounds[i]) continue; //if the body is out of bounds, skip it
		pt[i] = pt[i] + v[i] * deltat + 0.5 * a[i] * deltat * deltat;
		if (pt[i] + p[i] != p[i]) {
			p[i] = pt[i] + p[i];
			pt[i] = 0;
		}
		if (fabs(p[i]) > radius) bounds[i] = false; //if the body is out of bounds, mark it as such
	}
}
static __global__ void tickv(size_t n, double deltat, double* v, double* vt, double* ao, double* an, bool* bounds) {
	int idx = threadIdx.x;
	int srd = blockDim.x;
	for (int i = idx; i < n; i += srd) {
		if (!bounds[i]) continue; //if the body is out of bounds, skip it
		vt[i] = vt[i] + 0.5 * (ao[i] + an[i]) * deltat;
		if (vt[i] + v[i] != v[i]) {
			v[i] = vt[i] + v[i];
			vt[i] = 0;
		}
	}
}

__global__ void updateAccel(size_t n, double g, double *x, double *y, double *z, double *ax, double *ay, double *az, double *m, bool *ib, double soft) {
	//now we calculate the new acceleration
	int idx = threadIdx.x;
	int srd = blockDim.x;
	for (int i = idx; i < n; i += srd) {
		if (!ib[i]) continue; //if the body is out of bounds, skip it
		ax[i] = 0;
		ay[i] = 0;
		az[i] = 0;
		for (int j = 0; j < n; j++) {
			if (!ib[j]) continue; //if the body is out of bounds, skip it
			if (i != j) {
				double dx = x[j] - x[i];
				double dy = y[j] - y[i];
				double dz = z[j] - z[i];
				double rsq = dx * dx + dy * dy + dz * dz;
				double rth = (rsq+soft) * sqrt(rsq+soft);
				double a = g * m[j] / rth;
				ax[i] += a * dx; //because there is a r vector on top of the equation usually, no need to divide by r
				ay[i] += a * dy;
				az[i] += a * dz;
			}
		}
	}
}
// making v const is theoretically the best practice, but it interferes with the memory copying process
cudaError_t NBody::makeNBody(NBody*& nb, std::vector<Body>& v, double r) {
	nb = new NBody(r);
	nb->n = v.size();
	cudaError_t err;

	// Concisely allocate and handle potential errors for all device arrays
	auto allocateAndCopy = [&](double*& deviceArray, const double* hostArray) -> cudaError_t {
		err = cudaMallocManaged(&deviceArray, nb->n * sizeof(double));
		if (err != cudaSuccess) return err;
		return cudaMemcpy(deviceArray, hostArray, nb->n * sizeof(double), cudaMemcpyHostToDevice);
		};

	// Helper lambda for bool arrays
	auto allocateAndCopyBool = [&](bool*& deviceArray, const bool* hostArray) -> cudaError_t {
		err = cudaMallocManaged(&deviceArray, nb->n * sizeof(bool));
		if (err != cudaSuccess) return err;
		return cudaMemcpy(deviceArray, hostArray, nb->n * sizeof(bool), cudaMemcpyHostToDevice);
		};

	// Prepare host arrays, for some reason vectors do not work well with the cudaMemcpy function
	double *tx = new double[nb->n], *ty = new double[nb->n], *tz = new double[nb->n], *tvx = new double[nb->n], *tvy = new double[nb->n], *tvz = new double[nb->n], *tm = new double[nb->n];
	bool* tib = new bool[v.size()];  // Initialize all elements to true
	fill(tib, tib + nb->n, true);
	for (int i = 0; i < nb->n; i++) {
		tx[i] = v[i].x; ty[i] = v[i].y; tz[i] = v[i].z;
		tvx[i] = v[i].vx; tvy[i] = v[i].vy; tvz[i] = v[i].vz;
		tm[i] = v[i].m;
	}

	// allocate and copy arrays with error checking
	err = allocateAndCopy(nb->x, tx);
	if (err != cudaSuccess) return err;
	err = allocateAndCopy(nb->y, ty);
	if (err != cudaSuccess) return err;
	err = allocateAndCopy(nb->z, tz);
	if (err != cudaSuccess) return err;
	err = allocateAndCopy(nb->vx, tvx);
	if (err != cudaSuccess) return err;
	err = allocateAndCopy(nb->vy, tvy);
	if (err != cudaSuccess) return err;
	err = allocateAndCopy(nb->vz, tvz);
	if (err != cudaSuccess) return err;
	err = allocateAndCopy(nb->m, tm);
	if (err != cudaSuccess) return err;
	err = allocateAndCopyBool(nb->inbounds, tib);
	if (err != cudaSuccess) return err;

	delete[] tx, ty, tz, tvx, tvy, tvz, tm, tib;

	// Allocate acceleration arrays
	err = cudaMallocManaged(&nb->axo, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->ayo, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->azo, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->axn, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->ayn, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->azn, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;

	err = cudaMallocManaged(&nb->xt, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->yt, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->zt, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->vxt, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->vyt, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;
	err = cudaMallocManaged(&nb->vzt, v.size() * sizeof(double));
	if (err != cudaSuccess) return err;

	updateAccel << <1, 1 >> > (nb->n, nb->g, nb->x, nb->y, nb->z, nb->axn, nb->ayn, nb->azn, nb->m, nb->inbounds, 1); //populate the initial acceleration arrays, "ease in" with larger softening
	cudaDeviceSynchronize();
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}

	return cudaSuccess;
}


cudaError_t NBody::destroyNBody(NBody* nb)
{
	cudaError_t err = cudaFree(nb->x);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->y);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->z);
	if (err != cudaSuccess) return err;

	err = cudaFree(nb->vx);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->vy);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->vz);
	if (err != cudaSuccess) return err;

	err = cudaFree(nb->xt);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->yt);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->zt);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->vxt);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->vyt);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->vzt);
	if (err != cudaSuccess) return err;


	err = cudaFree(nb->axo);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->ayo);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->azo);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->axn);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->ayn);
	if (err != cudaSuccess) return err;
	err = cudaFree(nb->azn);
	if (err != cudaSuccess) return err;

	err = cudaFree(nb->m);
	if (err != cudaSuccess) return err;

	err = cudaFree(nb->inbounds);
	if (err != cudaSuccess) return err;

	delete nb;

	return cudaSuccess;
}

//full verlet integration step, will return error code if something goes wrong
cudaError_t NBody::step(double deltat, size_t nblocks, int tpb, int device) {
	cudaSetDevice(device);
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	tickp<<<nblocks, tpb>>>(n, deltat, x, xt, vx, axn, inbounds, radius);
	cudaDeviceSynchronize();
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	tickp<<<nblocks, tpb>>>(n, deltat, y, yt, vy, ayn, inbounds, radius);
	cudaDeviceSynchronize();
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	tickp<<<nblocks, tpb>>>(n, deltat, z, zt, vz, azn, inbounds, radius);
	cudaDeviceSynchronize();
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	swap(axo, axn); //prep the acceleration arrays for update by shuffling addresses
	swap(ayo, ayn);
	swap(azo, azn);
	updateAccel<<<nblocks, tpb>>>(this->n, this->g, this->x, this->y, this->z, this->axn, this->ayn, this->azn, this->m, this->inbounds, this->softening);
	cudaDeviceSynchronize();
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	tickv<<<nblocks, tpb>>>(n, deltat, vx, vxt, axo, axn, inbounds);
	cudaDeviceSynchronize();
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	tickv<<<nblocks, tpb>>>(n, deltat, vy, vyt, ayo, ayn, inbounds);
	cudaDeviceSynchronize();
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	tickv<<<nblocks, tpb>>>(n, deltat, vz, vzt, azo, azn, inbounds);
	cudaDeviceSynchronize();
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}

	return cudaSuccess;

}
cudaError_t  NBody::getPos(double* x, double* y, double* z) {
	cudaMemcpy(x, this->x, n * sizeof(double), cudaMemcpyDeviceToHost);
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	cudaMemcpy(y, this->y, n * sizeof(double), cudaMemcpyDeviceToHost);
	if (cudaPeekAtLastError() - cudaSuccess) {
		return cudaPeekAtLastError();
	}
	cudaMemcpy(z, this->z, n * sizeof(double), cudaMemcpyDeviceToHost);
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	return cudaSuccess;
}
cudaError_t  NBody::getVel(double* vx, double* vy, double* vz) {
	cudaMemcpy(vx, this->vx, n * sizeof(double), cudaMemcpyDeviceToHost);
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	cudaMemcpy(vy, this->vy, n * sizeof(double), cudaMemcpyDeviceToHost);
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	cudaMemcpy(vz, this->vz, n * sizeof(double), cudaMemcpyDeviceToHost);
	if (cudaPeekAtLastError() != cudaSuccess) {
		return cudaPeekAtLastError();
	}
	return cudaSuccess;
}


