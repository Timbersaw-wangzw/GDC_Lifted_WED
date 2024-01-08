function  Welsch_ICP(source_points,target_points,target_normals,type,T)
source_pts=pointCloud(single(source_points)');
target_pts=pointCloud(single(target_points)');
target_pts.Normal=single(target_normals)';
pcwrite(source_pts,'Welsch/source_points.ply');
pcwrite(target_pts,'Welsch/target_points.ply');
TT=inv(T).double();
save 'Welsch/T.txt' -ascii TT
hold on
pcshow(target_pts)
pcshow(source_pts)
ExeFilePath='D:\OneDrive\DoctorPaper\Manuscript\pc_icp\code\Fast Robust ICP\Fast-Robust-ICP\build\Debug\FRICP.exe';
Param1=[' ','1'];%第一个参数，一定要有' '
Param2=[' ','15'];
Param3=[' ','1'];%第一个参数，一定要有' '
Param4=[' ','15'];
Cmd=[ExeFilePath ,Param1 ,Param2];


end

