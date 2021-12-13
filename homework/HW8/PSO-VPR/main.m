clear;
close all;
clc;
%% 参数设置
city=[22,60;58,69;71,71;83,46;91,38;24,42;18,40];%城市坐标
num_city=size(city,1);
need=[0.89;0.14;0.28;0.33;0.21;0.41;0.57];%城市的需求量
num_che=3;  %车辆个数
num_gen=50;
num_pop=80;
c1=1.49445;
c2=1.49445;
w=0.729;    %惯性权重
%% 初始化
Xv=zeros(num_pop,num_city);
Xr=zeros(num_pop,num_city);
Vv=zeros(num_pop,num_city); 
Vr=zeros(num_pop,num_city);
fit=zeros(num_pop,1);       %存放种群的适应度值
for i=1:num_pop
    for j=1:num_city %生成初始解
        Xv(i,j)=randperm(num_che,1);
        Xr(i,j)=randperm(num_city,1);
        Vv(i,j)=randperm(2,1)-2;
        Vr(i,j)=randperm(12,1)-6;
    end
    %对Xr按行进行合法化
    Xr(i,:)=Valid_Xr(Xv(i,:),Xr(i,:),num_che);
    Capacity=zeros(1,num_che);
    for j=1:num_che 
        Capacity(j)=sum(need(find(Xv(i,:)==j)));
    end
    if ~isempty(find(Capacity>1,1))
        fit(i)=inf; %不满足汽车容量限制的粒子的适应值取无穷大
    else            %满足汽车容量限制，就取欧式距离
        fit(i)=Fit(Xv(i,:),Xr(i,:),city,num_che);%计算满足条件的解的适应值
    end
end
%% 迭代准备
%对初始化情况进行记录
person_best_fit=fit;%个体最优值
person_best_Xv=Xv;  %个体最优路径
person_best_Xr=Xr;
[globalbest_fit,globalbest_fit_index]=min(person_best_fit);%全局最优值
globalbest_route=[person_best_Xv(globalbest_fit_index,:);person_best_Xr(globalbest_fit_index,:)];%全局最优路径
%% 迭代
mem_global_bestfit=zeros(num_gen,1);%记录每一次迭代的全局最优值
mem_global_bestfit(1)=globalbest_fit;
gen=2;
while(gen<=num_gen)
    for i=1:num_pop
        Vv(i,:)=w*Vv(i,:)+c1*rand*(person_best_Xv(i,:)-Xv(i,:))+c2*rand*(globalbest_route(1,:)-Xv(i,:));
        Xv(i,:)=Xv(i,:)+Vv(i,:);
        Vr(i,:)=w*Vr(i,:)+c1*rand*(person_best_Xr(i,:)-Xr(i,:))+c2*rand*(globalbest_route(2,:)-Xr(i,:));
        Xr(i,:)=Xr(i,:)+Vr(i,:);
        Xv(i,:)=Valid_Xv(Xv(i,:),num_che);%规范化
        Xr(i,:)=Valid_Xr(Xv(i,:),Xr(i,:),num_che);
        for j=1:num_che     %惩罚项
            Capacity(j)=sum(need(find(Xv(i,:)==j)));
        end
        if isempty(find(Capacity>1,1))==0
            fit(i)=inf;
        else
            fit(i)=Fit(Xv(i,:),Xr(i,:),city,num_che);
        end  
    end
    %根据新的种群更新所有的局部最优解
    for i=1:num_pop
        if person_best_fit(i)>fit(i)
            person_best_fit(i)=fit(i);
            person_best_Xv(i,:)=Xv(i,:);
            person_best_Xr(i,:)=Xr(i,:);
        end
    end
    %根据所有的的局部最优解更新全局最优解
    if min(person_best_fit)<globalbest_fit
        [globalbest_fit,globalbest_fit_index]=min(person_best_fit);
        globalbest_route=[person_best_Xv(globalbest_fit_index,:);person_best_Xr(globalbest_fit_index,:)];
    end
    %记录每一代的全局最优解
    mem_global_bestfit(gen)=globalbest_fit;    
    gen=gen+1;
end    
%% 结果输出
plot(mem_global_bestfit,'k');
title('全局最小值变化曲线');
xlabel('迭代次数');
ylabel('总路程');
