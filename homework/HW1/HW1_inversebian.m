A = 6;
C = 0;
M = 255;
x0 = 1;
N = 100;

for k = 1:N
    x1 = x0;
    x1 = A*x1+C;
    x1 = rem(x1,M);%x1表示模M后的余数
    
    v1 = x1/(M+1);
    v(:,k) = v1;
    
    x0 = x1;
    
end

v2 = v;

lambda = 2;
v3 = -lambda*(log2(v2));

k1 = k;
x = 1:k1;
plot(x,v3,'r');
xlabel('k');
ylabel('伪随机数');
title('逆变法实现负指数分布的产生伪随机数')




