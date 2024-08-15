// mandelbrot.cpp

#include <stdint.h>

extern "C" {
    void compute_mandelbrot(uint8_t* data, int width, int height, int max_iter) {
        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                double c_re = (x - width / 2.0) * 4.0 / width;
                double c_im = (y - height / 2.0) * 4.0 / height;
                double re = c_re;
                double im = c_im;
                int iter;
                for (iter = 0; iter < max_iter; ++iter) {
                    double re2 = re * re;
                    double im2 = im * im;
                    if (re2 + im2 > 4.0) break;
                    im = 2.0 * re * im + c_im;
                    re = re2 - im2 + c_re;
                }
                int color = iter * 255 / max_iter;
                data[(y * width + x) * 4 + 0] = color; // Red
                data[(y * width + x) * 4 + 1] = color; // Green
                data[(y * width + x) * 4 + 2] = color; // Blue
                data[(y * width + x) * 4 + 3] = 255;   // Alpha
            }
        }
    }
}
