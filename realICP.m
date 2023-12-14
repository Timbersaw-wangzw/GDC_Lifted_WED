clc
clear
addpath('github_repo');
addpath('RSICP-master');
% scene='OGVData';
scene='motoRoto';
%% real point clouds of OGV
if strcmp(scene,'OGVData')
    load('OGVData\\test_points.mat');
    load('OGVData\\target_points.mat');
    load('OGVData\\coarse_matrix.mat');
    source_points=T1*test_points(1:3,:);
    source_normals=T1.SO3*test_points(4:6,:);
    target_normals=target_points(4:6,:);
    target_points=target_points(1:3,:);
    O1=T1*[85.581;129.744;894.246];
    O2=[20.949;139.022;891.872];
end
%% real point clouds of moto roto
if strcmp(scene,'motoRoto')
    load('motoRoto\\test_points.mat');
    load('motoRoto\\target_points.mat');
    bar_target=pcread("motoRoto\\left-bar.ply");
    bar_source=pcread("motoRoto\\right-bar.ply");
    t=mean(bar_target.Location)'-mean(bar_source.Location)';
    source_points=test_points(1:3,:);
    source_normals=test_points(4:6,:);
    target_normals=target_points(4:6,:);
    target_points=target_points(1:3,:);
    
    % T1=SE3;
    T1=SE3(t);
    source_points=T1*source_points;
    source_normals=T1.SO3*source_normals;
    O1=T1*[-53.61;68.168;508.840];
    O2=[-2.339;68.327;499.334];
end
d=400;



% axis on
% hold on
% plot3(source_points(1,:),source_points(2,:),source_points(3,:),'r.','MarkerSize',2.5);
% plot3(target_points(1,:),target_points(2,:),target_points(3,:),'.','MarkerSize',2.5,'Color','#6577B0');
% O1=T1*[-53.61;68.168;508.840];
% O2=[-2.339;68.327;499.334];
% plot3(O1(1),O1(2),O1(3),'k.','MarkerSize',50);
% plot3(O2(1),O2(2),O2(3),'k.','MarkerSize',50);
% plot3(move_points(1,:),move_points(2,:),move_points(3,:),'r.','MarkerSize',2.5);
%% ICP 
% aRecall_vec=alphaError(source_points,target_points,0.1);
J=@disFnc_jacobian_res;
% ratio is 0.2 is good for blade
tau2=10;
disType='WES';
% disType='point_to_plane';
% disType='point_to_point';
robType='Geman_McClure';
% [T2,~,~,~,method]=GDCLiftedICP(source_points,target_points,target_normals, ...
%                                 O1,O2,d,1e-6,...
%                                 J,tau2,20, ...
%                                 disType,robType);
% [T2,~,~,~,method]=RSICP(source_points,target_points,source_normals,target_normals,1000);
% 

[T2,~,~,~,method]=liftedICP(source_points,source_normals,target_points,target_normals, ...
                                J,tau2,50, ...
                                disType,robType);

% [T2,er_vec,et_vec]=SparsePointToPoint(source_points,target_points,50,20,5,0.1);
% [T2,~,~,~,method]=SparsePointToPlane(source_points,target_points,target_normals,100,20,5,0.4);
% [T2,er_vec,et_vec]=SparseWeightedDistance(source_points,target_points,target_normals,50,20,5,0.1);
% T2=SE3([           1            0            0   -0.0132465;
%            0            1            0  -0.00615319;
%            0            0            1 -0.000905923;
%            0            0            0            1;]);
% result_name=;
result.T=T2;
assignin('base',method,result);
save([scene,'\resultData\',method,'.mat'],method);
% T2=GDC_Lifted_point_to_plane.T;
% T2=GDC_Lifted_WES.T;
move_points=T2*source_points;
figure
axis off
hold on
% T1=SE3;
% T2=SE3;
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