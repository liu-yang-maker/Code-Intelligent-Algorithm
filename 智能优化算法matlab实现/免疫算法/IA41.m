%%%%%%%%%%%%%%%%%免疫算法求函数极值%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%初始化%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;                                %清除所有变量
close all;                                %清图
clc;                                      %清屏
D=10;                                     %免疫个体维数
NP=100;                                   %免疫个体数目
Xs=20;                                    %取值上限
Xx=-20;                                   %取值下限
G=50;                                    %最大免疫代数
pm=0.7;                                   %变异概率
alfa=1;                                   %激励度系数
belta=1;                                  %激励度系数   
detas=0.2;                                %相似度阈值
gen=0;                                    %免疫代数
Ncl=10;                                   %克隆个数
deta0=1*Xs;                               %邻域范围初值
MSLL=zeros(1,NP);                         %MSLL记录了每个抗体的亲和度
%%%%%%%%%%%%%%%%%%%%%%%初始种群（不进入循环，只执行一次）%%%%%%%%%%%%%%%%%%%%%%%%
f=rand(D,NP)*(Xs-Xx)+Xx;
for np=1:NP
    MSLL(np)=func1(f(:,np));%计算每个抗体的亲和度
end
%%%%%%%%%%%%%%%%%计算抗体浓度%%%%%%%%%%%%%%%%%%%
for np=1:NP
    for j=1:NP     
        nd(j)=sum(sqrt((f(:,np)-f(:,j)).^2));%欧式距离，且每个抗体都和其他抗体比较
        if nd(j)<detas
            nd(j)=1;
        else
            nd(j)=0;
        end
    end
    ND(np)=sum(nd)/NP;%第np个抗体的浓度
end
%%%%%%%%%%%%%%%%%计算抗体激励度MSLL%%%%%%%%%%%%%%%%%%%
MSLL =  alfa*MSLL- belta*ND;
%%%%%%%%%%%%%%%%%%%激励度按升序排列%%%%%%%%%%%%%%%%%%%%%%
[SortMSLL,Index]=sort(MSLL);%SortMSLL记录了激励度按照升序排列的结果（1*100），Index记录了原来的位置
Sortf=f(:,Index);%Sortf记录了抗体（按照其对应激励度升序排列）排列的结果（10*100）
%%%%%%%%%%%%%%%%%%%%%%%%免疫循环%%%%%%%%%%%%%%%%%%%%%%%%
while gen<G
    for i=1:NP/2
        %%%%%%%%选激励度前NP/2个体进行免疫操作%%%%%%%%%%%
        a=Sortf(:,i);
        Na=repmat(a,1,Ncl);%repmat()克隆函数，将a抗体（列向量）克隆出NC份，“1”代表列方向不克隆
        deta=deta0/gen;
        for j=1:Ncl
            for ii=1:D
                %%%%%%%%%%%%%%%%%变异%%%%%%%%%%%%%%%%%%%
                if rand<pm
                    Na(ii,j)=Na(ii,j)+(rand-0.5)*deta;
                end
                %%%%%%%%%%%%%%边界条件处理%%%%%%%%%%%%%%%
                if (Na(ii,j)>Xs)  |  (Na(ii,j)<Xx)
                    Na(ii,j)=rand * (Xs-Xx)+Xx;
                end
            end
        end
        Na(:,1)=Sortf(:,i);               %Na保留克隆源个体+9个克隆个体（前NP/2个克隆源个体依然保留在各个Na的第一个位置）
        %%%%%%%%%%克隆抑制，保留亲和度最高的个体（克隆的10个里之选出一个最好的）%%%%%%%%%%
        for j=1:Ncl
            NaMSLL(j)=func1(Na(:,j));
        end
        [NaSortMSLL,Index]=sort(NaMSLL);
        aMSLL(i)=NaSortMSLL(1);%aMSLL记录了每一轮（一轮=每一个个体及其9个克隆体）中对应的最佳目标函数结果
        NaSortf=Na(:,Index);%NaSortf记录了本轮（1+9）个抗体按序排列
        af(:,i)=NaSortf(:,1);%af记录了每一轮（一轮=每一个个体及其9个克隆体中）最好的那一个
    end 
    %%%%%%%%%%%%%%%%%%%%免疫种群激励度%%%%%%%%%%%%%%%%%%%
    for np=1:NP/2
        for j=1:NP/2
            nda(j)=sum(sqrt((af(:,np)-af(:,j)).^2));         
            if nda(j)<detas
                nda(j)=1;
            else
                nda(j)=0;
            end
        end
        aND(np)=sum(nda)/(NP/2);
    end
    aMSLL =  alfa*aMSLL-belta*aND;
    %%%%%%%%%%%%%%%%%%%%%%%种群刷新（NP/2个b种群）%%%%%%%%%%%%%%%%%%%%%%%
    bf=rand(D,NP/2)*(Xs-Xx)+Xx;
    for np=1:NP/2
        bMSLL(np)=func1(bf(:,np));
    end
    %%%%%%%%%%%%%%%%%%%新生成种群激励度%%%%%%%%%%%%%%%%%%%%
    for np=1:NP/2
        for j=1:NP/2
            ndc(j)=sum(sqrt((bf(:,np)-bf(:,j)).^2));
            if ndc(j)<detas
                ndc(j)=1;
            else
                ndc(j)=0;
            end
        end
        bND(np)=sum(ndc)/(NP/2);%bND记录了每个抗体的亲和度
    end
    bMSLL =  alfa*bMSLL-belta*bND;
    %%%%%%%%%%%%%%免疫种群与新生种群合并%%%%%%%%%%%%%%%%%%%
    f1=[af,bf];
    MSLL1=[aMSLL,bMSLL];
    [SortMSLL,Index]=sort(MSLL1);
    Sortf=f1(:,Index);
    gen=gen+1;
    trace(gen)=func1(Sortf(:,1));%记录了每次迭代的最好个体的目标函数值
end
%%%%%%%%%%%%%%%%%%%%%%%输出优化结果%%%%%%%%%%%%%%%%%%%%%%%%
Bestf=Sortf(:,1);                 %最优变量
trace(end);                       %最优值
figure,plot(trace)
xlabel('迭代次数')
ylabel('目标函数值')
title('亲和度进化曲线')