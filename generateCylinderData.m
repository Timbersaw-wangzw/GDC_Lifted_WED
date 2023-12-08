function [source_points,source_normals,target_points,target_normals,T,O1,O2,d]=generateCylinderData(ratio)
%GENERATECONEDATA 此处显示有关此函数的摘要


N=200;
M=200;
r1=5;
r2=8;
h=8;
s=4*pi;



for i=1:10
    for j=1:N
        theta=(j-1)*s/N;
        z=h*i/M;
        target_points(:,i*N+j)=[theta;r2*sin(theta);z]+0.01*rand(3,1);
    end
end
for i=1:10
    for j=1:N
        theta=(j-7)*s/N;
        z=h*(i+10-10*ratio)/M;
        source_points(:,(i-1)*N+j)=[theta;r2*sin(theta);z]+0.01*rand(3,1);
    end
end
O1=mean(source_points')';
O2=mean(target_points')';
d=norm(O1-O2)
% figure
% hold on
% axis off
x=[0.1,0.01,1,0.01,0.01,0.01];
T=SE3.exp(x);
% plot3(source_points(1,:),source_points(2,:),source_points(3,:),'b*')
% plot3(target_points(1,:),target_points(2,:),target_points(3,:),'r*')
source_points=T*source_points;
plot3(O2(1),O2(2),O2(3),'k.','MarkerSize',50);
O1=T*O1;
dd=norm(O1-O2)
move_pts=pointCloud(source_points');
fix_pts=pointCloud(target_points');
source_normals=pcnormals(move_pts)';
target_normals=pcnormals(fix_pts)';
% plot3(source_points(1,:),source_points(2,:),source_points(3,:),'k*')
% str_e1 = sprintf('cylinderData\\test_points%0.1f.mat',ratio);
% str_e2 = sprintf('cylinderData\\move_pts%0.1f.ply',ratio);
% str_e3= sprintf('cylinderData\\fix_pts%0.1f.ply',ratio);
% pcwrite(move_pts,str_e2);
% pcwrite(fix_pts,str_e3);
% save(str_e1,"test_points");
end

