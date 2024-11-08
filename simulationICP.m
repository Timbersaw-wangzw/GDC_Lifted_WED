clc
clear all
close all
addpath('github_repo');
addpath('oobbBox')
addpath('Initial_Data\')
addpath('OGVdata\')
addpath('bladeData\')
addpath('RSICP-master\')
% scene='cylinderData';
scene='bladeData';
%% simulation: generate cyclinder Data
if strcmp(scene,'cylinderData')
    load('cylinderData\target_points.mat');
    load('cylinderData\source_points.mat');
    % disType='WED';
    robType='Geman_McClure';
    % disType='point_to_point';
    disType='point_to_plane';
    J=@disFnc_jacobian_res;
    tau2=0.01;
    max_icp=50;
    
    O1=[5.988425613671889;0.065391047920714;1.366095433454959];
    O2=[5.688108907926557;0.004617599360559;0.204516058209524];
    x=[0.1,0.01,1,0.01,0.01,0.01];
    T=SE3.exp(x);
    d=0.292234012362331;
    source_normals=source_points(4:6,:);
    source_points=source_points(1:3,:);
    
    target_normals=target_points(4:6,:);
    target_points=target_points(1:3,:);
    % [source_points,source_normals,target_points,target_normals,T,O1,O2,d]=generateCylinderData(ratio);
    % [T2,er_vec,et_vec,rmse,method]=liftedICP(source_points,source_normals,target_points,target_normals, ...
    %                                         J,tau2,max_icp, ...
    %                                         disType,robType,T);
%     [T2,er_vec,et_vec,rmse,method]=GDCLiftedICP(source_points,target_points,target_normals, ...
%                                     O1,O2,d,0.005,...
%                                     J,tau2,max_icp, ...
%                                     disType,robType,T);
%     [T2,er_vec,et_vec,rmse,method]=RSICP(source_points,target_points,source_normals,target_normals,max_icp,T);
%     result.method=method;
%     result.rmse=rmse;
%     result.T=T2;
%     result.er_vec=er_vec;
%     result.et_vec=et_vec;
%     result_name=method;
%     assignin('base',result_name,result);
%     save(['cylinderData\\',result_name,'.mat'],result_name);
    load("cylinderData\GDC_Lifted_point_to_plane.mat")
    T2=GDC_Lifted_point_to_plane.T;
    figure
    axis off
    hold on
    O3=T2*O1;
    err=norm(O3-O2)-d
    plot3(O2(1),O2(2),O2(3),'k.','MarkerSize',50);
    plot3(O3(1),O3(2),O3(3),'k.','MarkerSize',50);
    move_points=T2*source_points;
    truth=inv(T)*source_points;
    plot3(move_points(1,:),move_points(2,:),move_points(3,:),'.','MarkerSize',4,'Color','red');
    % plot3(truth(1,:),truth(2,:),truth(3,:),'.','MarkerSize',5,'Color','r');
    % plot3(source_points(1,:),source_points(2,:),source_points(3,:),'.','MarkerSize',5,'Color','red');
    hp=plot3(target_points(1,:),target_points(2,:),target_points(3,:),'.','MarkerSize',4,'Color','#6577B0');
    view(22,31)
%     view(0,0)
end
%% simulation: generate blade data
if strcmp(scene,'bladeData')
    noise_vec=[0.001,0.0025,0.005,0.01,0.015];
    ratio_vec=[0,0.2,0.3,0.4,0.5];
    tau2_vec=fliplr([0.001,0.02,0.1,1,10]);
    x=[1,2,3,4,5,6];
    T0=SE3.exp(x);
    % generateBladeData(ratio,T0);
    Z=zeros(5,5);
    for ni=5:5
        for ri=1:1
            clearvars -except ni ri T0 ratio_vec noise_vec tau2_vec
            max_icp=50;
            disType='WED';
            robType='Geman_McClure';
%             disType='point_to_point';
%             disType='point_to_plane';
%             disType='symmetric';
            %% load data
            ratio = ratio_vec(ri);
            noise= noise_vec(ni);
            load_source_points=sprintf('bladeData\\%d%d_source.mat',ni,ri);
            load_target_points=sprintf('bladeData\\%d%d_target.mat',ni,ri);
            load(load_source_points)
            load(load_target_points)

            source_normals=source_points(4:6,:);
            source_points=source_points(1:3,:);
            target_normals=target_points(4:6,:);
            target_points=target_points(1:3,:);
            %% calculate prior distance
%             load_pts_mat=sprintf('bladeData\\test_points%0.1f.mat',ratio);
            load_matrix_mat=sprintf('bladeData\\coarse_matrix%0.1f.mat',ratio);
%             load(load_pts_mat)
            load(load_matrix_mat)
            % the distance between mean of source and target as the point distance 
            data00=importdata('Initial_Data\inital_source_points.txt');
            data01=importdata('target_points.txt');
            O1=mean(data00)';
            O2=mean(data01(:,1:3))';
            d=norm(O1-O2);
            O1=T1*T0*O1;
            T=T1*T0;
            source_points=T1*source_points;
            source_normals=T1.SO3*source_normals;
            %% ICP 
            J=@disFnc_jacobian_res;
%     
            tau2=10 ;
%             tau2=tau2_vec(6-ni);
            [T2,er_vec,et_vec,rmse,method]=GDCLiftedICP(source_points,target_points,target_normals, ...
                                            O1,O2,d,1e-4 ,...
                                            J,tau2,max_icp, ...
                                            disType,robType,T);
%             [T2,er_vec,et_vec,rmse1,method]=liftedICP(source_points,source_normals,target_points,target_normals, ...
%                                             J,tau2,max_icp, ...
%                                             disType,robType,T);
%             [T2,er_vec,et_vec,rmse,method]=RSICP(source_points,target_points,source_normals,target_normals,max_icp,T);
    %         [T2,er_vec,et_vec,rmse,method]=SparsePointToPoint(source_points,target_points,max_icp,20,5,0.4,T1*T0);
%             [T2,er_vec,et_vec,rmse,method]=SparsePointToPlane(source_points,target_points,target_normals,max_icp,20,5,0.1,T);
%             [T2,er_vec,et_vec,rmse,method]=SparseWeightedDistance(source_points,target_points,target_normals,max_icp,20,5,0.05,T);
        end
    end
fprintf('finish!')
figure
axis off
hold on
move_points=T2*source_points;
plot3(move_points(1,:),move_points(2,:),move_points(3,:),'.','MarkerSize',3,'Color','red');
% plot3(source_points(1,:),source_points(2,:),source_points(3,:),'.','MarkerSize',2,'Color','red');
hp=plot3(target_points(1,:),target_points(2,:),target_points(3,:),'.','MarkerSize',3,'Color','#6577B0');
end
