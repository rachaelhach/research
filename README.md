# research
Research functions for data and image processing
Functions

1.) Remove saturated points from reflect RS images.
[imOut] = removeSP_ReflectRS(imIn, thresh);

2.)Spat Med Filters Reflect RS images (ua,us,ueff) and saves to .mat files. Exports matlab figure image to a .png.
[uanew, usnew, ueffnew] = opMaps2mat(PtNumber,mFolder,outname,wl,uba, ubs, ta, ts, tuf, Date);

3.)  Save PT QA Patient Dataset to .mat file and the normalized image to a lossless .png file.  Toggle inside CDose folder before running.
[QAstack_sum, avgQA] = QAboard2mat(PtNumber, Date)

4.) Save Cherenkov Patient Dataset to .mat file and the normalized image to a lossless .png file.  Toggle inside CDose folder before running.
[ckov_sum, s] = ckov2mat(PtNumber, Date)

5.) Reads in an align RT file, determines whether it contains 200 frames or 800, then saves the .mat file and the .png as either an align reflected light or as a background image.
alnRT2mat(pct)

6.) Stitch together the RGB image from the demodulated images of all wavelengths and spatial frequencies. need to begin in the folder with the '0_raw file'
[rgb] = demodulate2RGB(pct);

7.) The first is if you need to read in your matstack from a folder, in such case, start in the folder with only the files you want to read in, or in takeROI_im, feed in your stack as is.
[matstack, avgROI] = takeROI(window);
OR
[imstack, avgROI] = takeROI_im(imstack, window);

8.)Selects common points using cpselect with visual thresholds t1 and t2 for visualization purposes. 
[movingPoints, fixedPoints] = matSelect(ckovim, movingim, t1,t2);

9.) registeres both images using fitgeotrans to generate the transformation matrix and imwarp to apply it. 
[registered] = matRegister(movingPoints, fixedPoints, type);
