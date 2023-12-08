% clc
clear
close all
x=[1,2,3,4,5,6];
T0=SE3.exp(x);
noise=0;
ratio=0;
% method="Sparsepoint-to-plane";
% method="SparseWES";
% method="all";
% method="robust_symmetirc";
method_draw='robust_symmetirc';
load_pts_mat=sprintf('bladeData\\test_points%0.1f.mat',ratio);
load_matrix_mat=sprintf('bladeData\\coarse_matrix%0.1f.mat',ratio);
load(load_pts_mat)
load(load_matrix_mat)
source_points=T1*test_points(1:3,:);
data02=importdata('target_points.txt');
target_points_normals=data02';
target_points=target_points_normals(1:3,:);

Files = dir(fullfile('bladeData\\resultData\\*.mat'));
LengthFiles = length(Files);

% T=SE3([  0.994217  0.0238579   0.104708   -3.48218;
%  -0.043006   0.981867   0.184629   0.367748;
% -0.0984044  -0.188064   0.977215    1.16354;
%          0          0          0          1;
% ]);

for i=1:LengthFiles
    name=Files(i).name;
    indx=strfind(name,method_draw);
    load(['bladeData\\resultData\\',name]);
    indx=strfind(name,'.mat');
    dis_name=name(1:indx-1);
    eval=evalin('base',dis_name);
    name=strrep(name,'_','-');
    method_name=name(1:indx-5);
    if ~isempty(indx)
        method_name=strrep(method_name,'point-to-plane','ptpln');
        if eval.ratio==ratio&&eval.noise==noise
            figure
            axis off
            hold on
            h=plot3(target_points(1,:),target_points(2,:),target_points(3,:),'.','MarkerSize',2,'Color','#6577B0');
            T=eval.T;
            move_points=T*source_points;
            theroy_points=(T1*T0)^-1*source_points;
            c=zeros(length(source_points(1,:)),1);
            for k=1:length(source_points(1,:))
                d=norm(move_points(:,k)-theroy_points(:,k));
                c(k)=d;
            end
                s=scatter3(move_points(1,:),move_points(2,:),move_points(3,:),20,c,'.');
                caxis([0,0.02]);
% 
%             s=scatter3(move_points(1,:),move_points(2,:),move_points(3,:),20,log10(c),'.');
%             caxis([-7,-2]);
            colormap("jet")
%             plot3(move_points(1,:),move_points(2,:),move_points(3,:),'.','MarkerSize',2,'Color','red');
            
            
            r=sqrt(sum(c.^2)/length(source_points(1,:)));
            r_str=sprintf('r=%.3emm',r);
%             colorbar('Ticks',linspace(0,0.02,5),'location','southoutside')
            title({method_name;r_str},'FontSize',10);
            view(37.8000,67.3809);
            img =gcf;
%             print(img, '-dpng', '-r600', ['plot\\sim_',method_draw])
        end
    end   
end
