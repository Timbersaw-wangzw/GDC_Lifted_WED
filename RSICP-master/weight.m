function w = weight(r,u)
w=zeros(1,length(r));

for i=1:length(r)
    w(i) = exp(-r(i)^2/(2*u^2));
end
end