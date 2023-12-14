clear
close all
real_name='motoRoto';
% real_name='OGVdata'
load([real_name,'\test_points.mat']);
load([real_name,'\target_points.mat']);
load([real_name,'\coarse_matrix.mat']);

Files = dir(fullfile([real_name,'\resultData\*.mat']));
LengthFiles = length(Files);
k=0;
all_method_names={};
temp_method_name='';
source_points=T1*test_points(1:3,:);
source_normals=T1.SO3*test_points(4:6,:);
target_normals=target_points(4:6,:);
target_points=target_points(1:3,:);
C = linspecer(LengthFiles);
% figure;

tiledlayout(1,2,'TileSpacing','compact','Padding','tight');
nexttile
hold on 
box on
err_vec=[];
for i=1:LengthFiles
    name=Files(i).name;
    load([Files(i).folder,'\',name]);
    indx=strfind(name,'.mat');
    dis_name=name(1:indx-1);
    eval=evalin('base',dis_name);
    method_name=strrep(dis_name,'_','-');

    method_name=strrep(method_name,'point-to-plane','ptpln');
    method_name=strrep(method_name,'point-to-point','ptp');
    method_name=strrep(method_name,'WES','-WED');
    method_name=strrep(method_name,'Sparse','Sparse-');
    method_name=strrep(method_name,'--','-');
    pt=eval.T*source_points;
    vec=alphaError(pt,target_points,0.8);
    indx=strfind(name,'GDC');
    if indx~=0
        str='-';
    else
        str='--';
    end
    plot(vec(:,1),vec(:,2),str,'DisplayName',method_name,'Color',C(i,:),'LineWidth',1.5);
    err_vec=[err_vec,vec];
end
xlabel('rmse $\alpha$','interpreter','latex')
ylabel('$\alpha$-recall','interpreter','latex')
legend('FontName','Times New Roman','Box','off')
% pose=[0.18 0.6 0.45 0.3];
% ax1 = axes('Position',pose,'Box','on');
nexttile
box on
hold on

for i=1:LengthFiles
    name=Files(i).name;
    indx=strfind(name,'GDC');
    if indx~=0
        str='-';
    else
        str='--';
    end
    plot(err_vec(:,2*i-1),log10(err_vec(:,2*i)),str,'DisplayName',method_name,'Color',C(i,:),'LineWidth',1.5);
end
xlim([0.015,0.1]);

ylabel('$log_{10}(\alpha_{recall})$','interpreter','latex')
xlabel('rmse $\alpha$','interpreter','latex')
% set(ax1,'xaxislocation','top');
% set(ax1,'yaxislocation','right');
% ylim(ax1,[0,0.01]);
