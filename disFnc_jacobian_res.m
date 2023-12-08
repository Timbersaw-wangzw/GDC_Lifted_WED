function [J,res] = disFnc_jacobian_res(pi,qi,ni,method)
%POINT_TO_POINT_JACOBIAN_RES 此处显示有关此函数的摘要
%   此处显示详细说明
hat=dotVec([pi;1]);
switch method
    case 'point_to_point'
        J=hat;
        res=[pi-qi;0];
    case 'point_to_plane'
        J=[ni;1]'*hat;
        res=(pi-qi)'*ni;
    case 'symmetric'
        res=(qi-pi)'*ni;
        J=zeros(1,6);
        J(1:3)=cross(pi,ni);
        J(4:6)=ni;
end

