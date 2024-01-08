function [J,res] = disFnc_jacobian_res(pi,qi,ni,method)
%jacobian and residual of distance metric
hat=dotVec([pi;1]);
switch method
    case 'point_to_point'
        J=hat;
        res=[pi-qi;0];
    case 'point_to_plane'
        J=[ni;1]'*hat;
        res=(pi-qi)'*ni;
    case 'symmetric'
        ci = cross(pi+qi,ni);
        J=[ci', ni'];
        res=(pi-qi)'*ni;
end

