%%%%%%%%%%%%%%%%%%%%%禁忌搜索算法解决TSP问题%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;                        %清除所有变量
close all;                        %清图 
clc;                              %清屏
%C = [41 94;37 84;54 67;25 62; 7 64;2 99;68 58;71 44; 54 62;83 69;64 60;18 54; 22 60;83 46;91 38;25 38; 24 42;58 69;71 71;74 78; 87 76;18 40;13 40;82 7; 62 32; 58 35;45 21;41 26; 44 35; 4 50];
%C=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;...
%    3238 1229;4196 1044;4312  790;4386  570;3007 1970;2562 1756;...
%    2788 1491;2381 1676;1332  695;3715 1678;3918 2179;4061 2370;...
%    3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2376;...
%    3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;...
%    2370 2975];                 %31个省会城市坐标
C = [6734 1453;
 2233 10;
 5530 1424;
 401 841;
 3082 1644;
 7608 4458;
 7573 3716;
 7265 1268;
 6898 1885;
 1112 2049; 
5468 2606;
 5989 2873;
 4706 2674;
 4612 2035;
 6347 2683;
 6107 669;
 7611 5184;
 7462 3590;
 7732 4723;
 5900 3561; 
4483 3369;
 6101 1110;
 5199 2182;
 1633 2809;
 4307 2322;
 675 1006;
 7555 4819;
 7541 3981;
 3177 756;
 7352 4506; 
7545 2801;
 3245 3305;
 6426 3173;
 4608 1198;
 23 2216;
 7248 3779;
 7762 4595;
 7392 2244;
 3484 2829;
 6271 2135; 
4985 140;
 1916 1569;
 7280 4899;
 7509 3239;
 10 2676;
 6807 2993;
 5185 3258;
 3023 1942];
N=size(C,1);                      %TSP问题的规模,即城市数目
D=zeros(N);                       %任意两个城市距离间隔矩阵
%%%%%%%%%%%%%%%%%%%%%求任意两个城市距离间隔矩阵%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    for j=1:N
        D(i,j)=((C(i,1)-C(j,1))^2+...
            (C(i,2)-C(j,2))^2)^0.5;
    end
end
Tabu=zeros(N);                      %禁忌表
TabuL=round((N*(N-1)/2)^0.5);       %禁忌长度（round函数：取最近的整数）
Ca=200;                             %候选集的个数(全部领域解个数)
CaNum=zeros(Ca,N);                  %候选解集合
S0=randperm(N);                     %随机产生初始解
bestsofar=S0;                       %当前最佳解
BestL=Inf;                          %当前最佳解距离
figure(1);
p=1;
Gmax=1000;                          %最大迭代次数   
%%%%%%%%%%%%%%%%%%%%%%%%%%%禁忌搜索循环%%%%%%%%%%%%%%%%%%%%%%%%%%
while p<Gmax
    ALong(p)=func1(D,S0);            %当前解适配值
    %%%%%%%%%%%%%%%%%%%%%%%%%%%交换城市%%%%%%%%%%%%%%%%%%%%%%%%%%
    i=1;
    A=zeros(Ca,2);                   %解中交换的城市矩阵
    %%%%%%%%%%%%%%%%%求领域解中交换的城市矩阵%%%%%%%%%%%%%%%%%%%%%
    while i<=Ca
        M=N*rand(1,2);
        M=ceil(M);         
        if M(1)~=M(2)
            A(i,1)=max(M(1),M(2));
            A(i,2)=min(M(1),M(2));
            if i==1
                isa=0;
            else
                for j=1:i-1
                    if A(i,1)==A(j,1) && A(i,2)==A(j,2)
                        isa=1;
                        break;
                    else
                        isa=0;
                    end
                end
            end
            if ~isa
                i=i+1;
            else
            end
        else
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%产生领域解%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%保留前BestCaNum个最好候选解%%%%%%%%%%%%%%%%%%%
    BestCaNum=Ca/2;
    BestCa=Inf*ones(BestCaNum,4);
    F=zeros(1,Ca);
    for i=1:Ca
        CaNum(i,:)=S0;
        CaNum(i,[A(i,2),A(i,1)])=S0([A(i,1),A(i,2)]);%对城市实现交换，注意[]里的是一行（i）中的两个城市
        F(i)=func1(D,CaNum(i,:));
        if i<=BestCaNum
            BestCa(i,2)=F(i);
            BestCa(i,1)=i;
            BestCa(i,3)=S0(A(i,1));
            BestCa(i,4)=S0(A(i,2));
        else
            for j=1:BestCaNum
                if F(i)<BestCa(j,2)
                    BestCa(j,2)=F(i);
                    BestCa(j,1)=i;
                    BestCa(j,3)=S0(A(i,1));
                    BestCa(j,4)=S0(A(i,2));
                    break;
                end
            end
        end
    end
    [JL,Index]=sort(BestCa(:,2));
    SBest=BestCa(Index,:);
    BestCa=SBest;
    %%%%%%%%%%%%%%%%%%%%%%%%藐视准则%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if BestCa(1,2)<BestL
        BestL=BestCa(1,2);
        S0=CaNum(BestCa(1,1),:);
        bestsofar=S0;
        for m=1:N
            for n=1:N
                if Tabu(m,n)~=0
                    Tabu(m,n)=Tabu(m,n)-1;    
                    %更新禁忌表
                end
            end
        end
        Tabu(BestCa(1,3),BestCa(1,4))=TabuL;
        %更新禁忌表
    else
        for  i=1:BestCaNum
            if  Tabu(BestCa(i,3),BestCa(i,4))==0
                S0=CaNum(BestCa(i,1),:);
                for m=1:N
                    for n=1:N
                        if Tabu(m,n)~=0
                            Tabu(m,n)=Tabu(m,n)-1;
                            %更新禁忌表
                        end
                    end
                end
                Tabu(BestCa(i,3),BestCa(i,4))=TabuL;
                %更新禁忌表
                break;
            end
        end
    end
    ArrBestL(p)=BestL;
    p=p+1;   
    for i=1:N-1
        plot([C(bestsofar(i),1),C(bestsofar(i+1),1)],...
            [C(bestsofar(i),2),C(bestsofar(i+1),2)],'bo-');
        hold on;
    end
    plot([C(bestsofar(N),1),C(bestsofar(1),1)],...
        [C(bestsofar(N),2),C(bestsofar(1),2)],'ro-');
    title(['优化最短距离:',num2str(BestL)]);
    hold off;
    pause(0.005);
end
BestShortcut=bestsofar;            %最佳路线
theMinDistance=BestL;              %最佳路线长度
figure(2);
plot(ArrBestL); 
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')

