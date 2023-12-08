function generateData(ratio,T)

    data00=importdata('Initial_Data\\inital_source_points.txt');
    data02=importdata('target_points.txt');
    target_points_normals=data02';
    target_points=target_points_normals(1:3,:);
    source_points=data00';
    b=OOBBBox(source_points);
    b1=DividedBox(b,ratio,1,2);
%     DrawOOBBBox(b1,'b',1);
    filter_points=zeros(3,1);
 
    for i=1:length(source_points(1,:))
        if isIntheBox(b1,source_points(:,i))
            filter_points=[filter_points,source_points(:,i)];
        end
    end
    test_points=T*filter_points;
%     test_points=filter_points;
    move_pts=pointCloud(test_points');
    str_e1 = sprintf('bladeData\\test_points%0.1f.mat',ratio);
    str_e2 = sprintf('bladeData\\move_pts%0.1f.ply',ratio);
    pcwrite(move_pts,str_e2);
    save(str_e1,"test_points");
%     
    hold on
    axis off
    plot3(test_points(1,:),test_points(2,:),test_points(3,:),'r.','MarkerSize',2.5);
    plot3(target_points(1,:),target_points(2,:),target_points(3,:),'k.','MarkerSize',2.5);
end