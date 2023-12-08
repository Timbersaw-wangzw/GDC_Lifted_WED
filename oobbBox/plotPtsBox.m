function plotPtsBox(source_points,box_color,box_line,ptS,isDrawBox)
%PLOTPTSBOX 此处显示有关此函数的摘要
%   此处显示详细说明

[b,~] = OOBBBox(source_points);
if isDrawBox
    DrawOOBBBox(b,box_color,box_line);
end
plot3(source_points(1,:),source_points(2,:),source_points(3,:),ptS,'MarkerSize',2.5);
end

