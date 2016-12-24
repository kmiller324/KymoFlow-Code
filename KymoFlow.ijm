// This is the starting point for the KymoFlow code. It takes a kymograph and makes two copies. 
// One copy is rotated by 45 degrees and the other is not, they are both processed, averaged together, 
// outliers are removed, the maximum pixel intensity value is set to zero and the output lines are stretched by a factor of 6.
//
// Written by Kyle E. Miller at Michigan State University 11/18/16.
//



// Take the image and make a copy that is a thresholded black and white image.
run("Z Project Ignore NaNs");
setOption("BlackBackground", false);
run("Make Binary");
run("Invert LUT");
rename("thresholded");


//hide the processing to speed things up
setBatchMode(true);



//get height and width so we can crop it back to size after rotations and make copies to use.
widthOriginal=getWidth();
heightOriginal=getHeight();
run("Duplicate...", "title=45rot");
run("Duplicate...", "title=non45rot");
selectWindow("45rot");

//make a kymoflow map of the unrotated image.
selectWindow("non45rot");
runMacro("LKMTA Fourwayrotation.ijm");
selectWindow("po-p1-p2-p3");
close();
selectWindow("kymoflowmap");
rename("kymoflowmapnonrot");

//make a kymoflow map of the image rotated by 45 degrees
selectWindow("45rot");
run("TransformJ Rotate", "z-angle=45 y-angle=0.0 x-angle=0.0 interpolation=[Nearest Neighbor] background=0.0 adjust resample");
runMacro("LKMTA Fourwayrotation.ijm");
selectWindow("po-p1-p2-p3");
close();

//unrotate the kymoflow and crop it back to the original dimensions
selectWindow("kymoflowmap");
selectWindow("45rot rotated");
close();
selectWindow("kymoflowmap");
selectWindow("kymoflowmapnonrot");
selectWindow("kymoflowmap");
run("TransformJ Rotate", "z-angle=-45 y-angle=0.0 x-angle=0.0 interpolation=[Nearest Neighbor] background=0.0 adjust resample");
widthAfterRotate=getWidth();
heightAfterRotate=getHeight();
leftcrop = round( (widthAfterRotate - widthOriginal)/2);
rightcrop = round(leftcrop + widthOriginal)-1;
topcrop = round((heightAfterRotate - heightOriginal)/2);
bottomcrop = round(topcrop + heightOriginal)-1;
bounds = "x-range=" + leftcrop + "," + rightcrop + " y-range="+ topcrop + "," + bottomcrop;
//print(bounds);
run("TransformJ Crop", bounds);


// change the values of the local pixel velocites by 45 degrees.
//run("TransformJ Crop", "x-range=150,449 y-range=150,449");
selectWindow("kymoflowmap");
selectWindow("kymoflowmap rotated cropped");
run("Macro...", "code=v=atan(v)");
run("Add...", "value=0.785");
run("Macro...", "code=v=tan(v)");


//close unneeded windows
selectWindow("kymoflowmap");
close();
selectWindow("kymoflowmap rotated");
close();
selectWindow("45rot");
close();

//find the average of the rotated and unrotated kymoflow maps
selectWindow("kymoflowmapnonrot");
run("Concatenate...", "  title=[Concatenated Stacks] image1=kymoflowmapnonrot image2=[kymoflowmap rotated cropped] image3=[-- None --]");
run("Z Project Ignore NaNs");
selectWindow("Concatenated Stacks");
selectWindow("Projection");
rename("Projection45out");

//close unneeded windows
selectWindow("Concatenated Stacks");
close();
selectWindow("Projection45out");
selectWindow("non45rot");
close();

// remove the outliers
selectWindow("Projection45out");
run("Remove Outliers...", "radius=2 threshold=50 which=Dark");
run("Remove Outliers...", "radius=2 threshold=50 which=Bright");

// make sure the maximum local velocity is 50 p/f
run("Macro...", "code=[if (v>50) v=50]");
run("Macro...", "code=[if (v<-50) v=-50]");

// make the output lines thicker
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Remove NaNs...", "radius=6 stack");
selectWindow("Reslice of Projection45out");
run("Reslice [/]...", "output=1.000 start=Top avoid");

selectWindow("thresholded");
close();
selectWindow("Reslice of Reslice");
rename("kymoflowfinal");

setBatchMode(false);
