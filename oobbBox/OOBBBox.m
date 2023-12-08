function [box,center_axis] = OOBBBox(source_points)
%oobbb oriented bounding box
d=length(source_points(:,1));
N=length(source_points(1,:));
if(d==3)
    source_points=[source_points;ones(1,N)];
end
ave_pt=[0;0;0];
for i=1:length(source_points(1:3,:))
    ave_pt=source_points(1:3,i)+ave_pt;
end
ave_pt=ave_pt/length(source_points(1,:));
[v,~]=GetNormal(ave_pt,source_points(1:3,:),0,false);
v=[v,ave_pt;0,0,0,1];
nx=[1,0,0];
f=nx*v(1:3,1);
if f<0
    v(1:3,1)=-1*v(1:3,1);
end
ny=[0,1,0];
f=ny*v(1:3,2);
if f<0
    v(1:3,2)=-1*v(1:3,2);
end
nz=[0,0,1];
f=nz*v(1:3,3);
if f<0
    v(1:3,3)=-1*v(1:3,3);
end
center_axis=v;
% quiver3(ave_pt(1),ave_pt(2),ave_pt(3),v(1,1),v(2,1),v(3,1));
% quiver3(ave_pt(1),ave_pt(2),ave_pt(3),v(1,2),v(2,2),v(2,3));
% quiver3(ave_pt(1),ave_pt(2),ave_pt(3),v(1,3),v(2,3),v(3,3));
Locate_Coord=zeros(3,length(source_points(1,:)));
Locate_Coord=(v^-1)*source_points;
xmin=min(Locate_Coord(1,:));
xmax=max(Locate_Coord(1,:));
ymin=min(Locate_Coord(2,:));
ymax=max(Locate_Coord(2,:));
zmin=min(Locate_Coord(3,:));
zmax=max(Locate_Coord(3,:));

p1=v*[xmax;ymin;zmin;1];
p2=v*[xmax;0;zmin;1];
p3=v*[0;0;zmin;1];
p4=v*[0;ymin;zmin;1];

p5=v*[xmax;ymin;0;1];
p6=v*[xmax;0;0;1];
p7=v*[0;0;0;1];
p8=v*[0;ymin;0;1];

v(:,4)=p1;
box1.x=xmax;
box1.y=abs(ymin);
box1.z=abs(zmin);
box1.axis=v;

v(:,4)=p2;
box2.x=xmax;
box2.y=ymax;
box2.z=abs(zmin);
box2.axis=v;

v(:,4)=p3;
box3.x=abs(xmin);
box3.y=ymax;
box3.z=abs(zmin);
box3.axis=v;

v(:,4)=p4;
box4.x=abs(xmin);
box4.y=abs(ymin);
box4.z=abs(zmin);
box4.axis=v;

v(:,4)=p5;
box5.x=xmax;
box5.y=abs(ymin);
box5.z=zmax;
box5.axis=v;

v(:,4)=p6;
box6.x=xmax;
box6.y=ymax;
box6.z=zmax;
box6.axis=v;

v(:,4)=p7;
box7.x=abs(xmin);
box7.y=ymax;
box7.z=zmax;
box7.axis=v;

v(:,4)=p8;
box8.x=abs(xmin);
box8.y=abs(ymin);
box8.z=zmax;
box8.axis=v;

v(:,4)=p1;
box9.x=xmax-xmin;
box9.y=ymax-ymin;
box9.z=zmax-zmin;
box9.axis=v;
box=box9;
% hold on
% plot3(p1(1),p1(2),p1(3),'g*');
% plot3(p2(1),p2(2),p2(3),'r*');
% plot3(p3(1),p3(2),p3(3),'r*');
% plot3(p4(1),p4(2),p4(3),'r*');
% plot3(p5(1),p5(2),p5(3),'r*');
% plot3(p6(1),p6(2),p6(3),'r*');
% plot3(p7(1),p7(2),p7(3),'r*');
% plot3(p8(1),p8(2),p8(3),'r*');
% box=[box1,box2,box3,box4,box5,box6,box7,box8];
end

