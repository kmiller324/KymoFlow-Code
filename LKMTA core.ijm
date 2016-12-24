//setBatchMode(true);
 
run("Z Project Ignore NaNs");
setOption("BlackBackground", false);
run("Make Binary");
run("Divide...", "value=255");
run("32-bit");
run("Invert LUT");
rename("work1");


run("Duplicate...", "title=workforcleanup");

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
run("Reslice [/]...", "output=1.000 start=Top avoid");
//selectWindow("work1");
//close();

selectWindow("Reslice of work1");
run("Gaussian Blur...", "sigma=2 stack");

// Find Stack Maxima
//
// This macro runs the Process>Binary>Find Maxima
// command on all the images in a stack.

  Dialog.create("Find Maxima");
//  Dialog.addNumber("Noise Tolerance:", 5);
  Dialog.addNumber("Noise Tolerance:", 0);

  Dialog.addChoice("Output Type:", newArray("Single Points", "Maxima Within Tolerance", "Segmented Particles", "Count"));
  Dialog.addCheckbox("Exclude Edge Maxima", false);
  Dialog.addCheckbox("Light Background", false);
  //Dialog.show();
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
 //setBatchMode(false);

selectWindow("Reslice of work1");
close();

selectWindow("Reslice of work1(1) Maxima");


//setBatchMode("hide");

run("Duplicate...", "title=It0 duplicate");
run("32-bit");

run("Duplicate...", "title=Ix0 duplicate");
run("32-bit");

run("Duplicate...", "title=Iy0 duplicate");
run("32-bit");



//Gaussian Blur sigma 0.5
/*
run("Convolve...", "text1=0.0003\n0.1065\n0.7866\n0.1065\n0.0003\n normalize stack");
run("Convolve...", "text1=[0.0003 0.1065 0.7866 0.1065 0.0003\n] normalize stack");
run("Convolve...", "text1=-0.0001\n-0.0532\n-0.3932\n0.0000\n0.3932\n0.0532\n0.0001\n normalize stack");
run("Convolve...", "text1=[-0.0001 -0.0532 -0.3932 0.0000 0.3932 0.0532 0.0001\n] normalize stack");

*/

//Gaussian Blur sigma 1
/*
run("Convolve...", "text1=0.0044\n0.0540\n0.2420\n0.3991\n0.2420\n0.0540\n0.0044\n normalize stack");
run("Convolve...", "text1=[0.0044 0.0540 0.2420 0.3991 0.2420 0.0540 0.0044\n] normalize stack");
run("Convolve...", "text1=-0.0022\n-0.0270\n-0.1188\n-0.1725\n0.0000\n0.1725\n0.1188\n0.0270\n0.0022\n normalize stack");
run("Convolve...", "text1=[-0.0022 -0.0270 -0.1188 -0.1725 0.0000 0.1725 0.1188 0.0270 0.0022\n] normalize stack");
*/

//Gaussian Blur sigma 2
/*
run("Convolve...", "text1=0.0022\n0.0088\n0.0270\n0.0648\n0.1211\n0.1762\n0.1997\n0.1762\n0.1211\n0.0648\n0.0270\n0.0088\n0.0022\n normalize stack");
run("Convolve...", "text1=[0.0022 0.0088 0.0270 0.0648 0.1211 0.1762 0.1997 0.1762 0.1211 0.0648 0.0270 0.0088 0.0022\n] normalize stack");
run("Convolve...", "text1=-0.0011\n-0.0044\n-0.0124\n-0.0280\n-0.0470\n-0.0557\n-0.0393\n0.0000\n0.0393\n0.0557\n0.0470\n0.0280\n0.0124\n0.0044\n0.0011\n normalize stack");
run("Convolve...", "text1=[-0.0011 -0.0044 -0.0124 -0.0280 -0.0470 -0.0557 -0.0393 0.0000 0.0393 0.0557 0.0470 0.0280 0.0124 0.0044 0.0011\n] normalize stack");
*/

// Gaussian Blur sigma 2 from FlowJ
/*
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Convolve...", "text1=[0.002215924205969 0.008764150246784 0.026995483256594 0.064758797832946 0.120985362259571 0.176032663382149 0.199471140200716 0.176032663382149 0.120985362259571 0.064758797832946 0.026995483256594 0.008764150246784 0.002215924205969\n] stack");
run("Convolve...", "text1=0.0033238863089535\n0.0109551878084803\n0.0269954832565940\n0.0485690983747094\n0.0604926811297858\n0.0440081658455374\n0.0000000000000000\n-0.0440081658455374\n-0.0604926811297858\n-0.0485690983747094\n-0.0269954832565940\n-0.0109551878084803\n-0.0033238863089535\n stack");
run("Convolve...", "text1=[0.0033238863089535 0.0109551878084803 0.0269954832565940 0.0485690983747094 0.0604926811297858 0.0440081658455374 0.0000000000000000 -0.0440081658455374 -0.0604926811297858 -0.0485690983747094 -0.0269954832565940 -0.0109551878084803 -0.0033238863089535\n] stack");
*/


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

/*
//setOption("BlackBackground", false);
// use percentile for mitos
run("Make Binary", "method=Percentile background=Dark calculate");
// use percentile for mitos
//run("Make Binary", "method=Triangle background=Dark calculate");

//run("Erode", "stack");
//run("Erode", "stack");

run("Invert LUT");
run("Divide...", "value=255.000000000 stack");

*/


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

imageCalculator("Divide create 32-bit stack", "Det 1 IyItIxIy - IxItIy2","Det A Ix2Iy2 - IxIyIxIy");
selectWindow("Result of Det 1 IyItIxIy - IxItIy2");
rename("Vx");

imageCalculator("Divide create 32-bit stack", "Det 2 IxItIxIy - Ix2IyIt","Det A Ix2Iy2 - IxIyIxIy");
selectWindow("Result of Det 2 IxItIxIy - Ix2IyIt");
rename("Vy");

//make abs flow map
selectWindow("Vy");
run("Duplicate...", "title=[Vy LAMBDA SQU] duplicate");
selectWindow("Vx");
run("Duplicate...", "title=[Vx LAMBDA SQU] duplicate");
run("Square", "stack");
selectWindow("Vy LAMBDA SQU");
run("Square", "stack");
imageCalculator("Add create 32-bit stack", "Vy LAMBDA SQU","Vx LAMBDA SQU");
selectWindow("Result of Vy LAMBDA SQU");
run("Square Root", "stack");
rename("ABS FLOW MAP");

selectWindow("Ix2 + Iy2");
close();
run("Concatenate...", "  title=[Concatenated Stacks] image1=Ix2 image2=Iy2 image3=IxIy image4=IxIt image5=IyIt image6=Ix2Iy2 image7=IxIyIxIy image8=[Det A Ix2Iy2 - IxIyIxIy] image9=IxItIy2 image10=IyItIxIy image11=[Det 1 IyItIxIy - IxItIy2] image12=IxItIxIy image13=Ix2IyIt image14=[Det 2 IxItIxIy - Ix2IyIt] image15=[Vy LAMBDA SQU] image16=[Vx LAMBDA SQU] image17=[-- None --]");
close();

//setBatchMode("exit and display");

selectWindow("work1");




run("Rotate 90 Degrees Right");
run("Reslice [/]...", "output=1.000 start=Top avoid");

run("Gaussian Blur...", "sigma=2 stack");

// Find Stack Maxima
//
// This macro runs the Process>Binary>Find Maxima
// command on all the images in a stack.

  Dialog.create("Find Maxima");
//  Dialog.addNumber("Noise Tolerance:", 5);
  Dialog.addNumber("Noise Tolerance:", 0);

  Dialog.addChoice("Output Type:", newArray("Single Points", "Maxima Within Tolerance", "Segmented Particles", "Count"));
  Dialog.addCheckbox("Exclude Edge Maxima", false);
  Dialog.addCheckbox("Light Background", false);
  //Dialog.show();
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
 //setBatchMode(false);

//selectWindow("Reslice of work1");
//close();

selectWindow("Reslice of work1(1) Maxima-1");


//setBatchMode("hide");

run("Duplicate...", "title=It0 duplicate");
run("32-bit");

run("Duplicate...", "title=Ix0 duplicate");
run("32-bit");

run("Duplicate...", "title=Iy0 duplicate");
run("32-bit");



//Gaussian Blur sigma 0.5
/*
run("Convolve...", "text1=0.0003\n0.1065\n0.7866\n0.1065\n0.0003\n normalize stack");
run("Convolve...", "text1=[0.0003 0.1065 0.7866 0.1065 0.0003\n] normalize stack");
run("Convolve...", "text1=-0.0001\n-0.0532\n-0.3932\n0.0000\n0.3932\n0.0532\n0.0001\n normalize stack");
run("Convolve...", "text1=[-0.0001 -0.0532 -0.3932 0.0000 0.3932 0.0532 0.0001\n] normalize stack");

*/

//Gaussian Blur sigma 1
/*
run("Convolve...", "text1=0.0044\n0.0540\n0.2420\n0.3991\n0.2420\n0.0540\n0.0044\n normalize stack");
run("Convolve...", "text1=[0.0044 0.0540 0.2420 0.3991 0.2420 0.0540 0.0044\n] normalize stack");
run("Convolve...", "text1=-0.0022\n-0.0270\n-0.1188\n-0.1725\n0.0000\n0.1725\n0.1188\n0.0270\n0.0022\n normalize stack");
run("Convolve...", "text1=[-0.0022 -0.0270 -0.1188 -0.1725 0.0000 0.1725 0.1188 0.0270 0.0022\n] normalize stack");
*/

//Gaussian Blur sigma 2
/*
run("Convolve...", "text1=0.0022\n0.0088\n0.0270\n0.0648\n0.1211\n0.1762\n0.1997\n0.1762\n0.1211\n0.0648\n0.0270\n0.0088\n0.0022\n normalize stack");
run("Convolve...", "text1=[0.0022 0.0088 0.0270 0.0648 0.1211 0.1762 0.1997 0.1762 0.1211 0.0648 0.0270 0.0088 0.0022\n] normalize stack");
run("Convolve...", "text1=-0.0011\n-0.0044\n-0.0124\n-0.0280\n-0.0470\n-0.0557\n-0.0393\n0.0000\n0.0393\n0.0557\n0.0470\n0.0280\n0.0124\n0.0044\n0.0011\n normalize stack");
run("Convolve...", "text1=[-0.0011 -0.0044 -0.0124 -0.0280 -0.0470 -0.0557 -0.0393 0.0000 0.0393 0.0557 0.0470 0.0280 0.0124 0.0044 0.0011\n] normalize stack");
*/

// Gaussian Blur sigma 2 from FlowJ
/*
run("Convolve...", "text1=0.002215924205969\n0.008764150246784\n0.026995483256594\n0.064758797832946\n0.120985362259571\n0.176032663382149\n0.199471140200716\n0.176032663382149\n0.120985362259571\n0.064758797832946\n0.026995483256594\n0.008764150246784\n0.002215924205969\n stack");
run("Convolve...", "text1=[0.002215924205969 0.008764150246784 0.026995483256594 0.064758797832946 0.120985362259571 0.176032663382149 0.199471140200716 0.176032663382149 0.120985362259571 0.064758797832946 0.026995483256594 0.008764150246784 0.002215924205969\n] stack");
run("Convolve...", "text1=0.0033238863089535\n0.0109551878084803\n0.0269954832565940\n0.0485690983747094\n0.0604926811297858\n0.0440081658455374\n0.0000000000000000\n-0.0440081658455374\n-0.0604926811297858\n-0.0485690983747094\n-0.0269954832565940\n-0.0109551878084803\n-0.0033238863089535\n stack");
run("Convolve...", "text1=[0.0033238863089535 0.0109551878084803 0.0269954832565940 0.0485690983747094 0.0604926811297858 0.0440081658455374 0.0000000000000000 -0.0440081658455374 -0.0604926811297858 -0.0485690983747094 -0.0269954832565940 -0.0109551878084803 -0.0033238863089535\n] stack");
*/


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

/*
//setOption("BlackBackground", false);
// use percentile for mitos
run("Make Binary", "method=Percentile background=Dark calculate");
// use percentile for mitos
//run("Make Binary", "method=Triangle background=Dark calculate");

//run("Erode", "stack");
//run("Erode", "stack");

run("Invert LUT");
run("Divide...", "value=255.000000000 stack");

*/


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

imageCalculator("Divide create 32-bit stack", "Det 1 IyItIxIy - IxItIy2","Det A Ix2Iy2 - IxIyIxIy");
selectWindow("Result of Det 1 IyItIxIy - IxItIy2");
rename("VxR");

imageCalculator("Divide create 32-bit stack", "Det 2 IxItIxIy - Ix2IyIt","Det A Ix2Iy2 - IxIyIxIy");
selectWindow("Result of Det 2 IxItIxIy - Ix2IyIt");
rename("VyR");

//make abs flow map
selectWindow("VyR");
run("Duplicate...", "title=[Vy LAMBDA SQU] duplicate");
selectWindow("VxR");
run("Duplicate...", "title=[Vx LAMBDA SQU] duplicate");
run("Square", "stack");
selectWindow("Vy LAMBDA SQU");
run("Square", "stack");
imageCalculator("Add create 32-bit stack", "Vy LAMBDA SQU","Vx LAMBDA SQU");
selectWindow("Result of Vy LAMBDA SQU");
run("Square Root", "stack");
rename("ABS FLOW MAPR");

selectWindow("Ix2 + Iy2");
close();
run("Concatenate...", "  title=[Concatenated Stacks] image1=Ix2 image2=Iy2 image3=IxIy image4=IxIt image5=IyIt image6=Ix2Iy2 image7=IxIyIxIy image8=[Det A Ix2Iy2 - IxIyIxIy] image9=IxItIy2 image10=IyItIxIy image11=[Det 1 IyItIxIy - IxItIy2] image12=IxItIxIy image13=Ix2IyIt image14=[Det 2 IxItIxIy - Ix2IyIt] image15=[Vy LAMBDA SQU] image16=[Vx LAMBDA SQU] image17=[-- None --]");
close();

selectWindow("work1");
close();
selectWindow("Vy");
close();
selectWindow("ABS FLOW MAP");
close();
selectWindow("Reslice of work1");
close();
selectWindow("Reslice of work1(1) Maxima-1");
close();
selectWindow("VyR");
close();
selectWindow("ABS FLOW MAPR");
close();
selectWindow("Reslice of work1(1) Maxima");
close();

selectWindow("VxR");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Rotate 90 Degrees Left");
run("Reciprocal", "stack");
run("Multiply...", "value=-1.000000000 stack");
//run("Macro...", "code=[ if ((v<-50) || (v>50)) v=0/0; ] stack");
//run("Macro...", "code=[ if (v>16) v=16; ] stack");
//run("Macro...", "code=[ if (v<-16) v=-16; ] stack");


selectWindow("Vx");
run("Reslice [/]...", "output=1.000 start=Top avoid");
run("Concatenate...", "  title=[Concatenated Stacks] image1=[Reslice of Vx] image2=[Reslice of VxR] image3=[-- None --]");
run("Z Project Ignore NaNs");

//clean up more

selectWindow("Vx");
close();
selectWindow("VxR");
//close();
selectWindow("Concatenated Stacks");
close();

// do median filter
selectWindow("Projection");
run("Duplicate...", "title=ProjectionforMedian");
run("NaN to Zero");
run("Median...", "radius=6");
selectWindow("workforcleanup");
run("Macro...", "code=[ if (v==0) v=0/0; ]");
imageCalculator("Multiply create 32-bit", "workforcleanup","ProjectionforMedian");

selectWindow("Projection");
close();
selectWindow("workforcleanup");
close();
selectWindow("ProjectionforMedian");
close();
selectWindow("VxR");
close();

selectWindow("Result of workforcleanup");
rename("Projection");

//setBatchMode("exit and display");
