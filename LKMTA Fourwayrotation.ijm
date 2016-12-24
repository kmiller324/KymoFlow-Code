
run("Duplicate...", "title=workingcopyA");
run("Duplicate...", "title=workingcopyA-1");
run("Duplicate...", "title=workingcopyA-2");
run("Duplicate...", "title=workingcopyA-3");
selectWindow("workingcopyA");

runMacro("LKMTA core.ijm");

selectWindow("Projection");
rename("Projection0");
selectWindow("workingcopyA");
close();
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
run("Concatenate...", "  title=[Concatenated Stacks] image1=Projection0 image2=Projection1 image3=Projection2 image4=Projection3 image5=[-- None --]");
selectWindow("Concatenated Stacks");
rename("po-p1-p2-p3");
selectWindow("po-p1-p2-p3");
run("Z Project Ignore NaNs");
selectWindow("Projection");
rename("p0p1p2p3 AVE");
selectWindow("po-p1-p2-p3");
run("Z Project StDev Ignore NaNs");
rename("p0p1p2p3 STDEV");
imageCalculator("Divide create 32-bit", "p0p1p2p3 STDEV","p0p1p2p3 AVE");
selectWindow("Result of p0p1p2p3 STDEV");
rename("p0p1p2p3 STDEV over AVE");
selectWindow("p0p1p2p3 STDEV over AVE");

run("Abs");
run("Macro...", "code=[ if (v>0.2) v=0/0; ]");
run("Macro...", "code=[ if (v>-1) v=1; ]");
imageCalculator("Multiply create 32-bit", "p0p1p2p3 AVE","p0p1p2p3 STDEV over AVE");
selectWindow("Result of p0p1p2p3 AVE");

//cleanup
selectWindow("po-p1-p2-p3");
//close();
selectWindow("Result of p0p1p2p3 AVE");
selectWindow("p0p1p2p3 AVE");
close();
selectWindow("Result of p0p1p2p3 AVE");
selectWindow("p0p1p2p3 STDEV");
close();
selectWindow("Result of p0p1p2p3 AVE");
selectWindow("p0p1p2p3 STDEV over AVE");
close();
selectWindow("Result of p0p1p2p3 AVE");
rename("kymoflowmap");

//setBatchMode("false");










