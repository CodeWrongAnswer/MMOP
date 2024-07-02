ps = [];
for i=1:200
ps = [ps;PS(:,:,i)];
end
scatter(ps(:,1),ps(:,2))