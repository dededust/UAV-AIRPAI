function [p,gterror]=CalculateRMSE(GT,H)

gt=round(GT');

y=H*gt(1:3,:);
new(:,:)=y(1:2,:)./[y(3,:);y(3,:)];

gterror(1:2,:)=gt(4:5,:)-new(:,:);
gterror(3,:)=sqrt(sum(gterror.*gterror,1));%列求和再开方，得到同样量纲的误差

p=sum(gterror(3,:))/(size(GT,1));%所有特征点的误差加一起再平均
end
