%real experiments on OGV and engine rotor
clc
clear
addpath('github_repo');
addpath('RSICP-master');
addpath("RotorData");
% scene='OGVData';
scene='RotorData';
%% real point clouds of OGV
load([scene,'\\test_points.mat']);
load([scene,'\\target_points.mat']);
load([scene,'\\coarse_matrix.mat']);
if strcmp(scene,'OGVData')
    % O1 and O2 are ball center from source and target point clouds
    O1=T1*[85.581;129.744;894.246];
    O2=[20.949;139.022;891.872];
end
%% real point clouds of moto roto
if strcmp(scene,'RotorData')
    O1=T1*[-53.61;68.168;508.840];
    O2=[-2.339;68.327;499.334];
end
source_points=test_points(1:3,:);
source_normals=test_points(4:6,:);
target_normals=target_points(4:6,:);
target_points=target_points(1:3,:);
% T1 is the coarse matrix
source_points=T1*source_points;
source_normals=T1.SO3*source_normals;
% d is the theoretical distance between O1 and O2 theroitical
d=400;

%% ICP 
% jacobian and residual of distance metrics
J=@disFnc_jacobian_res;
tau2=1;
disType='WES';
% disType='point_to_plane';
% disType='point_to_point';
robType='Geman_McClure';
% GDC methods
% [T2,~,~,~,method]=GDCLiftedICP(source_points,target_points,target_normals, ...
%                                 O1,O2,d,1e-6,...
%                                 J,tau2,20, ...
%                                 disType,robType);
% robust symmetric 
% [T2,~,~,~,method]=RSICP(source_points,target_points,source_normals,target_normals,1000);
% 
% lifted representation
[T2,~,~,~,method]=liftedICP(source_points,source_normals,target_points,target_normals, ...
                                J,tau2,50, ...
                                disType,robType);
% sparse point-to-point
% [T2,er_vec,et_vec]=SparsePointToPoint(source_points,target_points,50,20,5,0.1);
% sparse point-to-plane
% [T2,~,~,~,method]=SparsePointToPlane(source_points,target_points,target_normals,100,20,5,0.4);
% sparse WED
% [T2,er_vec,et_vec]=SparseWeightedDistance(source_points,target_points,target_normals,50,20,5,0.1);

%% store the results for alpha-recall
result.T=T2;
assignin('base',method,result);
save([scene,'\resultData\',method,'.mat'],method);
move_points=T2*source_points;
%% plot results
figure
axis off
hold on
% plot3(source_points(1,:),source_points(2,:),source_points(3,:),'r.','MarkerSize',2.5);
plot3(target_points(1,:),target_points(2,:),target_points(3,:),'.','MarkerSize',3,'Color','#6577B0');
% OGV O1 and O2
O1=T1*[85.581;129.744;894.246];
O2=[20.949;139.022;891.872];
% rotor O1 and O2
% O1=T1*[-53.61;68.168;508.840];
% O2=[-2.339;68.327;499.334];
O1=T2*O1;
err=norm(O1-O2)-d
plot3(O1(1),O1(2),O1(3),'k.','MarkerSize',50);
plot3(O2(1),O2(2),O2(3),'k.','MarkerSize',50);
plot3(move_points(1,:),move_points(2,:),move_points(3,:),'r.','MarkerSize',3);
view(0,-60);