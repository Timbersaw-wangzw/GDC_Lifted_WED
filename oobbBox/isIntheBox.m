function is= isIntheBox( box,pt )
%ISINTHEBOX �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
d=length(pt);
if d==3
    pt=[pt;1];
end
axis=box.axis;
x=pt(1);
local=(axis^-1)*pt;
x=local(1);y=local(2);z=local(3);
xb=box.x;yb=box.y;zb=box.z;
if(x>0||x<-1*xb||y<0||y>yb||z<0||z>zb)
    is=false;
else
    is=true;
end
end

