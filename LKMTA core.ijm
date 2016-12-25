// In brief this macro takes a kymograph makes two copies, rotates one by 90 degrees, processes both with the Lucas Kanade Motion tracking algorithm, and
// then combines the output.
// Written by Kyle E. Miller Michigan State University 12/24/2016


// This macro can be run by itself to process a kymograph. It will be dramatically sped up if the setBatchMode(true) at the beginning and the
// setBatchMode("exit and display") at the end are uncommented out.
//setBatchMode(true);


// This allows RGB images or a stack of kymographs to processed when running in stand alone mode.
// The 'Z Project Ignore NaNs' plugin must be installed.
run("Z Project Ignore NaNs");


// Take the kymograph and set the lines to a value of 1 and the background to a value of zero.
setOption("BlackBackground", false);
run("Make Binary");
run("Divide...", "value=255");
run("32-bit");
run("Invert LUT");
rename("work1");

// Make a copy called workforcleanup in which all values of zero will be set to NaN. The resulting image will be used as a mask
// so the output will only appear where there is input.
run("Duplicate...", "title=workforcleanup");

// Pad the input kymograph with extra images so it can be converted into a movie.
selectWindow("work1");
run("Add Slice");
run("Add Slice");
run("Add Slice");
run("Add Slice");
run("Add Slice");
run("Add Slice");
run("Add Slice");
run("Add Slice");
run("Add Slice");
run("Add Slice");
setSlice(1);
run("Select All");
run("Copy");
setSlice(6);
run("Paste");
setSlice(2);
run("Select All");
run("Copy");
run("Previous Slice [<]");
run("Paste");

// Take the stack of kymographs and convert into a movie.
run("Reslice [/]...", "output=1.000 start=Top avoid");

selectWindow("Reslice of work1");

runMacro("LKMTA_movie_processing.ijm");

selectWindow("Vx");
rename("Vx1");

selectWindow("Vy");
rename("Vy1");


// A problem with the LKMTA is that it does not accurately measure the velocity of objects that move rapidly. 
// This seems to be a very general problem in the field of optical flow.
// In brief, if the image intensity gradient of an object at two consecutive time points does not overlap the output is meaningless.
// Blurring the input and pyramidal approaches both help with this problem, by making the object artificially larger.
// Our solution to this problem is to rotate the axes of the movie and then repeat the analysis.
// This is to say, a movie is a three dimension object with dimensions x, y, and t. When it is normally processed by the LKMTA, 
// it does so along the t axis. Instead we flip the x and t axis and process the movie along x.

// An easier way to visualize this is by considering a kymograph. By convention, time goes down along what is typically considered the y-axis.
// If motion is very rapid a line appears nearly horizontal.
// If we rotate the kymograph by 90 degrees a nearly horizontal line becomes nearly vertical. If this is processed by the LKMTA,
// the image intensity gradient will overlap going from one frame to the next. Thus the power of the optical flow in measuring sub-pixel motion 
// can be applied to very rapid motion. 
// 
// To implement this, we set aside the processing that has been done so far. Take the original kymograph, rotate it by 90 degrees and repeat the
// the processing that was done on the original. 
//


selectWindow("work1");

run("Rotate 90 Degrees Right");

run("Reslice [/]...", "output=1.000 start=Top avoid");

selectWindow("Reslice of work1");

runMacro("LKMTA_movie_processing.ijm");

selectWindow("Vx");
rename("Vx2");

selectWindow("Vy");
rename("Vy2");

// We take the rotated velocity flow map, convert it to a kymograph stack and unrotate it geometrically and mathematically.
selectWindow("Vx2");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Rotate 90 Degrees Left");
run("Reciprocal", "stack");
run("Multiply...", "value=-1.000000000 stack");

// We take the velocity flow map from the unrotated version and make it into a kymograph stack.

selectWindow("Vx1");
run("Reslice [/]...", "output=1.000 start=Top avoid");


// The kymograph stacks from Vx and VxR are then merged and Z projected.

run("Concatenate...", "  title=[Concatenated Stacks] image1=[Reslice of Vx1] image2=[Reslice of Vx2] image3=[-- None --]");
run("Z Project Ignore NaNs");

// do median filter
selectWindow("Projection");
run("Duplicate...", "title=ProjectionforMedian");
run("NaN to Zero");
run("Median...", "radius=6");

// Take a copy of the thresholded input and set all values of zero to NaN. 

selectWindow("workforcleanup");
run("Macro...", "code=[ if (v==0) v=0/0; ]");


// Use the workforclearup as a mask, so that the output in ProjectionforMedian only shows up where input is present.

imageCalculator("Multiply create 32-bit", "workforcleanup","ProjectionforMedian");
selectWindow("Result of workforcleanup");
rename("Projection");


//clean up

selectWindow("Vx1");
close();
selectWindow("Vx2");
close();
selectWindow("Vy1");
close();
selectWindow("Vy2");
close();
selectWindow("Concatenated Stacks");
close();
selectWindow("Projection");
close();
selectWindow("workforcleanup");
close();
selectWindow("ProjectionforMedian");
close();
selectWindow("work1");
close();


//setBatchMode("exit and display");
