clc
clear
addpath('github_repo');
addpath('lifted_rep');
addpath('RSICP-master');
%% real point clouds of OGV
load('OGVData\\test_points.mat');
load('OGVData\\target_points.mat');
load('OGVData\\coarse_matrix.mat');
source_points=T1*test_points(1:3,:);
source_normals=T1.SO3*test_points(4:6,:);
target_normals=target_points(4:6,:);
target_points=target_points(1:3,:);

O1=T1*[85.581;129.744;894.246];
O2=[20.949;139.022;891.872];
d=400;
%% ICP 
% aRecall_vec=alphaError(source_points,target_points,0.1);
J=@disFnc_jacobian_res;
% ratio is 0.2 is good for blade
tau2=1;
% disType='WES';
disType='point_to_plane';
robType='Geman_McClure';
% method='GDC_';
% [T2,er_vec,et_vec,rmse,method]=GDCLiftedICP(source_points,target_points,target_normals, ...
%                                 O1,O2,d,1e-6,...
%                                 J,tau2,20, ...
%                                 disType,robType);
% [T2,~,~,~,method]=RSICP(source_points,target_points,source_normals,target_normals,1000);
% 

% [T2,~,~,~,method]=liftedICP(source_points,source_normals,target_points,target_normals, ...
%                                 J,tau2,100, ...
%                                 disType,robType);

% [T2,er_vec,et_vec]=SparsePointToPoint(source_points,target_points,50,20,5,0.1);
[T2,~,~,~,method]=SparsePointToPlane(source_points,target_points,target_normals,100,20,5,0.4);
% [T2,er_vec,et_vec]=SparseWeightedDistance(source_points,target_points,target_normals,50,20,5,0.1);
% T2=SE3([           1            0            0   -0.0132465;
%            0            1            0  -0.00615319;
%            0            0            1 -0.000905923;
%            0            0            0            1;]);
move_points=T2*source_points;
% result_name=;
result.T=T2;
assignin('base',method,result);
save(['OGVData\resultData\',method,'.mat'],method);
figure
axis off
hold on
% plot3(source_points(1,:),source_points(2,:),source_points(3,:),'r.','MarkerSize',2.5);
plot3(target_points(1,:),target_points(2,:),target_points(3,:),'.','MarkerSize',2.5,'Color','#6577B0');
O1=T1*[85.581;129.744;894.246];
O2=[20.949;139.022;891.872];
O1=T2*O1;
err=norm(O1-O2)-d
plot3(O1(1),O1(2),O1(3),'k.','MarkerSize',50);
plot3(O2(1),O2(2),O2(3),'k.','MarkerSize',50);
plot3(move_points(1,:),move_points(2,:),move_points(3,:),'r.','MarkerSize',2.5);
% er_name=sprintf([method,disType,'_er_vec_%d'],10*ratio);
% et_name=sprintf([method,disType,'_et_vec_%d'],10*ratio);
% assignin('base',er_name,er_vec);
% assignin('base',et_name,et_vec);
% save(['bladeData\resultBladeData\',er_name,'.mat'],er_name);
% save(['bladeData\resultBladeData\',et_name,'.mat'],et_name);
% plotError;