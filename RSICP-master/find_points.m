function [p1,p2,n1,n2,r] = find_points(SP,TP,SN,TN,Btree)

idx = knnsearch(Btree, SP');

p1 = SP;
n1 = SN;

p2 = TP(:,idx);
n2 = TN(:,idx);
r = sqrt(sum((p1-p2).^2));
% meanp1 = mean(p1,2);
% meanp2 = mean(p2,2);
% p1 = p1-meanp1;
% p2 = p2-meanp2;
% n = n1+n2;
% d = p2-p1;
% r=abs(dot(d,n)');
end
