function [output_image]=getStitchImage(img_1,img_2,H)

[height_wrap, width_wrap,~] = size(img_1);
[height_unwrap, width_unwrap,~] = size(img_2);
[newH1, newW1, newX, newY, xB, yB] = getNewSize(H, height_wrap, width_wrap, height_unwrap, width_unwrap);
[X,Y] = meshgrid(1:width_wrap,1:height_wrap);
[XX,YY] = meshgrid(newX:newX+newW1-1, newY:newY+newH1-1);

newH =double(newH1);
newW = double(newW1);
AA = ones(3,newH*newW);
AA(1,:) = reshape(XX,1,newH*newW);
AA(2,:) = reshape(YY,1,newH*newW);

AA = H*AA;
XX = reshape(AA(1,:)./AA(3,:), newH, newW);
YY = reshape(AA(2,:)./AA(3,:), newH, newW);

newImage(:,:,1) = interp2(X, Y, double(img_2(:,:,1)), XX, YY);
newImage(:,:,2) = interp2(X, Y, double(img_2(:,:,2)), XX, YY);
newImage(:,:,3) = interp2(X, Y, double(img_2(:,:,3)), XX, YY);
% t122(1)=xB;t122(2)=yB;

[newImage] = blend(newImage, img_1, xB, yB);%图2不变，图1变化后往上拼
% newImage=make_mosaic(img_1,img_2,H);
output_image=uint8(newImage);
% figure;imshow(output_image);