clc
clear
addpath('github_repo');
addpath('lifted_rep');
addpath('oobbBox')
addpath('Initial_Data\')
addpath('OGVdata\')

%% simulation: generate cyclinder Data
% ratio = 0.5;
% move source points casually
% load_pts_mat=sprintf('cylinderData\\test_points%0.1f.mat',ratio);
% load_matrix_mat=sprintf('cylinderData\\coarse_matrix%0.1f.mat',ratio);
% [source_points,source_normals,target_points,target_normals,T,O1,O2,d]=generateCylinderData(ratio);
%% simulation: generate blade data
% generateBladeData(ratio,T0);
% load_pts_mat=sprintf('bladeData\\test_points%0.1f.mat',ratio);
% load_matrix_mat=sprintf('bladeData\\coarse_matrix%0.1f.mat',ratio);
% load(load_pts_mat)
% load(load_matrix_mat)
% x=[1,2,3,4,5,6];
% T0=SE3.exp(x);
% source_points=T1*test_points(1:3,:);
% source_normals=T1.SO3*test_points(4:6,:);
% data02=importdata('target_points.txt');
% target_points_normals=data02';
% target_points=target_points_normals(1:3,:);
% target_normals=target_points_normals(4:6,:);
% % the distance between mean of source and target as the point distance 
% data00=importdata('Initial_Data\inital_source_points.txt');
% O1=mean(data00)';
% O2=mean(data02(:,1:3))';
% d=norm(mean_target-mean_source);
% O1=T1*T0*O1;
% T=T1*T0;
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
J=@disFnc_jacobian_res;
% ratio is 0.2 is good for blade
tau2=0.2;
disType='point_to_plane';
robType='Geman_McClure';
method='ptCon_';
[move_points,T2,er_vec,et_vec]=ptConLiftedICP(source_points,source_normals,target_points,target_normals, ...
                                O1,O2,d,...
                                J,tau2,20, ...
                                disType,robType);

% method='Lifted';
% [move_points,T2,er_vec,et_vec]=liftedICP(source_points,source_normals,target_points,target_normals, ...
%                                 J,tau2,50, ...
%                                 disType,robType);
% method='Sparse';
% [move_points,T2,er_vec,et_vec]=SparsePointToPoint(source_points,target_points,50,20,5,0.4);
% [move_points,T2,er_vec,et_vec]=SparsePointToPlane(source_points,target_points,target_normals,50,20,5,0.4);
% [move_points,T2,er_vec,et_vec]=SparseWeightedDistance(source_points,target_points,target_normals,50,20,5,0.4);
figure
axis off
hold on
plot3(source_points(1,:),source_points(2,:),source_points(3,:),'b.','MarkerSize',2.5);
plot3(target_points(1,:),target_points(2,:),target_points(3,:),'r.','MarkerSize',2.5);
% O1=T2^-1*O1;
plot3(O1(1),O1(2),O1(3),'k.','MarkerSize',50);
plot3(O2(1),O2(2),O2(3),'k.','MarkerSize',50);
plot3(move_points(1,:),move_points(2,:),move_points(3,:),'k.','MarkerSize',2.5);
% er_name=sprintf([method,disType,'_er_vec_%d'],10*ratio);
% et_name=sprintf([method,disType,'_et_vec_%d'],10*ratio);
% assignin('base',er_name,er_vec);
% assignin('base',et_name,et_vec);
% save(['bladeData\resultBladeData\',er_name,'.mat'],er_name);
% save(['bladeData\resultBladeData\',et_name,'.mat'],et_name);
% plotError;