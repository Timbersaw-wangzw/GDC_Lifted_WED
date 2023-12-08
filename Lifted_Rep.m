function [A,res]=Lifted_Rep(source_points,target_points,target_noromals,J,tau2,disType,robType)
mu=0;
N=length(source_points(1,:));
switch disType
    case 'point_to_point'
        A=zeros(6,6);
        res=zeros(6,1);
    case 'point_to_plane'
        A=zeros(6,6);
        res=zeros(6,1);
    case 'WES'
        A=zeros(6,12);
        res=zeros(6,2);
    case 'symmetric'
        A=zeros(6,6);
        res=zeros(6,1);
end
% N=10;
% A=zeros(6,6);
% JJ=zeros(m*N+N,6+N);
% r=zeros(m*N+N,1);
% WJ=zeros(m*N,6);
function [Qi,res_i]=lifted_J(source_point,target_point,target_noromal,disType)
    switch disType
        case 'point_to_point'
            m=4;
        case 'point_to_plane'
            m=1;
        case 'symmetric'
            m=1;
    end
    [Ji,ri]=J(source_point,target_point,target_noromal,disType);
    r2=norm(ri)^2;
    lifted=robFnc(r2,tau2,robType);
    omega = lifted.omega;
    kappa = lifted.kappa;
    dKappa = lifted.dkappa;
    dKappa2 = 2 * omega * dKappa;
    inv_dkk = 1 / (r2 + dKappa2 * dKappa2 + mu);
    a=r2;
    b=-2;
    c=inv_dkk;
    dkk=(-b- sqrt(b*b-4*a*c))/(2*a);
    
    wJi=omega*Ji;
    half_B=eye(m)-dkk*ri*ri';
    Qi=half_B*wJi;
    if isnan(Qi)
        x=0;
    end
    a1=r2 + 2 * dKappa * kappa;
    res_i=wJi'*omega * (1 - a1 * inv_dkk) * ri;
end
for i=1:N
    if  ~strcmp(disType,'WES')
        [Qi,res_i]=lifted_J(source_points(:,i),target_points(:,i),target_noromals(:,i),disType);
        A=A+Qi'*Qi;
        res=res+res_i;
    else
        [Qi1,res_i1]=lifted_J(source_points(:,i),target_points(:,i),target_noromals(:,i),'point_to_point');
        [Qi2,res_i2]=lifted_J(source_points(:,i),target_points(:,i),target_noromals(:,i),'point_to_plane');
        A(1:6,1:6)=A(1:6,1:6)+Qi1'*Qi1;
        A(1:6,7:12)=A(1:6,7:12)+Qi2'*Qi2;
        res(:,1)=res(:,1)+res_i1;
        res(:,2)=res(:,2)+res_i2;
    end
end
end