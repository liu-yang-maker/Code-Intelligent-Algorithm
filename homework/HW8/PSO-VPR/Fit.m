function fit=Fit(Xv,Xr,city,num_che)%适应度函数
cangku=[18,54];
fit=0;
for i=1:num_che       %计算每辆车的路程
    index=find(Xv==i);
    y=Xr(1,index);
    t=[index;y]';
    tt=sortrows(t,2);
    f='sqrt(x(1)^2+x(2)^2)';%匿名函数
    dist=eval(['@(x)',f]);
    if size(tt,1)~=0
        fit=fit+dist(city(tt(1,1),:)-cangku);
        if size(tt,1)>1
            for j=2:length(tt(:,1))
                fit=fit+dist(city(tt(j,1),:)-city(tt(j-1,1),:));
            end
        end
        fit=fit+dist(city(tt(end,1),:)-cangku);
    end
end
end
