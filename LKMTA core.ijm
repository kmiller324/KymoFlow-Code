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


// Start of LKMTA on a movie.

// Lines with different slopes create objects of different lengths, this is in effect motion blur.
// Because we draw the lines by hand in the kymograph, when objects move more rapidly their intensity does not decrease.
// As a result, the intensity constraint in the optical flow equations is violated.
// To correct for this, we reduce each object in each frame of the movie into a single point and then later we blur it.
// To do this, we will find the center of mass for the object at each time point by first blurring and then indentifying the pixel intensity maxima.

selectWindow("Reslice of work1");


run("Gaussian Blur...", "sigma=2 stack");

// Find Stack Maxima
// This runs the Process>Binary>Find Maxima
// command on all the images in a stack.

  input = getImageID();
  n = nSlices();
  for (i=1; i<=n; i++) {
     showProgress(i, n);
     selectImage(input);
     setSlice(i);
     run("Find Maxima...", "noise=0 output=[Single Points] exclude");

     if (i==1)
        output = getImageID();
     else {
       run("Select All");
       run("Copy");
       close();
       selectImage(output);
       run("Add Slice");
       run("Paste");
     }
  }

run("Select None");

selectWindow("Reslice of work1");
close();  

// We can now find the intensity gradients in space and time. 
// First we make three copies of the movies and then apply a 2 Sigma Gaussian blur along x, y, and t. 
// The output seems most accurate when the kernel terms are precisely defined.

selectWindow("Reslice of work1(1) Maxima");

run("Duplicate...", "title=It0 duplicate");
run("32-bit");

run("Duplicate...", "title=Ix0 duplicate");
run("32-bit");

run("Duplicate...", "title=Iy0 duplicate");
run("32-bit");

selectWindow("It0");
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Convolve...", "text1=[0.002215924205969 0.008764150246784 0.026995483256594 0.064758797832946 0.120985362259571 0.176032663382149 0.199471140200716 0.176032663382149 0.120985362259571 0.064758797832946 0.026995483256594 0.008764150246784 0.002215924205969\n] stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=0.0033238863089535\n0.0109551878084803\n0.0269954832565940\n0.0485690983747094\n0.0604926811297858\n0.0440081658455374\n0.0000000000000000\n-0.0440081658455374\n-0.0604926811297858\n-0.0485690983747094\n-0.0269954832565940\n-0.0109551878084803\n-0.0033238863089535\n stack");

run("Reslice [/]...", "output=1.000 start=Top avoid");
rename("It");

selectWindow("It0");
close();
selectWindow("Reslice of It0");
close();

selectWindow("Ix0");
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=[0.0033238863089535 0.0109551878084803 0.0269954832565940 0.0485690983747094 0.0604926811297858 0.0440081658455374 0.0000000000000000 -0.0440081658455374 -0.0604926811297858 -0.0485690983747094 -0.0269954832565940 -0.0109551878084803 -0.0033238863089535\n] stack");
rename("Ix");

selectWindow("Reslice of Ix0");
close();
selectWindow("Ix0");
close();

selectWindow("Iy0");
run("Convolve...", "text1=[0.002215924205969 0.008764150246784 0.026995483256594 0.064758797832946 0.120985362259571 0.176032663382149 0.199471140200716 0.176032663382149 0.120985362259571 0.064758797832946 0.026995483256594 0.008764150246784 0.002215924205969\n] stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=0.0033238863089535\n0.0109551878084803\n0.0269954832565940\n0.0485690983747094\n0.0604926811297858\n0.0440081658455374\n0.0000000000000000\n-0.0440081658455374\n-0.0604926811297858\n-0.0485690983747094\n-0.0269954832565940\n-0.0109551878084803\n-0.0033238863089535\n stack");
rename("Iy");

selectWindow("Reslice of Iy0");
close();
selectWindow("Iy0");
close();

// We can now setup the parts to solve the optical flow equation. 


// make Ix2
selectWindow("Ix");
run("Duplicate...", "title=Ix2 duplicate");
run("32-bit");
run("Square", "stack");

//make Iy2
selectWindow("Iy");
run("Duplicate...", "title=Iy2 duplicate");
run("32-bit");
run("Square", "stack");

//make IxIy
imageCalculator("Multiply create 32-bit stack", "Ix","Iy");
selectWindow("Result of Ix");
rename("IxIy");

//make IxIt
imageCalculator("Multiply create 32-bit stack", "Ix","It");
selectWindow("Result of Ix");
rename("IxIt");

//make IyIt
imageCalculator("Multiply create 32-bit stack", "Iy","It");
selectWindow("Result of Iy");
rename("IyIt");


selectWindow("It");
close();
selectWindow("Ix");
close();
selectWindow("Iy");
close();

// Since we only want output where the intensity gradient is strong, we first sum the intensity gradient in x and y. 
// We then threshold the image to make a mask. 
// This has the same purpose as tau in the FlowJ plugin. 
// Since intensity profile of an object in space in time is well defined by the code above, we can use a very simple means of setting the 
// threshold. 


imageCalculator("Add create 32-bit stack", "Ix2","Iy2");
selectWindow("Result of Ix2");
rename("Ix2 + Iy2");


// a is the threshold value. The value of 1 seems to work well, but this could be adjusted up or down.
// b is used to set the output. 

a=1;
b=a+1;

run("Min...", "value=a stack");
run("Max...", "value=b stack");
run("Subtract...", "value=a stack");



// The Lucas Kanade algorithm uses a least squares approach to solve an overdetermined set of equations.
// We implement this by first applying a Gaussian blur to the different terms in the matrix equation, then by solving for each point.


// take the integrals, Gaussian blur Sigma 1.
selectWindow("Ix2");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");

selectWindow("Iy2");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");

selectWindow("IxIy");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");

selectWindow("IxIt");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");

selectWindow("IyIt");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");


// The blurred terms are then multiplied through by the mask Ix2 + Iy2.


//Mask the images
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","Ix2");
selectWindow("Result of Ix2 + Iy2");
rename("Ix2T");
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","Iy2");
selectWindow("Result of Ix2 + Iy2");
rename("Iy2T");
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","IxIy");
selectWindow("Result of Ix2 + Iy2");
rename("IxIyT");
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","IxIt");
selectWindow("Result of Ix2 + Iy2");
rename("IxItT");
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","IyIt");
selectWindow("Result of Ix2 + Iy2");
rename("IyItT");

// Unneeded images are closed to save memory.

selectWindow("Ix2");
close();
selectWindow("Iy2");
close();
selectWindow("IxIy");
close();
selectWindow("IxIt");
close();
selectWindow("IyIt");
close();

// And renamed for easier readability.

selectWindow("Ix2T");
rename("Ix2");
selectWindow("Iy2T");
rename("Iy2");
selectWindow("IxIyT");
rename("IxIy");
selectWindow("IxItT");
rename("IxIt");
selectWindow("IyItT");
rename("IyIt");


// Having every thing set up, here we solve the matrix equations and solve for the velocity of flow in x and y. 

//Do the least squares
imageCalculator("Multiply create 32-bit stack", "Ix2","Iy2");
selectWindow("Result of Ix2");
rename("Ix2Iy2");

imageCalculator("Multiply create 32-bit stack", "IxIy","IxIy");
selectWindow("Result of IxIy");
rename("IxIyIxIy");

imageCalculator("Subtract create 32-bit stack", "Ix2Iy2","IxIyIxIy");
selectWindow("Result of Ix2Iy2");
rename("Det A Ix2Iy2 - IxIyIxIy");

imageCalculator("Multiply create 32-bit stack", "IxIt","Iy2");
selectWindow("Result of IxIt");
rename("IxItIy2");

imageCalculator("Multiply create 32-bit stack", "IyIt","IxIy");
selectWindow("Result of IyIt");
rename("IyItIxIy");

imageCalculator("Subtract create 32-bit stack", "IyItIxIy","IxItIy2");
selectWindow("Result of IyItIxIy");
rename("Det 1 IyItIxIy - IxItIy2");

imageCalculator("Multiply create 32-bit stack", "IxIt","IxIy");
selectWindow("Result of IxIt");
rename("IxItIxIy");

imageCalculator("Multiply create 32-bit stack", "Ix2","IyIt");
selectWindow("Result of Ix2");
rename("Ix2IyIt");

// could delete as Vy is not used.
imageCalculator("Subtract create 32-bit stack", "IxItIxIy","Ix2IyIt");
selectWindow("Result of IxItIxIy");
rename("Det 2 IxItIxIy - Ix2IyIt");

imageCalculator("Divide create 32-bit stack", "Det 1 IyItIxIy - IxItIy2","Det A Ix2Iy2 - IxIyIxIy");
selectWindow("Result of Det 1 IyItIxIy - IxItIy2");
rename("Vx");

// could delete as Vy is not used.
imageCalculator("Divide create 32-bit stack", "Det 2 IxItIxIy - Ix2IyIt","Det A Ix2Iy2 - IxIyIxIy");
selectWindow("Result of Det 2 IxItIxIy - Ix2IyIt");
rename("Vy");

// Unneeded windows are closed to save memory. 
selectWindow("Ix2 + Iy2");
close();
run("Concatenate...", "  title=[Concatenated Stacks] image1=Ix2 image2=Iy2 image3=IxIy image4=IxIt image5=IyIt image6=Ix2Iy2 image7=IxIyIxIy image8=[Det A Ix2Iy2 - IxIyIxIy] image9=IxItIy2 image10=IyItIxIy image11=[Det 1 IyItIxIy - IxItIy2] image12=IxItIxIy image13=Ix2IyIt image14=[Det 2 IxItIxIy - Ix2IyIt] image15=[-- None --]");
close();

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
// It would improve the code if the core part of the image processing was converted into a separate routine that could be called in a loop.
// At this point if any changes are made to the code above, they also need to be applied to the code below that matches. 
//

selectWindow("work1");

run("Rotate 90 Degrees Right");

run("Reslice [/]...", "output=1.000 start=Top avoid");

/// Start of 2nd pass through the standard LKMTA


run("Gaussian Blur...", "sigma=2 stack");

  Dialog.create("Find Maxima");
  Dialog.addNumber("Noise Tolerance:", 0);
  Dialog.addChoice("Output Type:", newArray("Single Points", "Maxima Within Tolerance", "Segmented Particles", "Count"));
  Dialog.addCheckbox("Exclude Edge Maxima", false);
  Dialog.addCheckbox("Light Background", false);

  tolerance = Dialog.getNumber();
  type = Dialog.getChoice();
  exclude = Dialog.getCheckbox();
  light = Dialog.getCheckbox();
  options = "";

  if (exclude) options = options + " exclude";
  if (light) options = options + " light";
  
//setBatchMode(true);

  input = getImageID();
  n = nSlices();
  for (i=1; i<=n; i++) {
     showProgress(i, n);
     selectImage(input);
     setSlice(i);
     run("Find Maxima...", "noise="+ tolerance +" output=["+type+"]"+options);
     
     if (i==1)
        output = getImageID();
    else if (type!="Count") {
       run("Select All");
       run("Copy");
       close();
       selectImage(output);
       run("Add Slice");
       run("Paste");
    }
  }
  run("Select None");

selectWindow("Reslice of work1(1) Maxima-1");

run("Duplicate...", "title=It0 duplicate");
run("32-bit");

run("Duplicate...", "title=Ix0 duplicate");
run("32-bit");

run("Duplicate...", "title=Iy0 duplicate");
run("32-bit");


selectWindow("It0");
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Convolve...", "text1=[0.002215924205969 0.008764150246784 0.026995483256594 0.064758797832946 0.120985362259571 0.176032663382149 0.199471140200716 0.176032663382149 0.120985362259571 0.064758797832946 0.026995483256594 0.008764150246784 0.002215924205969\n] stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=0.0033238863089535\n0.0109551878084803\n0.0269954832565940\n0.0485690983747094\n0.0604926811297858\n0.0440081658455374\n0.0000000000000000\n-0.0440081658455374\n-0.0604926811297858\n-0.0485690983747094\n-0.0269954832565940\n-0.0109551878084803\n-0.0033238863089535\n stack");

run("Reslice [/]...", "output=1.000 start=Top avoid");
rename("It");

selectWindow("It0");
close();
selectWindow("Reslice of It0");
close();

selectWindow("Ix0");
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=[0.0033238863089535 0.0109551878084803 0.0269954832565940 0.0485690983747094 0.0604926811297858 0.0440081658455374 0.0000000000000000 -0.0440081658455374 -0.0604926811297858 -0.0485690983747094 -0.0269954832565940 -0.0109551878084803 -0.0033238863089535\n] stack");
rename("Ix");

selectWindow("Reslice of Ix0");
close();
selectWindow("Ix0");
close();

selectWindow("Iy0");
run("Convolve...", "text1=[0.002215924205969 0.008764150246784 0.026995483256594 0.064758797832946 0.120985362259571 0.176032663382149 0.199471140200716 0.176032663382149 0.120985362259571 0.064758797832946 0.026995483256594 0.008764150246784 0.002215924205969\n] stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Convolve...", "text1=0.0033238863089535\n0.0109551878084803\n0.0269954832565940\n0.0485690983747094\n0.0604926811297858\n0.0440081658455374\n0.0000000000000000\n-0.0440081658455374\n-0.0604926811297858\n-0.0485690983747094\n-0.0269954832565940\n-0.0109551878084803\n-0.0033238863089535\n stack");
rename("Iy");

selectWindow("Reslice of Iy0");
close();
selectWindow("Iy0");
close();

// make Ix2
selectWindow("Ix");
run("Duplicate...", "title=Ix2 duplicate");
run("32-bit");
run("Square", "stack");

//make Iy2
selectWindow("Iy");
run("Duplicate...", "title=Iy2 duplicate");
run("32-bit");
run("Square", "stack");

//make IxIy
imageCalculator("Multiply create 32-bit stack", "Ix","Iy");
selectWindow("Result of Ix");
rename("IxIy");

//make IxIt
imageCalculator("Multiply create 32-bit stack", "Ix","It");
selectWindow("Result of Ix");
rename("IxIt");

//make IyIt
imageCalculator("Multiply create 32-bit stack", "Iy","It");
selectWindow("Result of Iy");
rename("IyIt");


selectWindow("It");
close();
selectWindow("Ix");
close();
selectWindow("Iy");
close();

//Make mask


imageCalculator("Add create 32-bit stack", "Ix2","Iy2");
selectWindow("Result of Ix2");
rename("Ix2 + Iy2");


// a is the threshold value.
a=1;
b=a+1;

run("Min...", "value=a stack");
run("Max...", "value=b stack");
run("Subtract...", "value=a stack");

// take the integrals, Gaussian blur Sigma 1.
selectWindow("Ix2");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");

selectWindow("Iy2");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");

selectWindow("IxIy");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");

selectWindow("IxIt");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");

selectWindow("IyIt");
run("Convolve...", "text1=0.004431848411938\n0.053990966513188\n0.241970724519143\n0.398942280401432\n0.241970724519143\n0.053990966513188\n0.004431848411938\n normalize stack");
run("Convolve...", "text1=[0.004431848411938 0.053990966513188 0.241970724519143 0.398942280401432 0.241970724519143 0.053990966513188 0.004431848411938\n] normalize stack");





//Mask the images
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","Ix2");
selectWindow("Result of Ix2 + Iy2");
rename("Ix2T");
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","Iy2");
selectWindow("Result of Ix2 + Iy2");
rename("Iy2T");
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","IxIy");
selectWindow("Result of Ix2 + Iy2");
rename("IxIyT");
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","IxIt");
selectWindow("Result of Ix2 + Iy2");
rename("IxItT");
imageCalculator("Multiply create 32-bit stack", "Ix2 + Iy2","IyIt");
selectWindow("Result of Ix2 + Iy2");
rename("IyItT");

selectWindow("Ix2");
close();
selectWindow("Iy2");
close();
selectWindow("IxIy");
close();
selectWindow("IxIt");
close();
selectWindow("IyIt");
close();

selectWindow("Ix2T");
rename("Ix2");
selectWindow("Iy2T");
rename("Iy2");
selectWindow("IxIyT");
rename("IxIy");
selectWindow("IxItT");
rename("IxIt");
selectWindow("IyItT");
rename("IyIt");




//Do the least squares
imageCalculator("Multiply create 32-bit stack", "Ix2","Iy2");
selectWindow("Result of Ix2");
rename("Ix2Iy2");

imageCalculator("Multiply create 32-bit stack", "IxIy","IxIy");
selectWindow("Result of IxIy");
rename("IxIyIxIy");

imageCalculator("Subtract create 32-bit stack", "Ix2Iy2","IxIyIxIy");
selectWindow("Result of Ix2Iy2");
rename("Det A Ix2Iy2 - IxIyIxIy");

imageCalculator("Multiply create 32-bit stack", "IxIt","Iy2");
selectWindow("Result of IxIt");
rename("IxItIy2");

imageCalculator("Multiply create 32-bit stack", "IyIt","IxIy");
selectWindow("Result of IyIt");
rename("IyItIxIy");

imageCalculator("Subtract create 32-bit stack", "IyItIxIy","IxItIy2");
selectWindow("Result of IyItIxIy");
rename("Det 1 IyItIxIy - IxItIy2");

imageCalculator("Multiply create 32-bit stack", "IxIt","IxIy");
selectWindow("Result of IxIt");
rename("IxItIxIy");

imageCalculator("Multiply create 32-bit stack", "Ix2","IyIt");
selectWindow("Result of Ix2");
rename("Ix2IyIt");

imageCalculator("Subtract create 32-bit stack", "IxItIxIy","Ix2IyIt");
selectWindow("Result of IxItIxIy");
rename("Det 2 IxItIxIy - Ix2IyIt");


// Note that in the processing for the unrotated image, the velocity fields are called Vx and Vy. 
// Here they are called VxR and VyR, with the R denoting rotated.


imageCalculator("Divide create 32-bit stack", "Det 1 IyItIxIy - IxItIy2","Det A Ix2Iy2 - IxIyIxIy");
selectWindow("Result of Det 1 IyItIxIy - IxItIy2");

// END OF LKMTA

rename("VxR");

imageCalculator("Divide create 32-bit stack", "Det 2 IxItIxIy - Ix2IyIt","Det A Ix2Iy2 - IxIyIxIy");
selectWindow("Result of Det 2 IxItIxIy - Ix2IyIt");

rename("VyR");

// The parts that are not needed are closed to free up memory.
selectWindow("Ix2 + Iy2");
close();
run("Concatenate...", "  title=[Concatenated Stacks] image1=Ix2 image2=Iy2 image3=IxIy image4=IxIt image5=IyIt image6=Ix2Iy2 image7=IxIyIxIy image8=[Det A Ix2Iy2 - IxIyIxIy] image9=IxItIy2 image10=IyItIxIy image11=[Det 1 IyItIxIy - IxItIy2] image12=IxItIxIy image13=Ix2IyIt image14=[Det 2 IxItIxIy - Ix2IyIt] image15=[-- None --]");
close();
selectWindow("work1");
close();
selectWindow("Vy");
close();
selectWindow("Reslice of work1");
close();
selectWindow("Reslice of work1(1) Maxima-1");
close();
selectWindow("VyR");
close();
selectWindow("Reslice of work1(1) Maxima");
close();

// We take the rotated velocity flow map, convert it to a kymograph stack and unrotate it geometrically and mathematically.
selectWindow("VxR");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Rotate 90 Degrees Left");
run("Reciprocal", "stack");
run("Multiply...", "value=-1.000000000 stack");

// We take the velocity flow map from the unrotated version and make it into a kymograph stack.

selectWindow("Vx");
run("Reslice [/]...", "output=1.000 start=Top avoid");


// The kymograph stacks from Vx and VxR are then merged and Z projected.

run("Concatenate...", "  title=[Concatenated Stacks] image1=[Reslice of Vx] image2=[Reslice of VxR] image3=[-- None --]");
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

selectWindow("Vx");
close();
selectWindow("Concatenated Stacks");
close();
selectWindow("Projection");
close();
selectWindow("workforcleanup");
close();
selectWindow("ProjectionforMedian");
close();
selectWindow("VxR");
close();


//setBatchMode("exit and display");
