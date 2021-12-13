%%%%%%%%%%%%%%%%%�����㷨������ֵ%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%��ʼ��%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;                                %������б���
close all;                                %��ͼ
clc;                                      %����
D=10;                                     %���߸���ά��
NP=100;                                   %���߸�����Ŀ
Xs=20;                                    %ȡֵ����
Xx=-20;                                   %ȡֵ����
G=50;                                    %������ߴ���
pm=0.7;                                   %�������
alfa=1;                                   %������ϵ��
belta=1;                                  %������ϵ��   
detas=0.2;                                %���ƶ���ֵ
gen=0;                                    %���ߴ���
Ncl=10;                                   %��¡����
deta0=1*Xs;                               %����Χ��ֵ
MSLL=zeros(1,NP);                         %MSLL��¼��ÿ��������׺Ͷ�
%%%%%%%%%%%%%%%%%%%%%%%��ʼ��Ⱥ��������ѭ����ִֻ��һ�Σ�%%%%%%%%%%%%%%%%%%%%%%%%
f=rand(D,NP)*(Xs-Xx)+Xx;
for np=1:NP
    MSLL(np)=func1(f(:,np));%����ÿ��������׺Ͷ�
end
%%%%%%%%%%%%%%%%%���㿹��Ũ��%%%%%%%%%%%%%%%%%%%
for np=1:NP
    for j=1:NP     
        nd(j)=sum(sqrt((f(:,np)-f(:,j)).^2));%ŷʽ���룬��ÿ�����嶼����������Ƚ�
        if nd(j)<detas
            nd(j)=1;
        else
            nd(j)=0;
        end
    end
    ND(np)=sum(nd)/NP;%��np�������Ũ��
end
%%%%%%%%%%%%%%%%%���㿹�弤����MSLL%%%%%%%%%%%%%%%%%%%
MSLL =  alfa*MSLL- belta*ND;
%%%%%%%%%%%%%%%%%%%�����Ȱ���������%%%%%%%%%%%%%%%%%%%%%%
[SortMSLL,Index]=sort(MSLL);%SortMSLL��¼�˼����Ȱ����������еĽ����1*100����Index��¼��ԭ����λ��
Sortf=f(:,Index);%Sortf��¼�˿��壨�������Ӧ�������������У����еĽ����10*100��
%%%%%%%%%%%%%%%%%%%%%%%%����ѭ��%%%%%%%%%%%%%%%%%%%%%%%%
while gen<G
    for i=1:NP/2
        %%%%%%%%ѡ������ǰNP/2����������߲���%%%%%%%%%%%
        a=Sortf(:,i);
        Na=repmat(a,1,Ncl);%repmat()��¡��������a���壨����������¡��NC�ݣ���1�������з��򲻿�¡
        deta=deta0/gen;
        for j=1:Ncl
            for ii=1:D
                %%%%%%%%%%%%%%%%%����%%%%%%%%%%%%%%%%%%%
                if rand<pm
                    Na(ii,j)=Na(ii,j)+(rand-0.5)*deta;
                end
                %%%%%%%%%%%%%%�߽���������%%%%%%%%%%%%%%%
                if (Na(ii,j)>Xs)  |  (Na(ii,j)<Xx)
                    Na(ii,j)=rand * (Xs-Xx)+Xx;
                end
            end
        end
        Na(:,1)=Sortf(:,i);               %Na������¡Դ����+9����¡���壨ǰNP/2����¡Դ������Ȼ�����ڸ���Na�ĵ�һ��λ�ã�
        %%%%%%%%%%��¡���ƣ������׺Ͷ���ߵĸ��壨��¡��10����֮ѡ��һ����õģ�%%%%%%%%%%
        for j=1:Ncl
            NaMSLL(j)=func1(Na(:,j));
        end
        [NaSortMSLL,Index]=sort(NaMSLL);
        aMSLL(i)=NaSortMSLL(1);%aMSLL��¼��ÿһ�֣�һ��=ÿһ�����弰��9����¡�壩�ж�Ӧ�����Ŀ�꺯�����
        NaSortf=Na(:,Index);%NaSortf��¼�˱��֣�1+9�������尴������
        af(:,i)=NaSortf(:,1);%af��¼��ÿһ�֣�һ��=ÿһ�����弰��9����¡���У���õ���һ��
    end 
    %%%%%%%%%%%%%%%%%%%%������Ⱥ������%%%%%%%%%%%%%%%%%%%
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
    %%%%%%%%%%%%%%%%%%%%%%%��Ⱥˢ�£�NP/2��b��Ⱥ��%%%%%%%%%%%%%%%%%%%%%%%
    bf=rand(D,NP/2)*(Xs-Xx)+Xx;
    for np=1:NP/2
        bMSLL(np)=func1(bf(:,np));
    end
    %%%%%%%%%%%%%%%%%%%��������Ⱥ������%%%%%%%%%%%%%%%%%%%%
    for np=1:NP/2
        for j=1:NP/2
            ndc(j)=sum(sqrt((bf(:,np)-bf(:,j)).^2));
            if ndc(j)<detas
                ndc(j)=1;
            else
                ndc(j)=0;
            end
        end
        bND(np)=sum(ndc)/(NP/2);%bND��¼��ÿ��������׺Ͷ�
    end
    bMSLL =  alfa*bMSLL-belta*bND;
    %%%%%%%%%%%%%%������Ⱥ��������Ⱥ�ϲ�%%%%%%%%%%%%%%%%%%%
    f1=[af,bf];
    MSLL1=[aMSLL,bMSLL];
    [SortMSLL,Index]=sort(MSLL1);
    Sortf=f1(:,Index);
    gen=gen+1;
    trace(gen)=func1(Sortf(:,1));%��¼��ÿ�ε�������ø����Ŀ�꺯��ֵ
end
%%%%%%%%%%%%%%%%%%%%%%%����Ż����%%%%%%%%%%%%%%%%%%%%%%%%
Bestf=Sortf(:,1);                 %���ű���
trace(end);                       %����ֵ
figure,plot(trace)
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
title('�׺ͶȽ�������')