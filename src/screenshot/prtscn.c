#include <stdio.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h> // Needed for XGetImage and other image functions

void captureScreenSpecific(int x_offset, int y_offset, int width, int height, unsigned char *data) {
   Display *display = XOpenDisplay(NULL);
   if (!display) {
       fprintf(stderr, "Cannot open display\n");
       return;
   }

   int screen = DefaultScreen(display);
   Window root = RootWindow(display, screen);

   // Assuming x_offset and y_offset are set to capture a specific monitor
   XImage *image = XGetImage(display, root, x_offset, y_offset, width, height, AllPlanes, ZPixmap);
   if (!image) {
       fprintf(stderr, "Failed to capture image\n");
       XCloseDisplay(display);
       return;
   }

   unsigned long red_mask = image->red_mask;
   unsigned long green_mask = image->green_mask;
   unsigned long blue_mask = image->blue_mask;

   int i = 0;
   for (int yy = 0; yy < height; yy++) {
       for (int xx = 0; xx < width; xx++) {
           unsigned long pixel = XGetPixel(image, xx, yy);
           data[i++] = (pixel & red_mask) >> 16;   // Red
           data[i++] = (pixel & green_mask) >> 8;  // Green
           data[i++] = (pixel & blue_mask);        // Blue
       }
   }

   XDestroyImage(image);
   XCloseDisplay(display);
}