#define _USE_MATH_DEFINES
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "nbody.cuh"
#include <stdio.h>
#include <opencv2/opencv.hpp> 
#include <random>
#include <cmath>
#include <malloc.h>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <stdlib.h>
#include "render.cuh"

using namespace std;
using namespace cv;

int main()
{
    double* x = new double[5000];
    double* y = new double[5000];
    double* z = new double[5000];
    double* px = new double[5000];
    double* py = new double[5000];
    double* pz = new double[5000];
    const long double rad = 10000.0;
    uniform_real_distribution<double> unif1(-rad/2.0, rad / 2.0);
    normal_distribution<double> norm1(0, 1000);
    uniform_real_distribution<double> unif2(-10, 10);
    std::random_device                  rand_dev;
    std::mt19937                        generator(rand_dev());
    vector<Body> bodies;
    bodies.emplace_back(Body{ 0, 0, 0, 0, 0, 0, 100000000000.0, make_float3(0, 0, 0), make_float3(0, 0, 0), make_float3(0, 0, 0), 0, make_float2(0, 0), 1});

    Mat img = Mat::zeros(1000, 1000, CV_8UC1);
    for (int i = 0; i < 4999; i++) {
        double cx = unif1(generator);
        double cy = max(-5000.0, min(5000.0, norm1(generator)));
        if (unif2(generator) < 0) swap(cx, cy);
        double cz = unif2(generator);
        double m = 10000;
        if (i > 500) {
            m = 100;
            cx = unif1(generator);
            cy = unif1(generator);
        }
        double cr = sqrt(cx * cx + cy * cy + cz * cz);
        double cv = sqrt(6.674e-11 * 100000000000 / cr);
        double ca = atan2(cy, cx)+M_PI_2;
        double vx = cv * cos(ca);
        double vy = cv * sin(ca);
        double vz = 0;
        bodies.emplace_back(Body{ cx, cy, cz, vx, vy, vz, m, make_float3(100, 100, 100), make_float3(0, 0, 0), make_float3(0, 0, 0), 0, make_float2(0, 0), 1 });
    }
    NBody* bn = NULL;
    cudaError_t err = NBody::makeNBody(bn, bodies, rad);
    Mat pimg = img.clone();

    Render r;
    r.init_render(bodies, make_float3(0, 0, 10000), make_float3(-1000, 0, 0), make_float3(0, -1000, 0), 10, 1000);

    for (int i = 0; i < 1000000000; i++) {
        img = Mat::zeros(1000, 1000, CV_8UC3);
        err = bn->step(1000, 10, 1024, 0);
        memcpy(&px, &x, sizeof(x));
        memcpy(&py, &y, sizeof(x));
        memcpy(&pz, &z, sizeof(x));
        err = bn->getPos(x, y, z);
        /*for (int j = 0; j < 100; j++) {
            cout<<"j: "<<j<<" dx: "<<x[j]-px[j]<<" dy: "<<y[j] - py[j] <<" dz: "<<z[j] - pz[j] <<endl;
        }*/
        //cout << "Error Pos: " << cudaGetErrorString(err) << endl;
        uchar3 *img_res = new uchar3[1000000];
        err = r.render(img_res, 1000, 1000, 10, x, y, z, 10, 1024, 0);

        cout << "render status " << err << endl;
        for (int j = 0; j < 1000; j++) {
            for (int k = 0; k < 1000; k++) {
                int idx = j * 1000 + k;
                img.at<uchar3>(j, k) = img_res[idx];
            }
        }
        Mat fimg = img;
        putText(fimg, "Frame: " + to_string(i), Point(10, 30), FONT_HERSHEY_SIMPLEX, 1, Scalar(255, 255, 255), 2);
        imshow("Test", fimg);
        waitKey(1);
        delete [] img_res;
	}
    r.delete_render();

    delete[] x;
    delete[] y;
    delete[] z;
    delete[] px;
    delete[] py;
    delete[] pz;

    return 0;
}