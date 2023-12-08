clear

% [X,Y] = meshgrid(-1:.1:1, -1:.1:1);
% Z=Ge3d(X,Y,0.02);
% mesh(X,Y,Z)
% colormap('jet')
tiledlayout(1,2,"TileSpacing","tight",'Padding','tight');
% figure
% set(gcf,'position',[250 300 600 400])

% subplot(1,2,1);
% set(gca,'position', [0.1 0.15 0.3 0.58]);

C=linspecer(4);
f1 = @(x) weight(x,5);
f2 = @(x) weight(x,1);
f3 = @(x) weight(x,0.5);
f4 = @(x) weight(x,0.02);


ax1=nexttile;
hold on
box on
fplot(ax1,f1,[-1,1],'LineWidth',1.5,'Color',C(1,:));
fplot(ax1,f2,[-1,1],'LineWidth',1.5,'Color',C(2,:));
fplot(ax1,f3,[-1,1],'LineWidth',1.5,'Color',C(3,:));
fplot(ax1,f4,[-1,1],'LineWidth',1.5,'Color',C(4,:));
xlabel('$r$','Interpreter','latex', 'FontSize', 10);
ylabel('$\omega(r)$','Interpreter','latex', 'FontSize', 10);

% set(gca,'position', [0.5 0.15 0.3 0.58]);

ax2=nexttile;
hold on
box on
g1 = @(x) Ge(x,5);
g2 = @(x) Ge(x,1);
g3 = @(x) Ge(x,0.5);
g4 = @(x) Ge(x,0.02);
f5= @(x) x^2;

fplot(ax2,g1,[-1,1],'LineWidth',1.5,'Color',C(1,:));
fplot(ax2,g2,[-1,1],'LineWidth',1.5,'Color',C(2,:));
fplot(ax2,g3,[-1,1],'LineWidth',1.5,'Color',C(3,:));
fplot(ax2,g4,[-1,1],'LineWidth',1.5,'Color',C(4,:));
% fplot(f5,[-1,1],'LineWidth',1.5,'LineStyle','--');
% ylim([0 ,2])
xlabel('$r$','Interpreter','latex', 'FontSize', 10);
ylabel('$\psi(r)$','Interpreter','latex', 'FontSize', 10);
legend('$\mu=5$','$\mu=1$','$\mu=0.5$','$\mu=0.02$','Interpreter','latex', 'FontSize', 10)
% suptitle('Lifted representation of Geman-McClure');
function f=weight(x,mu)
f=sqrt(2*mu^2/(x^2+mu)^2);
end
function psi=Ge(x,mu)
r=x^2;    
w=sqrt(2*mu^2/(r+mu)^2);
psi=0.5*(w^2*r^2+mu*(w-sqrt(2))^2);
end
function psi=Ge3d(x,w,mu)
r=x.^2;
psi=0.5*(w.^2*r.^2+mu*(w-sqrt(2))^2);
end