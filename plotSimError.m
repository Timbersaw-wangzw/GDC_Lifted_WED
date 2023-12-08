% clc


clear
close all;
addpath('ZoomPlot-MATLAB-main\')

Files = dir(fullfile('bladeData\\resultData\\*.mat'));
LengthFiles = length(Files);
k=0;
ratio=0.5;
noise=0;
er_err_vec=[];
et_err_vec=[];
rmse_err_vec=[];
all_method_names={};
temp_method_name='';
for i=1:LengthFiles
    name=Files(i).name;
    load(['bladeData\\resultData\\',name]);
    indx=strfind(name,'.mat');
    dis_name=name(1:indx-1);
    eval=evalin('base',dis_name);
    name=strrep(name,'_','-');
    method_name=name(1:indx-5);
    
    indx1=strfind(method_name,'point-to-plane');   
    indx2=strfind(method_name,'point-to-point');   
    indx3=strfind(method_name,'WES');
    indx4=strfind(method_name,'Sparse');
    matrix_idx=name(indx-3:indx-1);
    split=strsplit(matrix_idx,'-');
    num = str2double(split);


    method_name=strrep(method_name,'point-to-plane','ptpln');
    method_name=strrep(method_name,'point-to-point','ptp');
    method_name=strrep(method_name,'WES','-WED');
    method_name=strrep(method_name,'Sparse','Sparse-');
    method_name=strrep(method_name,'--','-');
    if  strcmp(temp_method_name,'')
        M=nan(5,5);
        temp_method_name=method_name;
    end
    if  ~strcmp(method_name,temp_method_name)
        M=nan(5,5);
        temp_method_name=method_name;
    end
    M(num(1),num(2))=eval.rmse(50);
    if ~isnan(M)
        k=k+1;
        all_M(k).method=method_name;
        all_M(k).M=M;
    end
    if eval.ratio==ratio&&eval.noise==noise
        er_err_vec=[er_err_vec,eval.er_vec(1:50)];
        et_err_vec=[et_err_vec,eval.et_vec(1:50)];
        rmse_err_vec=[rmse_err_vec,eval.rmse(1:50)];
        all_method_names=[all_method_names,method_name];
    end
end
% welsch ptp
welsch_ptp_rmse=importdata('Welsch\rsme\0.5_m3rsme.txt');
welsch_ptp_er=importdata('Welsch\result\0.5_m3rot_error.txt');
welsch_ptp_et=importdata('Welsch\result\0.5_m3trans_error.txt');
% welsch ptpln
welsch_ptpln_rmse=importdata('Welsch\rsme\0.5_m5rsme.txt');
welsch_ptpln_er=importdata('Welsch\result\0.5_m5rot_error.txt');
welsch_ptpln_et=importdata('Welsch\result\0.5_m5trans_error.txt');

er_err_vec=[er_err_vec,welsch_ptp_er,welsch_ptpln_er];
et_err_vec=[et_err_vec,welsch_ptp_et,welsch_ptpln_et];
rmse_err_vec=[rmse_err_vec,welsch_ptp_rmse,welsch_ptpln_rmse];
all_method_names=[all_method_names,'Welsch-ptp','Welsch-ptpln'];

ratio_values={'0','0.2','0.3','0.4','0.5'};
% ratio_values=flip(ratio_values);
noise_values={'0.001','0.025','0.005','0.01','0.015'};
% matirx color map
% for i=1:length(all_M)
%     all_M(i).method
% %     if ~strcmp(all_M(i).method,'GDC-Lifted-WED')
% %         continue;
% %     end
%     figure;
%     h=heatmap(noise_values,ratio_values,all_M(i).M);
%     h.XLabel = 'noisy level'; 
%     h.YLabel = 'Downsample ratio';
%     h.Title=all_M(i).method;
%     h.FontSize=16;
%     colormap("jet");
%     caxis([0,0.05]);
% end
% title1=sprintf('rotation error at ratio:%.1f',ratio);
% title2=sprintf('translation error at ratio:%.1f',ratio);
% title3=sprintf('rmse at ratio:%.1f',ratio);
%%  error cureve
title1='rotation error';
title2='translation error';
title3='rmse';
C = linspecer(length(all_method_names));
% C={};
% C=[C,'#0A94BF','#E68B64','#EDB121','#853A94',...
%     '#85B545','#A31631','#54C1EF','#F5C493',...
%     '#309130','#9C72C2','#E89FD1','#858585'];
% C=rand(11,3);

all_method_names=flip(all_method_names);
er_err_vec=fliplr(er_err_vec);
et_err_vec=fliplr(et_err_vec);
rmse_err_vec=fliplr(rmse_err_vec);
C1=C(1:4,:);
C2=C(5:8,:);

% C(1:4,:)=C2;
% C(5:8,:)=C1;
% C=swap(C,6,11);
C=swap(C,3,11);
C=swap(C,3,1);
a=[3,11,12];
iter_vec=30:50;
%% rotation error
figure
hold on
box on
xlim([0 50])
lineWidth=1;
for i=1:length(all_method_names)
    plot(log10(er_err_vec(:,i)),'-','LineWidth',lineWidth,'DisplayName',all_method_names{i},'Color',C(i,:));
%     plot(log10(er_err_vec(:,i)),'*-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
end
pose=[0.15 0.18 0.45 0.3];
% xlabel('iteration number')
ylabel('$log_10(E_R)$','interpreter','latex')
title(title1,'FontName','Times New Roman');
% legend('Location','northwest','NumColumns',6,'FontName','Times New Roman','Box','off')
ax1 = axes('Position',pose,'Box','on');
box on
hold on
xlim(ax1,[30,50]);
ylim(ax1,[-5,log10(er_err_vec(30,11))])
set(ax1,'ytick',[])
% axis equal
% a=[11,12];
for k=1:length(a)
    i=a(k);
    temp_err=er_err_vec(iter_vec,i);
    plot(ax1,iter_vec,log10(temp_err),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
end


%% translation error
% figure
figure
hold on
box on
xlim([0 50])
% ylim([-6,2])
% axis equal
for i=1:length(all_method_names)
    plot(log10(et_err_vec(:,i)),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
%     plot(log10(et_err_vec(:,i)),'*-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
end

% xlabel('iteration number')
ylabel('$log_10(E_t)$','interpreter','latex')
title(title2,'FontName','Times New Roman');
% axis equal
% legend; 
ax2 = axes('Position',pose,'Box','on');
box on
hold on
xlim(ax2,[30,50]);
ylim(ax2,[-4,-1.6])
% axis equal
set(ax2,'ytick',[])
for k=1:length(a)
    i=a(k);
    temp_err=et_err_vec(iter_vec,i);
    plot(ax2,iter_vec,log10(temp_err),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
end

%% rmse

figure
hold on
box on
xlim([0 50])
% ylim([-6,2])
% axis equal
for i=1:length(all_method_names)
    plot(log10(rmse_err_vec(:,i)),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
%     plot(log10(rmse_err_vec(:,i)),'*-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
end
% legend('Location','northwest','NumColumns',2);
% xlabel('iteration number')
ylabel('$log_10(rmse)$','interpreter','latex')
title(title3,'FontName','Times New Roman');

ax3 = axes('Position',pose,'Box','on');
box on
hold on
xlim(ax3,[30,50]);
ylim(ax3,[-3,-1.6])
set(ax3,'ytick',[])
% axis equal
for k=1:length(a)
    i=a(k);
    temp_err=rmse_err_vec(iter_vec,i);
    plot(ax3,iter_vec,log10(temp_err),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
end

% ax=nexttile;
% hold on
% box on

% str={};
% for i=27:3:50
%     w1=exp((i-50)/2);
%     w2=1-w1;
%     tmp=sprintf('iter:%d,w_1=%.2e; w_2=%.3f;',i,w1,w2);
%     str=[str,tmp];
%     
% end
% text(ax,25,-1.9,str,'FontName','Times New Roman','FontSize',8);
% exportgraphics(t,'bar3x3.jpg','Resolution',600)
% b=[8,11];
% for k=1:2
%     i=b(k);
%     plot(log10(rmse_err_vec(:,i)),':','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
% end
% legend('Location','northwest','NumColumns',2);
% xlabel('iteration number')
% title('enlarge graph of rmse','FontName','Times New Roman')
% zp = BaseZoom();
% zp.plot;
% zp.plot;
% zp.plot;
function C=swap(C,a,b)
CC1=C(a,:);
CC2=C(b,:);
C(a,:)=CC2;
C(b,:)=CC1;
end
