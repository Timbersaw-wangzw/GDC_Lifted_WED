function [T,er_vec,et_vec,rmse,method] = RSICP(SP,TP,SN,TN,max_icp,TT)
method='robust_symmetric';
isSimulation=false;
if nargin==6
    isSimulation=true;
    TruthP=(TT)^-1*SP;
end
T = SE3;
Btree = KDTreeSearcher(TP');
[~, dist] = knnsearch(Btree,TP','k',7);
dist = dist(:,2:7);
u2 = median(median(dist,2))/(3*sqrt(3));
[p1,p2,n1,n2,r] = find_points(SP,TP,SN,TN,Btree);
u1 = 3*median(r);

er_vec=[];
et_vec=[];
rmse=[];
u1=1.7;
u2=0.05;
for i=1:max_icp
    fprintf('iteration at %d-%d\n', i,max_icp)
    T_temp=SE3;
    for j=1:10
        w = weight(r,u1);
        T0 = SE3(symm_po_pl(p1,p2,n1,n2,w));
        T_temp=T0*T_temp;
        T = T0*T;
        p1= T*SP;
        n1 = T.SO3*SN;
        [p1,p2,n1,n2,r] = find_points(p1,TP,n1,TN,Btree);
        stop2 = norm(T0.double-eye(4));
        if stop2<1e-5
            break;
        end
    end
    if isSimulation
        for k=1:length(SP(1,:))
            c(k)=norm(p1(:,k)-TruthP(:,k));
        end
        rmse_temp=sqrt(sum(c.^2)/length(SP(1,:)));
        rmse=[rmse;rmse_temp];
        eR=SO3(T*TT).double();
        t=transl(T*TT);
        er=(trace(eR)-1)/2;
        et=norm(t);
        er=acos(er);
        er_vec=[er_vec;er];
        et_vec=[et_vec;et];
    end
    if(mod(i,3)==0)
        u1 = u1/2;
    end
    if u1<u2
        u1 = u2;
    end
%     stop3 = norm(T_temp.double-eye(4));
%     if stop3<1e-5
%         break;
%     end
end

% p1=T*SP;n1=T.SO3*SN;
% [idx,dist] = knnsearch(Btree, p1');
% inliers = dist<3*u2;
% p1 = p1(:,inliers); n1 = n1(:,inliers); p2 = TP(:,idx(inliers)); n2 = TN(:,idx(inliers)); ww = weight(dist(inliers),3*u2)';
% T0 = symm_po_pl(p1,p2,n1,n2,ww);
% T = T0*T;
if isSimulation
    eR=SO3(T*TT).double();
    t=transl(T*TT);
    er=(trace(eR)-1)/2;
    et=norm(t);
    er=acos(er);
    fprintf("final rotation error is:%e\n",er);
    fprintf("final translation error is:%e\n",et);
end


