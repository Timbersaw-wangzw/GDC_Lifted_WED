clc
clear
origin_target_points=pcread("OGVdata\ogv_origin_fix_pts.ply");
origin_source_points=pcread("OGVdata\ogv_origin_move_pts.ply");
%% Downsample
gridStep = 2.5;
ptCloudA = pcdownsample(origin_target_points,'gridAverage',gridStep);
ptCloudB = pcdownsample(origin_source_points,'gridAverage',gridStep);
b=OOBBBox(ptCloudB.Location');
b1=DividedBox(b,0,1,0);
idx=[];
for i=1:ptCloudA.Count
    if ~ptCloudA.Normal(i,:)==zeros(3,1)
        idx=[idx;i];
    end
end
ptCloudA=select(ptCloudA,idx);
idx=[];
for i=1:ptCloudB.Count
    if isIntheBox(b1,ptCloudB.Location(i,:)')
        if ~ptCloudB.Normal(i,:)==zeros(3,1)
            idx=[idx;i];
        end
    end
end
source_points=select(ptCloudB,idx);
test_points(1:3,:)=double(source_points.Location');
test_points(4:6,:)=double(source_points.Normal');
target_points(1:3,:)=double(ptCloudA.Location');
target_points(4:6,:)=double(ptCloudA.Normal');
save("OGVdata\test_points.mat","test_points");
save("OGVdata\target_points.mat","target_points");
figure;
hold on
pcshow(ptCloudA);
% pcshow(ptCloudB);
pcshow(source_points);
pcwrite(ptCloudA,'ogv_fix_pts.ply');
pcwrite(source_points,'ogv_move_pts.ply');