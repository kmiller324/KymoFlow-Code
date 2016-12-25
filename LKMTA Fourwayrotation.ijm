// make four copies of the kymograph that will be rotated in 90 degree increments.

run("Duplicate...", "title=workingcopyA");
run("Duplicate...", "title=workingcopyA-1");
run("Duplicate...", "title=workingcopyA-2");
run("Duplicate...", "title=workingcopyA-3");

// select the first copy and process it with a novel implementation of Lucas Kanade Motion tracking algorithm.
// This returns an output kymograph called Projection0.
selectWindow("workingcopyA");
runMacro("LKMTA core.ijm");
selectWindow("Projection");
rename("Projection0");
selectWindow("workingcopyA");
close();

// select the second copy, rotate it by 90 degrees and process it.
// This returns an output kymograph called Projection1.
// Unrotate it and take the negative reciprocal to get it back in proper units of pixels/frame.

selectWindow("workingcopyA-1");
run("Rotate 90 Degrees Right");
runMacro("LKMTA core.ijm");
selectWindow("Projection");
rename("Projection1");
run("Rotate 90 Degrees Left");
run("Reciprocal");
run("Multiply...", "value=-1");
selectWindow("workingcopyA-1");
close();

// select the third copy, rotate it by 180 degrees and process it.
// This returns an output kymograph called Projection2.
// Unrotate it to get it back in proper units of pixels/frame.

selectWindow("workingcopyA-2");
run("Rotate 90 Degrees Right");
run("Rotate 90 Degrees Right");
runMacro("LKMTA core.ijm");
selectWindow("Projection");
rename("Projection2");
run("Rotate 90 Degrees Left");
run("Rotate 90 Degrees Left");

selectWindow("workingcopyA-2");
close();

// select the forth copy, rotate it by 270 degrees and process it.
// This returns an output kymograph called Projection3.
// Unrotate it and take the negative reciprocal to get it back in proper units of pixels/frame.

selectWindow("workingcopyA-3");
run("Rotate 90 Degrees Left");
runMacro("LKMTA core.ijm");
selectWindow("Projection");
rename("Projection3");
run("Rotate 90 Degrees Right");
run("Reciprocal");
run("Multiply...", "value=-1");
selectWindow("workingcopyA-3");
close();


// Take the average of the four outputs.
run("Concatenate...", "  title=[Concatenated Stacks] image1=Projection0 image2=Projection1 image3=Projection2 image4=Projection3 image5=[-- None --]");
selectWindow("Concatenated Stacks");
rename("po-p1-p2-p3");
selectWindow("po-p1-p2-p3");
run("Z Project Ignore NaNs");
selectWindow("Projection");
rename("p0p1p2p3 AVE");


// Find the standard deviation over the average of the pixel intensities to identify pixels where the estimates diverge.
selectWindow("po-p1-p2-p3");
run("Z Project StDev Ignore NaNs");
rename("p0p1p2p3 STDEV");
imageCalculator("Divide create 32-bit", "p0p1p2p3 STDEV","p0p1p2p3 AVE");
selectWindow("Result of p0p1p2p3 STDEV");
rename("p0p1p2p3 STDEV over AVE");
selectWindow("p0p1p2p3 STDEV over AVE");

// Take the absolute value of the stdev/ave and if it is greater than 0.2 set to NaN.
// A method for setting a pixel in ImageJ to NaN is to set the pixel value to 0/0.

run("Abs");
run("Macro...", "code=[ if (v>0.2) v=0/0; ]");

// Set every pixel that does not have a value of NaN to a pixel intensity of 1. 
// This creates a image mask which we will use to remove 'bad' values.

run("Macro...", "code=[ if (v>-1) v=1; ]");

// Multiply the image mask with the averaged output
imageCalculator("Multiply create 32-bit", "p0p1p2p3 AVE","p0p1p2p3 STDEV over AVE");
selectWindow("Result of p0p1p2p3 AVE");

//clean up unneeded images. 
// del 12-20 selectWindow("po-p1-p2-p3");
// del 12-20 selectWindow("Result of p0p1p2p3 AVE");
selectWindow("p0p1p2p3 AVE");
close();
// del 12-20 selectWindow("Result of p0p1p2p3 AVE");
selectWindow("p0p1p2p3 STDEV");
close();
// del 12-20 selectWindow("Result of p0p1p2p3 AVE");
selectWindow("p0p1p2p3 STDEV over AVE");
close();
selectWindow("Result of p0p1p2p3 AVE");
rename("kymoflowmap");

//setBatchMode("false");
