function [para]=getPOSParameter(rawdata)
%输入：图片exif信息；输出：变换矩阵所需的位姿参数；
%input:exif information of image,output:positionand pose parameters

roll_in=deg2rad(rawdata(4,2)-rawdata(4,1));%0.8;%roll弧度20201009
pitch_in=deg2rad(rawdata(2,2)-rawdata(2,1));%-0.4;%pitch
yaw_in=deg2rad(rawdata(6,2)-rawdata(6,1));%0.2;%yaw
[L_in,je_in,world1]=distance(rawdata(9,1),rawdata(9,2),rawdata(8,1),rawdata(8,2),rawdata(13,2)-rawdata(13,1));%计算位移t
    %计算两位置旋转矩阵    
    yaw_m=deg2rad(rawdata(6,1));
    roll_m=deg2rad(rawdata(4,1));
    pitch_m=deg2rad(rawdata(2,1));
    R12x=[1 0 0;
       0 cos(roll_m) sin(roll_m);
       0 -sin(roll_m) cos(roll_m)];
    R12y=[cos(pitch_m) 0 -sin(pitch_m);
       0 1 0;
       sin(pitch_m) 0 cos(pitch_m)];
    R12z=[cos(yaw_m) sin(yaw_m) 0;
        -sin(yaw_m) cos(yaw_m) 0;
        0 0 1]; 
    R12=R12x*R12y*R12z;
t_in=R12*world1;%计算两位置位移差t
n_in=(R12*[0;0;1]);%计算法向量n
para=[roll_in;pitch_in;yaw_in;L_in;rawdata(13,1)-73.005;t_in;n_in];%minus altitude 73.005