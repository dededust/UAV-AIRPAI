function [rmseresult,t]=processimage(c,cindex,net,psx,psy,timee)
flag=1;% 1-choose"POS or POS+MLP";2-choose"SIFT"
net_flag=0;% 1-use net;0-coarse registration
newimg=[1,net_flag];% 1-save result image
rmse=1;%1-calculate rmse,0-do not calculate rmse

load('EXIFDATA.mat');
lut=load('lut.mat');
t=0;

choose_img =c;
name=sprintf('%d',choose_img);
    if (choose_img>139)
        begin_img=choose_img-139;
        
        file_path =  'UAV-AIRPAI-image\grass\';
        exifdata=EXIFDATA(:,[(begin_img) (begin_img+1)]);
    else
        begin_img=choose_img-3;
        file_path =  'UAV-AIRPAI-image\buiding\';
        exifdata=EXIFDATA(:,[(begin_img+72) (begin_img+1+72)]);
    end
img_path_list = dir(strcat(file_path,'*.jpg'));
image_name1 = img_path_list(begin_img).name;%image 1 
    img_1 = imread(strcat(file_path,image_name1));fprintf('%d %s\n',choose_img,strcat(file_path,image_name1));
image_name2 = img_path_list(begin_img+1).name;% image 2
    img_2 = imread(strcat(file_path,image_name2));fprintf('%d %s\n',choose_img,strcat(file_path,image_name2));

%% get homography matrix
switch flag
    case 1
    tic;   
    para_POS=getPOSParameter(exifdata);
    H_POS=getPOSHomoMatrix(para_POS);%直出
%     t=toc;

    if(net_flag) %% 神经网络
        if(net.output.size==8)
            H_MPOS=H_POS(1:8)./H_POS(9);
            HH=mapminmax('apply',H_MPOS(:),psx);
            HH_net=net(HH);
            H_net=mapminmax('reverse',HH_net,psy);
            H_net(9)=1;
            H_net = reshape(H_net,3,3);
            else
            HH=mapminmax('apply',H_POS(:),psx);
            HH_net=net(HH);
            H_net=mapminmax('reverse',HH_net,psy);
            H_net = reshape(H_net,3,3);
        end
    end
    t=toc;
    case 2
        run('vlfeat-0.9.21\toolbox\vl_setup');
%         tic;
        H_SIFT=inv(sift_stitch(img_1,img_2));
%         t=toc; 
end
%% 主观评价    
    if(newimg(1))      
        switch flag
            case 1
            [new]=getStitchImage(img_1,img_2,H_POS);
            imwrite(new,['./POS-IMG/' name 'coarse.jpg']);
            
            case 2
            [new]=getStitchImage(img_1,img_2,H_SIFT);
            imwrite(new,['./SIFT-IMG/' 'SIFT' name '.jpg']);
            
        end
    end
    if(newimg(2))
        [new]=getStitchImage(img_1,img_2,H_net);
        imwrite(new,['./NET-IMG/' timee '-' num2str(net.layers{1}.size) '-' num2str(net.layers{2}.size) '[' name 'net].jpg']);  
    end
%% 客观评价
    if(rmse)
        gtnum=15;
        allgt=xlsread('groundtruth.xlsx',1);
        begincol=find(allgt(1,:)==choose_img)+3;
        gtnum0=length(find(~(isnan(allgt(:,begincol)))))-1;
        gt=allgt(2:gtnum0+1,begincol:begincol+5);

        switch flag
            case 1
                [rmseresult.mean,rmseresult.se_error]=CalculateRMSE(gt,H_POS);
                if(net_flag)
                    [rmseresult.mean,rmseresult.se_error]=CalculateRMSE(gt,H_net);
                end
            case 2
                [rmseresult.mean,rmseresult.se_error]=CalculateRMSE(gt,H_SIFT);        

        end
    end
end