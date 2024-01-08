% clc
clear
close all
x=[1,2,3,4,5,6];
T0=SE3.exp(x);
noise_vec=[0.001,0.0025,0.005,0.01,0.015];
ratio_vec=[0,0.2,0.3,0.4,0.5];
ri=1;
ni=4;
ratio=ratio_vec(ri);
noise=noise_vec(ni);





load_source_points=sprintf('bladeData\\%d%d_source.mat',ni,ri);
load_target_points=sprintf('bladeData\\%d%d_target.mat',ni,ri);
load(load_source_points)
load(load_target_points)

load_matrix_mat=sprintf('bladeData\\coarse_matrix%0.1f.mat',ratio);
load(load_matrix_mat)
source_points=T1*source_points(1:3,:);
Files = dir(fullfile('bladeData\\resultData\\*.mat'));
LengthFiles = length(Files);


% T=SE3([  0.954494  -0.057449   0.292645   -2.00505;
%  0.0351605   0.996105  0.0808647    -13.294;
%  -0.296151 -0.0668953   0.952796    2.47715;
%          0          0          0          1;
% ]);
% T=SE3([ 0.981769 -0.136302  0.132482  0.692231;
%  0.151984  0.981494 -0.116491  -6.53729;
% -0.114152  0.134503  0.984316  0.207011;
%         0         0         0         1;
% ]);
% method_draw='Lifted_WED';

method_draw='.mat';
for i=1:LengthFiles
    name=Files(i).name;
    indx1=strfind(name,method_draw);
    load(['bladeData\\resultData\\',name]);
    indx=strfind(name,'.mat');
    dis_name=name(1:indx-1);
    eval=evalin('base',dis_name);
    name=strrep(name,'_','-');
    method_name=name(1:indx-5);
    if ~isempty(indx1)
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
%                 s=scatter3(move_points(1,:),move_points(2,:),move_points(3,:),20,c,'.');
%                 caxis([0,0.02]);
% 
            s=scatter3(move_points(1,:),move_points(2,:),move_points(3,:),20,log10(c),'.');
            caxis([-3,-1]);
            colormap("jet")
%             plot3(move_points(1,:),move_points(2,:),move_points(3,:),'.','MarkerSize',2,'Color','red');
            
            
            r=sqrt(sum(c.^2)/length(source_points(1,:)));
            r_str=sprintf('r=%.3emm',r);
%             colorbar('Ticks',linspace(-6,-1,6),'location','southoutside')
            title({method_name;r_str},'FontSize',10);
            view(37.8000,67.3809);
            img =gcf;
%             print(img, '-dpng', '-r600', ['plot\\sim_',method_draw])
        end
    end   
end
load_T=sprintf('Welsch\\result\\%d%d_m5trans.txt',ni,ri);
T=SE3(load(load_T));
figure
axis off
hold on
h=plot3(target_points(1,:),target_points(2,:),target_points(3,:),'.','MarkerSize',2,'Color','#6577B0');
% T=eval.T;
move_points=T*source_points;
theroy_points=(T1*T0)^-1*source_points;
c=zeros(length(source_points(1,:)),1);
for k=1:length(source_points(1,:))
    d=norm(move_points(:,k)-theroy_points(:,k));
    c(k)=d;
end
%                 s=scatter3(move_points(1,:),move_points(2,:),move_points(3,:),20,c,'.');
%                 caxis([0,0.02]);
% 
s=scatter3(move_points(1,:),move_points(2,:),move_points(3,:),20,log10(c),'.');
caxis([-3,-1]);
colormap("jet")
%             plot3(move_points(1,:),move_points(2,:),move_points(3,:),'.','MarkerSize',2,'Color','red');


r=sqrt(sum(c.^2)/length(source_points(1,:)));
r_str=sprintf('r=%.3emm',r);
colorbar('Ticks',linspace(-3,-1,6),'location','southoutside')
title({"Welsch-ptpln";r_str},'FontSize',10);
view(37.8000,67.3809);