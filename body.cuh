#pragma once
#include "cuda.h"
#include <vector_types.h>
struct Body {
	double x, y, z;
	double vx, vy, vz;
	double m;
	float3 rgb;
	float3 inner_ratio; //proportion of light reflected by inner sphere in rgb
	float3 outer_ratio; //proportion of light let out of outer sphere in rgb
	double transl_ratio; //of the light that we decide to release from the outer sphere, how much is transmitted and how much is reflected (0.0 means purely reflected, 1.0 means purely transmitted)
	float2 radius; //inner and outer radius of the body
	double ref_idx; //refractive index of the body's outer layer
	/*
	To the rendering engine, every body is made of 2 nested spheres with a light source in the middle. 
	The inner sphere acts as a "one way mirror", letting the light source's light out while only reflecting outside light.
	As this model is supposed to work on celestial bodies, the reflector is a lambertian diffuse reflector. It is meant to model the surface of some rocky body.
	The outer sphere is translucent. It scatters both reflected and transmitted light. This is meant to model things like an atmosphere or a gas cloud (in this case, the reflective sphere is set to radius 0)
	*/
};

