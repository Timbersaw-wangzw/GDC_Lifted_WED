clc
clear
pc=pcread("move_pts0.0_normal.ply");
test_points(:,1:3)=pc.Location;
test_points(:,4:6)=pc.Normal;
test_points=test_points';
test_points=double(test_points);