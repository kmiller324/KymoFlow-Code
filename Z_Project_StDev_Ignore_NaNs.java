import ij.*;
import ij.process.*;
import ij.plugin.*;

public class Z_Project_StDev_Ignore_NaNs implements PlugIn {
private Object[] stack;

public void run(String arg) {
ImagePlus imp = IJ.getImage();
ImagePlus projection = zProject(imp);
projection.show();
}

public ImagePlus zProject(ImagePlus imp) {
ImageStack stack = imp.getStack();
int w = stack.getWidth();
int h = stack.getHeight();
int d = stack.getSize();
ImagePlus projection = IJ.createImage("Projection", "32-bit Black", w, h, 1);
ImageProcessor ip = projection.getProcessor();
double value;

//main loop
for (int x=0; x<w; x++) {
for (int y=0; y<h; y++) {
float sum = 0;
int count = 0;

for (int z=0; z<d; z++) {
value = stack.getVoxel(x, y, z);
if (!Double.isNaN(value)) {
sum += value;
count++;
}
}

float average = 0;
float rawvariance = 0;
float variance = 0;
float rawvariancesum = 0;

average = sum/count;

for (int z=0; z<d; z++) {
value = stack.getVoxel(x, y, z);
if (!Double.isNaN(value)) {
rawvariance = ((float)value - average)*((float)value - average);
rawvariancesum += rawvariance;
}
}

variance = rawvariancesum / (count-1);
ip.setf(x, y, variance);
}
}

ip.sqrt();

ip.resetMinAndMax();
return projection;
}

}

