% clc


clear
close all;

Files = dir(fullfile('bladeData\\resultData\\*.mat'));
LengthFiles = length(Files);
k=0;
noise_vec=[0.001,0.0025,0.005,0.01,0.015];
ratio_vec=[0,0.2,0.3,0.4,0.5];
ratio_idx=1;
noise_idx=5;
ratio=ratio_vec(ratio_idx);
noise=noise_vec(noise_idx);
er_err_vec=[];
et_err_vec=[];
rmse_err_vec=[];
all_method_names={};
% e=zeros(3,1);
e=[];
temp_method_name='';
% welsch ptp
% welsch_ptp_rmse=importdata('Welsch\result\0.44_m3rmse.txt');
% welsch_ptp_er=importdata('Welsch\result\0.44_m3rot_error.txt');
% welsch_ptp_et=importdata('Welsch\result\0.44_m3trans_error.txt');
% welsch ptpln
% for ni=1:5
%     for ri=1:5
%         str=sprintf('%d%d',noise_idx,ratio_idx);
%         welsch_ptpln_rmse=importdata(['Welsch\result\',str,'_m5rmse.txt']);
%         welsch_ptpln_er=importdata(['Welsch\result\',str,'_m5rot_error.txt']);
%         welsch_ptpln_et=importdata(['Welsch\result\',str,'_m5trans_error.txt']);
%         load_T=sprintf('Welsch\\result\\%d%d_m5trans.txt',ni,ri);
%         T2=SE3(load(load_T));
%         ratio=ratio_vec(ri);
%         noise=noise_vec(ni);
%         result.method='Welsch-point-to-plane';
%         result.noise=noise;  
%         result.ratio=ratio;
%         result.rmse=welsch_ptpln_rmse;
%         result.T=T2;
%         result.er_vec=welsch_ptpln_er;
%         result.et_vec=welsch_ptpln_et;
%         result_name=sprintf('Welsch_point_to_plane_%d_%d',ri,ni);
%         assignin('base',result_name,result);
%         save(['bladeData\\resultData\\',result_name,'.mat'],result_name);
%     end
% end
% 
% for ni=1:5
%     for ri=1:5
%         str=sprintf('%d%d',noise_idx,ratio_idx);
%         welsch_ptp_rmse=importdata(['Welsch\result\',str,'_m3rmse.txt']);
%         welsch_ptp_er=importdata(['Welsch\result\',str,'_m3rot_error.txt']);
%         welsch_ptp_et=importdata(['Welsch\result\',str,'_m3trans_error.txt']);
%         load_T=sprintf('Welsch\\result\\%d%d_m3trans.txt',ni,ri);
%         T2=SE3(load(load_T));
%         ratio=ratio_vec(ri);
%         noise=noise_vec(ni);
%         result.method='Welsch-point-to-plane';
%         result.noise=noise;  
%         result.ratio=ratio;
%         result.rmse=welsch_ptp_rmse;
%         result.T=T2;
%         result.er_vec=welsch_ptp_er;
%         result.et_vec=welsch_ptp_et;
%         result_name=sprintf('Welsch_point_to_point_%d_%d',ri,ni);
%         assignin('base',result_name,result);
%         save(['bladeData\\resultData\\',result_name,'.mat'],result_name);
%     end
% end





noise=0.001;
iterNum=50;
GDC_WED_RMSE=[];
WED_RMSE=[];
GDC_ptpln_RMSE=[];
ptpln_RMSE=[];
for i=1:LengthFiles
    name=Files(i).name;
    load(['bladeData\\resultData\\',name]);
    indx=strfind(name,'.mat');
    dis_name=name(1:indx-1);
    eval=evalin('base',dis_name);
    name=strrep(name,'_','-');
    method_name=name(1:indx-5);
    
    matrix_idx=name(indx-3:indx-1);
    split=strsplit(matrix_idx,'-');
    num = str2double(split);
    
    idx=strfind(method_name,'point-to-point');
    method_name=strrep(method_name,'point-to-plane','ptpln');
    method_name=strrep(method_name,'point-to-point','ptp');
    method_name=strrep(method_name,'WES','-WED');
    method_name=strrep(method_name,'Sparse','Sparse-');
    method_name=strrep(method_name,'--','-');
    idx1=strfind(method_name,'Lifted-ptpln');
    idx2=strfind(method_name,'Lifted-WED');
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

%     if eval.ratio==ratio&&eval.noise==noise 
%     if eval.ratio==ratio&&eval.noise==noise&&isempty(idx)
%     if eval.ratio==ratio&&eval.noise==noise&&(~isempty(idx1)||~isempty(idx2))
%         dis_name
    if eval.ratio==ratio&&eval.noise~=noise 
        er_err_vec=[er_err_vec,eval.er_vec(1:iterNum)];
        et_err_vec=[et_err_vec,eval.et_vec(1:iterNum)];
        rmse_err_vec=[rmse_err_vec,eval.rmse(1:iterNum)];
        all_method_names=[all_method_names,method_name];
        r=[eval.er_vec(iterNum),eval.et_vec(iterNum),eval.rmse(iterNum)];
%         e=[e;r];
    end
    if eval.noise~=noise 
        if(~isempty(idx1))
            idx3=strfind(method_name,'GDC');
        if(~isempty(idx3))
            name
            GDC_ptpln_RMSE=[GDC_ptpln_RMSE;eval.rmse(iterNum)];
        else
%             name
            ptpln_RMSE=[ptpln_RMSE;eval.rmse(iterNum)];
        end
        end
        if(~isempty(idx2))
            idx3=strfind(method_name,'GDC');
            if(~isempty(idx3))
                GDC_WED_RMSE=[GDC_WED_RMSE;eval.rmse(iterNum)];
            else
                WED_RMSE=[WED_RMSE;eval.rmse(iterNum)];
            end
    end
    end
end
% e=flipud(e);
WED=[WED_RMSE,GDC_WED_RMSE]';
PTPLN=[ptpln_RMSE,GDC_ptpln_RMSE]';
i=1;
% er_err_vec=[er_err_vec,welsch_ptpln_er(1:iterNum)];
% et_err_vec=[et_err_vec,welsch_ptpln_et(1:iterNum)];
% rmse_err_vec=[rmse_err_vec,welsch_ptpln_rmse(1:iterNum)];
% er_err_vec=[er_err_vec,welsch_ptp_er(1:iterNum),welsch_ptpln_er(1:iterNum)];
% et_err_vec=[et_err_vec,welsch_ptp_et(1:iterNum),welsch_ptpln_et(1:iterNum)];
% rmse_err_vec=[rmse_err_vec,welsch_ptp_rmse(1:iterNum),welsch_ptpln_rmse(1:iterNum)];
% all_method_names=[all_method_names,'Welsch-ptp','Welsch-ptpln'];
% all_method_names=[all_method_names,'Welsch-ptpln'];


ratio_values={'0.18','0.25','0.31','0.37','0.44'};
% ratio_values=flip(ratio_values);
noise_values={'0.001','0.025','0.005','0.01','0.015'};
noise_values=noise_values(2:5);
ratio_values=ratio_values(2:5);
% matirx color map
for i=1:length(all_M)
%     if ~strcmp(all_M(i).method,'GDC-Lifted-WED')
%         continue;
%     end
    
    idx1=strfind(all_M(i).method,'Lifted-ptpln');
    idx2=strfind(all_M(i).method,'Lifted-WED');
    if (~isempty(idx1)||~isempty(idx2))
        figure;
        temp_m=log10(all_M(i).M(2:5,2:5));
%         temp_m=all_M(i).M;
        h=heatmap(noise_values,ratio_values,temp_m);
    %     h.XLabel = 'Noisy level'; 
    %     h.YLabel = 'Overlapping ratio';
        h.Title=all_M(i).method;
        h.FontSize=16;
        colormap("jet");
        caxis([-3,-1]);
    end
end
% figure;
% h=heatmap(noise_values,ratio_values,M1);
% %     h.XLabel = 'Noisy level'; 
% %     h.YLabel = 'Overlapping ratio';
% h.Title=name1;
% h.FontSize=16;
% colormap("jet");
% caxis([0,0.05]);
% name1='Welsch-ptpln';
% M1=[9.02711	9.01454	9.0026	8.99016	9.29148;
% 8.80476	8.49102	8.73527	8.99368	8.72071;
% 8.23155	8.10462	8.05626	8.21849	8.49572;
% 7.31529	7.46486	7.56016	7.55209	7.71887;
% 6.57899	6.72695	6.73872	7.03837	6.75517;
% ];
% figure;
% h=heatmap(noise_values,ratio_values,M1);
%     h.XLabel = 'Noisy level'; 
%     h.YLabel = 'Overlapping ratio';
h.Title=name1;
h.FontSize=16;
colormap("jet");
caxis([0,0.05]);
title1=sprintf('rotation error at ratio:%.1f',ratio);
title2=sprintf('translation error at ratio:%.1f',ratio);
title3=sprintf('rmse at ratio:%.1f',ratio);
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

% all_method_names=flip(all_method_names);
% er_err_vec=fliplr(er_err_vec);
% et_err_vec=fliplr(et_err_vec);
% rmse_err_vec=fliplr(rmse_err_vec);
% C1=C(1:4,:);
% C2=C(5:8,:);
% 
% C=swap(C,3,11);
% C=swap(C,3,1);
a=[1,2,3,4];
s=40;t=50;
iter_vec=s:t;
%% rotation error
% figure
% hold on
% box on
% xlim([0 iterNum])
lineWidth=1;
% for i=1:length(all_method_names)
%     plot(log10(er_err_vec(:,i)),'-','LineWidth',lineWidth,'DisplayName',all_method_names{i},'Color',C(i,:));
% %     plot(log10(er_err_vec(:,i)),'*-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
% end
pose=[0.15 0.16 0.3 0.24];
% % xlabel('iteration number')
% ylabel('$log_10(E_R)$','interpreter','latex')
% title(title1,'FontName','Times New Roman');
% legend('Location','northwest','NumColumns',6,'FontName','Times New Roman','Box','off')
% ax1 = axes('Position',pose,'Box','on');
% box on
% hold on
% xlim(ax1,[s,t]);
% ylim(ax1,[log10(er_err_vec(t,1)),log10(er_err_vec(s,1))])
% set(ax1,'ytick',[])
% % axis equal
% a=[1,2];
% for k=1:length(a)
%     i=a(k);
%     temp_err=er_err_vec(iter_vec,i);
%     plot(ax1,iter_vec,log10(temp_err),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
% end


%% translation error
% figure
% figure
% hold on
% box on
% xlim([0 iterNum])
% % ylim([-6,2])
% % axis equal
% for i=1:length(all_method_names)
%     plot(log10(et_err_vec(:,i)),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
% %     plot(log10(et_err_vec(:,i)),'*-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
% end
% 
% % xlabel('iteration number')
% ylabel('$log_10(E_t)$','interpreter','latex')
% title(title2,'FontName','Times New Roman');
% axis equal
% legend; 
% ax2 = axes('Position',pose,'Box','on');
% box on
% hold on
% xlim(ax2,[s,t]);
% ylim(ax2,[log10(et_err_vec(t,1))-0.5,log10(et_err_vec(s,1))])
% % axis equal
% set(ax2,'ytick',[])
% for k=1:length(a)
%     i=a(k);
%     temp_err=et_err_vec(iter_vec,i);
%     plot(ax2,iter_vec,log10(temp_err),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
% end

%% rmse

figure
hold on
box on
xlim([0 iterNum])
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
legend('Location','northwest','NumColumns',6,'FontName','Times New Roman','Box','off')
ax3 = axes('Position',pose,'Box','on');
box on
hold on
xlim(ax3,[s,t]);
ylim(ax3,[log10(rmse_err_vec(t,1))-0.1,log10(rmse_err_vec(s,2))+0.1])
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
