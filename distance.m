function [s,j,L3]=distance(a,b,c,d,height)
%使用经纬度计算位移差t

% D=[120 16 a;
%    120 16 b;
%    36 16 c;
%    36 16 d;]*[1;1/60;1/60/60]*pi/180;
% aj=D(1);
% bj=D(2);
% aw=D(3);
% bw=D(4);%反而耗时╮(╯▽╰)╭
% a=42.0982;
% b=41.6167;
% c=6.2061;
% d=6.4233;
% e=115.1;
lon1=deg2rad(120+16/60+a/60/60);%经度
lon2=deg2rad(120+16/60+b/60/60);
lat1=deg2rad(36+16/60+c/60/60);%纬度
lat2=deg2rad(36+16/60+d/60/60);
% lon1=deg2rad(120+16/60+a/60/60);%经度
% lon2=deg2rad(120+16/60+b/60/60);
% lat1=deg2rad(36+16/60+c/60/60);%纬度
% lat2=deg2rad(36+16/60+d/60/60);

f = 1/298.257223563;
al= 6378137.0;
bl= 6356752.314245;

L = lon2 - lon1;
tanU1 = (1-f)*tan(lat1); cosU1 = 1 / sqrt((1 + tanU1*tanU1));sinU1 = tanU1 * cosU1;
tanU2 = (1-f)*tan(lat2); cosU2 = 1 / sqrt((1 + tanU2*tanU2));sinU2 = tanU2 * cosU2;
lambda = L;
lambda_ = 0;
iterationLimit = 100;
while (abs(lambda - lambda_) > 1e-12 && iterationLimit>0)%迭代直到lambda的变化忽略不计或者已经满100次
        iterationLimit = iterationLimit -1;
        sinlambda = sin(lambda);
        coslambda = cos(lambda);
        sinSq_delta = (cosU2*sinlambda) * (cosU2*sinlambda) + (cosU1*sinU2-sinU1*cosU2* coslambda) * (cosU1*sinU2-sinU1*cosU2* coslambda);
        sin_delta = sqrt(sinSq_delta);
        if sin_delta==0 %？
               return 
        end
        cos_delta = sinU1*sinU2 + cosU1*cosU2*coslambda;
        delta = atan2(sin_delta, cos_delta);
        sin_alpha = cosU1 * cosU2 * sinlambda / sin_delta;
        cosSq_alpha = 1 - sin_alpha*sin_alpha;
        cos2_deltaM = cos_delta - 2*sinU1*sinU2/cosSq_alpha;
        C = f/16*cosSq_alpha*(4+f*(4-3*cosSq_alpha));
        lambda_ = lambda;%？
        lambda = L + (1-C) * f * sin_alpha * (delta + C*sin_delta*(cos2_deltaM+C*cos_delta*(-1+2*cos2_deltaM*cos2_deltaM)));
end
uSq = cosSq_alpha * (al*al - bl*bl) / (bl*bl);
A = 1 + uSq/16384*(4096+uSq*(-768+uSq*(320-175*uSq)));
B = uSq/1024 * (256+uSq*(-128+uSq*(74-47*uSq)));
delta_delta = B*sin_delta*(cos2_deltaM+B/4*(cos_delta*(-1+2*cos2_deltaM*cos2_deltaM)-B/6*cos2_deltaM*(-3+4*sin_delta*sin_delta)*(-3+4*cos2_deltaM*cos2_deltaM)));
s= bl*A*(delta-delta_delta);
fwdAz = atan2(cosU2*sinlambda,  cosU1*sinU2-sinU1*cosU2*coslambda); %初始方位角
% revAz = atan2(cosU1*sinlambda, -sinU1*cosU2+cosU1*sinU2*coslambda); %最终方位角
j=rad2deg(fwdAz);


L3=[s*cos(fwdAz);s*sin(fwdAz);height];
% L3=[s*cos(e);s*sin(e);f];
% s*sin(fwdAz-deg2rad(eee))

