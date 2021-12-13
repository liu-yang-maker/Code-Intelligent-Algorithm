% 写出一个遗传算法框架，含轮盘赌选择函数，交叉和变异算子。
% 这只是一个框架，无法运行
for k=1:G
    %%%%%%%%%%%%将二进制解码为定义域范围内十进制%%%%%%%%%%%%%%
    for i=1:NP
        U=f(i,:);%U是1*NP的矩阵，代表一个个体
        m=0;
        for j=1:L
            m=U(j)*2^(j-1)+m;%m就是如同1011101（1*L维）的数
        end
        x(i)=Xx+m*(Xs-Xx)/(2^L-1);%变成十进制
        Fit(i)= func1(x(i));
    end
    maxFit=max(Fit);           %最大值
    minFit=min(Fit);           %最小值
    rr=find(Fit==maxFit);
    fBest=f(rr(1,1),:);        %历代最优个体   
    xBest=x(rr(1,1));          %记录个体的x变量
    Fit=(Fit-minFit)/(maxFit-minFit);  %归一化适应度值
    %%%%%%%%%%%%%%%%%%基于轮盘赌的复制操作%%%%%%%%%%%%%%%%%%%
    sum_Fit=sum(Fit);
    fitvalue=Fit./sum_Fit;
    fitvalue=cumsum(fitvalue);%累加函数
    ms=sort(rand(NP,1));%sort为了递增顺序排列
    fiti=1;
    newi=1;
    while newi<=NP
        if (ms(newi))<fitvalue(fiti)
            nf(newi,:)=f(fiti,:);
            newi=newi+1;
        else
            fiti=fiti+1;
        end
    end   
    %%%%%%%%%%%%%%%%%%%%%%基于概率的交叉操作%%%%%%%%%%%%%%%%%%
    for i=1:2:NP
        p=rand;
        if p<Pc
            q=randi([0,1],L);
            for j=1:L
                if q(j)==1          %要符合条件=1（=0就不会交叉）
                    temp=nf(i+1,j);     %选择第i个染色体的第j个点进行交叉
                    nf(i+1,j)=nf(i,j);
                    nf(i,j)=temp;
                end
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%基于概率的变异操作%%%%%%%%%%%%%%%%%%%%%%%
    i=1;
    while i<=round(NP*Pm)
        h=randi(NP,1,1);      %随机选取一个需要变异的染色体
        for j=1:round(L*Pm)         
            g=randi(L,1,1);   %随机需要变异的基因数
            nf(h,g)=~nf(h,g);
        end
        i=i+1;
    end
    f=nf;
    f(1,:)=fBest;                   %保留最优个体在新种群中
    trace(k)=maxFit;                %历代最优适应度
end