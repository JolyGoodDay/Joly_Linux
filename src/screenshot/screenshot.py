import ctypes
import os

from PIL import Image
from Xlib import display

# Define the library and function
LibName = 'prtscn.so'
AbsLibPath = os.path.dirname(os.path.abspath(__file__)) + os.path.sep + LibName
screenLib = ctypes.CDLL(AbsLibPath)

# Define the function arguments from C
screenLib.captureScreenSpecific.argtypes = [
   ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.POINTER(ctypes.c_ubyte)
]

def capture_screen(x_offset, y_offset, width, height):
   obj_length = width * height * 3  # Assuming 3 bytes per pixel for RGB
   result_array = (ctypes.c_ubyte * obj_length)()  # Create a ctypes array of bytes

   # Call the C function
   screenLib.captureScreenSpecific(x_offset, y_offset, width, height, result_array)

   # Create an image from the buffer
   image = Image.frombuffer('RGB', (width, height), result_array, 'raw', 'RGB', 0, 1)
   return image


if __name__ == '__main__':
   # Example usage: capturing 1920x1080 at offset 0,0
   im = capture_screen(0, 0, 5120, 1440)
   im.show()
   # data = display.Display().screen().root.query_pointer()._data
   # locationtuple = (data["root_x"], data["root_y"])
   # print(locationtuple)