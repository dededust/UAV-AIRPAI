function [ homography ] = sift_stitch( I1, I2 )    

    Ia = single(rgb2gray(I1));
    Ib = single(rgb2gray(I2));
 
    [fa, da] = vl_sift(Ia,'PeakThresh',10);
    [fb, db] = vl_sift(Ib,'PeakThresh',10);
  
   [matches, ~] = vl_ubcmatch(da, db,1.5);%The default value of THRESH is 1.5.2.5BEST 2
   
    homography = RANSAC(matches, fa, fb, 5, 600);
     

end

