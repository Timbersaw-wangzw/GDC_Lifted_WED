function new_box= DividedBox( box,f0,f1,cut)
%DIVIDEDBOX 此处显示有关此函数的摘要
%   此处显示详细说明
new_box=box;
if 1==cut
    origin=[-1*box.x*f0;0;0;1];
    x0=box.x*f0;
    x1=box.x*f1;
    new_box.x=(x1-x0);
elseif 2==cut
    origin=[0;box.y*f0;0;1];
    y0=box.y*f0;
    y1=box.y*f1;
    new_box.y=y1-y0;
else
    origin=[0;0;box.z*f0;1];
    z0=box.z*f0;
    z1=box.z*f1;
    new_box.z=z1-z0;
end
origin=box.axis*origin;
new_box.axis(:,4)=origin;
end

