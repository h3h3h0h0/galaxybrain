#pragma once
#include <vector>
#include <iostream>
#include <math.h>
#include <tuple>
#include "body.cuh"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

using namespace std;

class NBody {
	size_t n;
	const double g = 6.67430e-11;
	const double softening = 0.01;

	double* x = NULL;
	double* y = NULL;
	double* z = NULL;

	double* vx = NULL;
	double* vy = NULL;
    double* vz = NULL;

	//precision-increasing accumulators
	double* xt = NULL;
	double* yt = NULL;
	double* zt = NULL;
	double* vxt = NULL;
	double* vyt = NULL;
	double* vzt = NULL;

	//note how there are two sets of acceleration arrays, this is because verlet integration has to use values from two separate time steps in the velocity equation
	//the pointers will be flipped around as needed
	double* axo = NULL;
	double* ayo = NULL;
	double* azo = NULL;
	double* axn = NULL;
	double* ayn = NULL;
	double* azn = NULL;

	double* m = NULL;

	bool* inbounds = NULL;

	const double radius; //this isn't actually a radius, it's a bounding box size, but it's easier to think of it as a radius

	NBody(double r) : radius(r) {} //DO NOT USE CONSTRUCTORS! Instead, use factory functions MakeNBody and DestroyNBody, as they can return CUDA error codes
	~NBody() = default;

public:
	static cudaError_t makeNBody(NBody *&nb, vector<Body>& v, double r);
	static cudaError_t destroyNBody(NBody* nb);
	cudaError_t step(double deltat, size_t nblocks, int tpb, int device=0);
	cudaError_t getPos(double* x, double* y, double* z);
	cudaError_t getVel(double* vx, double* vy, double* vz); //if so desired, redshift/blueshift can be calculated with velocities
};