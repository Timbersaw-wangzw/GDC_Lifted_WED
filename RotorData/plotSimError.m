% clc


clear
close all;

Files = dir(fullfile('bladeData\\resultData\\*.mat'));
LengthFiles = length(Files);
k=0;
ratio=0;
noise=0;
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
welsch_ptpln_rmse=importdata('Welsch\result\0_m5rmse.txt');
welsch_ptpln_er=importdata('Welsch\result\0_m5rot_error.txt');
welsch_ptpln_et=importdata('Welsch\result\0_m5trans_error.txt');
iterNum=50;
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

    idx=strfind(method_name,'point-to-poin');
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
    if eval.ratio==ratio&&eval.noise==noise&&isempty(idx)
%         dis_name
%         i
        er_err_vec=[er_err_vec,eval.er_vec(1:iterNum)];
        et_err_vec=[et_err_vec,eval.et_vec(1:iterNum)];
        rmse_err_vec=[rmse_err_vec,eval.rmse(1:iterNum)];
        all_method_names=[all_method_names,method_name];
        r=[eval.er_vec(iterNum),eval.et_vec(iterNum),eval.rmse(iterNum)];
        e=[e;r];
    end
end
e=flipud(e);


er_err_vec=[er_err_vec,welsch_ptpln_er(1:iterNum)];
et_err_vec=[et_err_vec,welsch_ptpln_et(1:iterNum)];
rmse_err_vec=[rmse_err_vec,welsch_ptpln_rmse(1:iterNum)];
% er_err_vec=[er_err_vec,welsch_ptp_er(1:iterNum),welsch_ptpln_er(1:iterNum)];
% et_err_vec=[et_err_vec,welsch_ptp_et(1:iterNum),welsch_ptpln_et(1:iterNum)];
% rmse_err_vec=[rmse_err_vec,welsch_ptp_rmse(1:iterNum),welsch_ptpln_rmse(1:iterNum)];
% all_method_names=[all_method_names,'Welsch-ptp','Welsch-ptpln'];
all_method_names=[all_method_names,'Welsch-ptpln'];
% ratio_values={'0.18','0.25','0.31','0.37','0.44'};
% % ratio_values=flip(ratio_values);
% noise_values={'0.001','0.025','0.005','0.01','0.015'};
% % matirx color map
% for i=1:length(all_M)
% %     if ~strcmp(all_M(i).method,'GDC-Lifted-WED')
% %         continue;
% %     end
%     figure;
%     h=heatmap(noise_values,ratio_values,all_M(i).M);
% %     h.XLabel = 'Noisy level'; 
% %     h.YLabel = 'Overlapping ratio';
%     h.Title=all_M(i).method;
%     h.FontSize=16;
%     colormap("jet");
%     caxis([0,0.05]);
% end
% name1='Welsch-ptp';
% M1=[14.9425	14.9413	14.9411	14.858	14.9371;
% 14.8331	14.8317	14.8305	14.5036	14.4264;
% 12.9398	12.7235	13.0954	12.9803	12.7207;
% 11.3131	11.3124	11.0038	11.3071	11.3076;
% 10.0099	9.87767	9.87684	10.0098	10.0087;
% ];
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
% %     h.XLabel = 'Noisy level'; 
% %     h.YLabel = 'Overlapping ratio';
% h.Title=name1;
% h.FontSize=16;
% colormap("jet");
% caxis([0,0.05]);
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
a=[3,11,12];
iter_vec=30:50;
%% rotation error
figure
hold on
box on
xlim([0 iterNum])
lineWidth=1;
for i=1:length(all_method_names)
    plot(log10(er_err_vec(:,i)),'-','LineWidth',lineWidth,'DisplayName',all_method_names{i},'Color',C(i,:));
%     plot(log10(er_err_vec(:,i)),'*-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
end
pose=[0.15 0.18 0.45 0.3];
% xlabel('iteration number')
ylabel('$log_10(E_R)$','interpreter','latex')
title(title1,'FontName','Times New Roman');
legend('Location','northwest','NumColumns',6,'FontName','Times New Roman','Box','off')
% ax1 = axes('Position',pose,'Box','on');
% box on
% hold on
% xlim(ax1,[30,50]);
% ylim(ax1,[-5,log10(er_err_vec(30,11))])
% set(ax1,'ytick',[])
% % axis equal
% % a=[11,12];
% for k=1:length(a)
%     i=a(k);
%     temp_err=er_err_vec(iter_vec,i);
%     plot(ax1,iter_vec,log10(temp_err),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
% end


%% translation error
% figure
figure
hold on
box on
xlim([0 iterNum])
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
% ax2 = axes('Position',pose,'Box','on');
% box on
% hold on
% xlim(ax2,[30,50]);
% ylim(ax2,[-4,-1.6])
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

% ax3 = axes('Position',pose,'Box','on');
% box on
% hold on
% xlim(ax3,[30,50]);
% ylim(ax3,[-3,-1.6])
% set(ax3,'ytick',[])
% % axis equal
% for k=1:length(a)
%     i=a(k);
%     temp_err=rmse_err_vec(iter_vec,i);
%     plot(ax3,iter_vec,log10(temp_err),'-','LineWidth',lineWidth,'MarkerSize',5,'DisplayName',all_method_names{i},'Color',C(i,:));
% end

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
