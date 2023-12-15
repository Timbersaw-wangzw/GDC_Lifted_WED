function [move_points,T,er_vec,et_vec,rmse,method] = GDCLiftedICP(source_points,target_points,target_normals, ...
    O1,O2,d,delta,...
    J,tau2,max_icp, ...
    disType,robType,TT)
method=['GDC_Lifted_',disType];
fprintf(method);
isSimulation=false;
if nargin==13
    isSimulation=true;
    theroy_points=(TT)^-1*source_points;
end
T=SE3;
move_points = source_points;
rmse=zeros(max_icp,1);
NS = createns(target_points','NSMethod','kdtree');
% gamma=1;
% eta=0.5;
inital_d=norm(O1-O2);
max_con_iter=floor(max_icp/2);
% linear path
ratio=(d-1e-7-inital_d)/max_con_iter;
er_vec=[];
et_vec=[];
tol=1e-7;
% quadric path WES
% a=1/(max_icp^2);
for icp=1:max_icp
%     [idx, ~] = knnsearch(NS,move_points','k',1);
%     match_points= target_points(:,idx);
%     match_normals=target_normals(:,idx);
    T_temp=SE3;
    for inner=1:100
        [idx, ~] = knnsearch(NS,move_points','k',1);
        match_points= target_points(:,idx);
        match_normals=target_normals(:,idx);
        if  ~strcmp(disType,'WES')
            [A0,b0]=Lifted_Rep(move_points,match_points,match_normals,J,tau2,disType,robType);
        else
            w_pTp=exp((icp-max_icp)/2);
            w_pTpln = 1-w_pTp;
            [A,b]=Lifted_Rep(move_points,match_points,match_normals,J,tau2,disType,robType);
            A0=w_pTp*A(1:6,1:6)+w_pTpln*A(1:6,7:12);
            b0=w_pTp*b(:,1)+w_pTpln*b(:,2);
        end
        A1=dotVec(O1);
        b1=[O1-O2;0];
        new_d=norm(b1);
        if abs(norm(O1-O2)-d)<1.2
            lb=d-tol-delta;
        else
            lb_d=inital_d+icp*ratio;
            if(lb_d>d||new_d>d)
                lb=d-tol;
            else
                lb=max([new_d,lb_d]);
            end
        end
        ub=d+delta;
        fun=@(x)quadric_f(x,A0,b0);
        nonlcon=@(x)quadric_con(x,ub,A1,b1,lb);
        options = optimoptions('fmincon','Algorithm','interior-point',...
        'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true, ...
        'HessianFcn',@(x,lambda) hessianfcn(x,lambda,A0,A1), ...
        'Display','none');
        x = fmincon(fun,zeros(6,1),[],[],[],[],[],[],nonlcon,options);
        T1=SE3.exp(x);
        T_temp=T1*T_temp;
        T=T1*T;
        move_points=T1*move_points;
        O1=T1*O1;
        fprintf('constraints:%e\n',norm(O1-O2)-d)
        eR=norm(T1.double()-eye(4),"fro");
        if(eR<1e-4)
            break;
        end
    end
    if isSimulation
        eR=SO3(T*TT).double();
        t=transl(T*TT);
        er=(trace(eR)-1)/2;
        et=norm(t);
        er=acos(er);
        er_vec=[er_vec;er];
        et_vec=[et_vec;et];
        for i=1:length(source_points(1,:))
            c(i)=norm(move_points(:,i)-theroy_points(:,i));
        end
        rmse(icp,1)=sqrt(sum(c.^2)/length(source_points(1,:)));
        if (er<1e-5&&et<1e-5)
            break;
        end
    end
    eR=norm(T_temp.double()-eye(4),"fro");
    if(eR<1e-5)
        break;
    end
    fprintf('iteration at %d-%d, constraints:%e\n', icp,max_icp,norm(O1-O2)-d)
    if(mod(icp,3)==0)
        tau2=tau2/2;
    end
end
fprintf("constraints error is:%e\n",norm(O1-O2)-d);
if isSimulation
    fprintf("final rotation error is:%e\n",er);
    fprintf("final translation error is:%e\n",et);
end
end
function [c,ceq,gradc,gradceq]=quadric_con(x,d,A,b,lb)
    f=A*x+b;
    c(1)=f'*f-d^2;
    c(2)=lb^2-f'*f;
    ceq=[];
    g=2*(A'*A)*x+2*A'*b;
    gradc=[g,-g];
    gradceq=[];
end
function Hout = hessianfcn(x,lambda,A0,A1)
    H=A0;
    Hg1=2*(A1'*A1);
    Hg2=-2*(A1'*A1);
    Hout = H + lambda.ineqnonlin(1)*Hg1+lambda.ineqnonlin(2)*Hg2;
%     Hout = H + lambda.ineqnonlin(1)*Hg1;
end
function [f,g]=quadric_f(x,A,b)
    f=0.5*x'*A*x+b'*x;
    g=A*x+b;
end
