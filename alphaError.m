function percent_vec = alphaError(move_points,target_points,err)
NS = createns(target_points','NSMethod','kdtree');
[idx, ~] = knnsearch(NS,move_points','k',1);
match_points= target_points(:,idx);
M=length(move_points(1,:));
all_err=zeros(M,1);
for i=1:length(move_points(1,:))
    d=norm(move_points(:,i)-match_points(:,i));
    all_err(i)=d;
end
all_err=sort(all_err);
percent_vec=zeros(100,2);
err_delta=err/100;
for i=1:99
    N=length(find(all_err<err_delta*i));
    percent_vec(i+1,1)=err_delta*i;
    percent_vec(i+1,2)=N/M;
end
end

