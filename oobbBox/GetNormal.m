function [V,D] = GetNormal( xpt,Neighbour,h,flag)
%GETNORMAL 加权PCA或平常的PCA
NumPts=length(Neighbour(1,:));
if flag
    for i=1:NumPts
        w=sqrt(Weight(xpt,Neighbour(:,i),h));
        Q(:,i)=w*(xpt-Neighbour(:,i));
    end
else
    for i=1:NumPts
        w=1;
        Q(:,i)=w*(Neighbour(:,i)-xpt);
    end
end
C=Q*Q';
[v,D]=eig(C);
V=Schmidt_orthogonalization(v);
end
function b=Schmidt_orthogonalization(a)
[m,n] = size(a);
if(m<n)
    error('行小于列，无法计算，请转置后重新输入');
    return
end
b=zeros(m,n);
%正交化
b(:,1)=a(:,1);
for i=2:n
    for j=1:i-1
        b(:,i)=b(:,i)-dot(a(:,i),b(:,j))/dot(b(:,j),b(:,j))*b(:,j);
    end
    b(:,i)=b(:,i)+a(:,i);
end
for k=1:n
    b(:,k)=b(:,k)/norm(b(:,k));
end
end
