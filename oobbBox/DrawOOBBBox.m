function DrawOOBBBox( box,c ,l)
%DRAWAABBBOX »æÖÆ°üÎ§ºÐ
x=box.x;y=box.y;z=box.z;
p1=box.axis*[0;0;0;1];
p2=box.axis*[0;y;0;1];
p3=box.axis*[-1*x;y;0;1];
p4=box.axis*[-1*x;0;0;1];
p5=box.axis*[0;0;z;1];
p6=box.axis*[0;y;z;1];
p7=box.axis*[-1*x;y;z;1];
p8=box.axis*[-1*x;0;z;1];
v=box.axis;
hold on;
% quiver3(p1(1),p1(2),p1(3),v(1,1),v(2,1),v(3,1));
% quiver3(p1(1),p1(2),p1(3),v(1,2),v(2,2),v(2,3));
% quiver3(p1(1),p1(2),p1(3),v(1,3),v(2,3),v(3,3));
rec1=[p1,p2,p3,p4,p1];
rec2=[p5,p6,p7,p8,p5];
l1=[p1,p5];
l2=[p2,p6];
l3=[p3,p7];
l4=[p4,p8];
plot3(rec1(1,:),rec1(2,:),rec1(3,:),c,'LineWidth',l);
plot3(rec2(1,:),rec2(2,:),rec2(3,:),c,'LineWidth',l);
plot3(l1(1,:),l1(2,:),l1(3,:),c,'LineWidth',l);
plot3(l2(1,:),l2(2,:),l2(3,:),c,'LineWidth',l);
plot3(l3(1,:),l3(2,:),l3(3,:),c,'LineWidth',l);
plot3(l4(1,:),l4(2,:),l4(3,:),c,'LineWidth',l);
end

