clear,clc
p=[-4:0.1:4]; %神经网络输入值
t=sin(pi*p); %神经网络目标值
n=6; %隐藏层神经元个数
net=newff(minmax(p),[1,n,1],{'tansig','tansig','purelin'},'trainlm'); %建立网络结构
net.trainParam.epochs=200; %最大训练步数
net.trainParam.goal=0.1; %最大训练误差
net=train(net,p,t); %训练网络
y=net(p); %神经网络输出值
plot(p,t,'*',p,y,'-')
title('使用BP神经网络函数逼近');
xlabel('输入值');
ylabel('目标值/输出值');
mse=mse(y,t) %实际误差

