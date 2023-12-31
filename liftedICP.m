function [T,er_vec,et_vec,rmse,method] = liftedICP(source_points,source_normals,target_points,target_normals,J,tau2,max_icp,disType,robType,TT)
%LIFTEDICP 此处显示有关此函数的摘要
%   此处显示详细说明
method=['Lifted_',disType];
fprintf([method,'\n']);
isSimulation=false;
if nargin==10
    isSimulation=true;
    theroy_points=(TT)^-1*source_points;
    rmse=zeros(max_icp,1);
end
T=SE3;
move_points = source_points;
move_normals = source_normals;
NS = createns(target_points','NSMethod','kdtree');
et_vec=[];
er_vec=[];
for icp=1:max_icp
    
    fprintf('iteration at %d-%d\n', icp,max_icp)
    for i=1:10
        [idx, ~] = knnsearch(NS,move_points','k',1);
        match_points= target_points(:,idx);
        match_normals=target_normals(:,idx);
        if strcmp(disType,'symmetric')
            mean_p1=mean(move_points,2);
            mean_p2=mean(match_points,2);
            p1=move_points-mean_p1;
            p2=match_points-mean_p2;
            sum_n=move_normals+match_normals;
        end
        if ~strcmp(disType,'symmetric')
            if  ~strcmp(disType,'WED')
                [A0,b0]=Lifted_Rep(move_points,match_points,match_normals,J,tau2,disType,robType);
            else
                w_pTp=exp((icp-max_icp)/2);
                w_pTpln = 1-w_pTp;
                [A,b]=Lifted_Rep(move_points,match_points,match_normals,J,tau2,disType,robType);
                A0=w_pTp*A(1:6,1:6)+w_pTpln*A(1:6,7:12);
                b0=w_pTp*b(:,1)+w_pTpln*b(:,2);
            end
            x=A0\(-b0);
            T1=SE3.exp(x);
        else
            [A0,b0]=Lifted_Rep(p1,p2,sum_n,J,tau2,disType,robType);
            x=A0\(-b0);
            rot = x(1:3); trans = x(4:6);
            rotangle = norm(rot);
            TR = rotation_matrix(rotangle, rot);
            t1=-mean_p1;
            t2=cos(rotangle)*trans;
            t3=mean_p2;
            TR=TR(1:3,1:3);
            R=TR*TR;
            t=(TR*TR*t1)+(TR*t2)+t3;
            T1=SE3(R,t);
        end
        move_points=T1*move_points;
        if strcmp(disType,'symmetric')
            move_normals=T1.SO3*move_normals;
        end
        T=T1*T;
        e=norm(T1.double()-eye(4),'fro');
        if(e<1e-4)
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
        c=zeros(length(source_points(1,:)),1);
        for i=1:length(source_points(1,:))
            c(i)=norm(move_points(:,i)-theroy_points(:,i));
        end
        rmse(icp,1)=sqrt(sum(c.^2)/length(source_points(1,:)));
    end
   if(mod(icp,2)==0)
        tau2=tau2/2;
    end
end
if isSimulation
    fprintf("final rotation error is:%e\n",er);
    fprintf("final translation error is:%e\n",et);
end
end

