function [NewImage] = blend(warped_image, unwarped_image, x, y)
% Blend two image by using cross dissolve
% Input:
% warped_image - original image
% unwarped_image - the other image
% x - x coordinate of the lefttop corner of unwarped image
% y - y coordinate of the lefttop corner of unwarped image
% Output:
% newImage
% 
% Yihua Zhao 02-02-2014
% zhyh8341@gmail.com

% MAKE MASKS FOR BOTH IMAGES 
warped_image(isnan(warped_image))=0;%把没值的都变成0
mask1 = (warped_image(:,:,1)>0 |warped_image(:,:,2)>0 | warped_image(:,:,3)>0);%掩膜A构成：把有灰度的地方变成1

newImage = zeros(size(warped_image));%构建画布，大小参考扭转的图像
NewImage = zeros(size(warped_image));
newImage(y:y+size(unwarped_image,1)-1, x: x+size(unwarped_image,2)-1,:) = unwarped_image;%把不变图像复制上去

mask2 = (newImage(:,:,1)>0 | newImage(:,:,2)>0 | newImage(:,:,3)>0);%构建掩膜，不变图像处为1
mask = and(mask1, mask2);%修改掩膜，此时掩膜是两图的重叠部分。
mask11=xor(mask,mask1);
mask22=xor(mask,mask2);
only1(:,:,1) = warped_image(:,:,1).*mask11;
only1(:,:,2) = warped_image(:,:,2).*mask11;
only1(:,:,3) = warped_image(:,:,3).*mask11;
only2(:,:,1) = newImage(:,:,1).*mask22;
only2(:,:,2) = newImage(:,:,2).*mask22;
only2(:,:,3) = newImage(:,:,3).*mask22;
% NewImage(:,:,1) = only1(:,:,1)+only2(:,:,1);
% GET THE OVERLAID REGION
[raw,col] = find(mask);%找到mask的所有1，将所有列数放到col里，最小的列就是重叠区最左，最大列是重叠区最右
left = min(col);
right = max(col);
top=min(raw);
bottom=max(raw);
%bottom=min(max(raw),raw(end));
% mask = ones(size(mask));%全局的权值为1
maskz = zeros(size(mask));
if( x<2)
maskz(top:bottom,left:right) = repmat(linspace(0,1,right-left+1),bottom-top+1,1);%对掩膜重叠区所在的列进行操作，每行都是生成的小数
else
maskz(top:bottom,left:right) = repmat(linspace(1,0,right-left+1),bottom-top+1,1);%，每行都一样。这是一种省时的渐入渐出法。
end
maskz=maskz.*mask;
% BLEND EACH CHANNEL
warped_image(:,:,1) = warped_image(:,:,1).*maskz;%图像变成了从左到右亮度依次变大的渐变图像
warped_image(:,:,2) = warped_image(:,:,2).*maskz;
warped_image(:,:,3) = warped_image(:,:,3).*maskz;

% REVERSE THE ALPHA VALUE反转？
if( x<2)
maskz(top:bottom,left:right) = repmat(linspace(1,0,right-left+1),bottom-top+1,1);
else
maskz(top:bottom,left:right) = repmat(linspace(0,1,right-left+1),bottom-top+1,1);
end
maskz=maskz.*mask;
newImage(:,:,1) = newImage(:,:,1).*maskz;
newImage(:,:,2) = newImage(:,:,2).*maskz;
newImage(:,:,3) = newImage(:,:,3).*maskz;

NewImage(:,:,1) = only1(:,:,1)+only2(:,:,1)+warped_image(:,:,1) + newImage(:,:,1);
NewImage(:,:,2) = only1(:,:,2)+only2(:,:,2)+warped_image(:,:,2) + newImage(:,:,2);
NewImage(:,:,3) = only1(:,:,3)+only2(:,:,3)+warped_image(:,:,3) + newImage(:,:,3);
% NewImage(bottom:en,:,1) = newImage(bottom:en,:,1);
% NewImage(bottom:en,:,2) = newImage(bottom:en,:,2);
% NewImage(bottom:en,:,3) = newImage(bottom:en,:,3);

