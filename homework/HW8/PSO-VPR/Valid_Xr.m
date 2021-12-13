function [new_x]=Valid_Xr(Xv_i,Xr_i,num_che)
% 对Xr进行合法化，根据Xr的编码大小调整车辆的路径
new_x=ceil(Xr_i);
for i=1:num_che
    y=ceil(Xr_i(1,Xv_i==i)); %找出所有第i辆车运输的城市
    y=[y;1:length(y)];       %得到第i辆车运送的城市以及顺序
    t=sortrows(y',1)';       %第一列为这辆车拉的第几个城市，第二列为城市的刚才对应的Xr
    for j=1:length(t(2,:))
        y(2,t(2,j))=j;
    end
    new_x(1,Xv_i==i)=y(2,:);
end
end
