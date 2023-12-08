clear
load("OGVdata\resultData\GDC_Lifted_WES.mat")
load("OGVdata\resultData\GDC_point_to_plane.mat")
load("OGVdata\resultData\robust_symmetric.mat")
load('OGVData\\test_points.mat');
load('OGVData\\target_points.mat');
load('OGVData\\coarse_matrix.mat');
source_points=T1*test_points(1:3,:);
source_normals=T1.SO3*test_points(4:6,:);
target_normals=target_points(4:6,:);
target_points=target_points(1:3,:);

pt_WES=GDC_Lifted_WES.T*source_points;
pt_ptpln=GDC_point_to_plane.T*source_points;
pt_sym=robust_symmetric.T*source_points;

vec_WES=alphaError(pt_WES,target_points,0.8);
vec_ptpln=alphaError(pt_ptpln,target_points,0.8);
vec_sym=alphaError(pt_sym,target_points,0.8);
C = linspecer(3);
figure
hold on 
box on
plot(vec_ptpln(:,1),vec_ptpln(:,2),'DisplayName','GDC-Lifted-ptpln','Color',C(1,:),'LineWidth',1.5);
plot(vec_WES(:,1),vec_WES(:,2),'DisplayName','GDC-Lifted-WES','Color',C(2,:),'LineWidth',1.5);
plot(vec_sym(:,1),vec_sym(:,2),'DisplayName','robust-symmetric','Color',C(3,:),'LineWidth',1.5);


xlabel('rmse $\alpha$','interpreter','latex')
ylabel('$\alpha$-recall','interpreter','latex')
legend('FontName','Times New Roman')