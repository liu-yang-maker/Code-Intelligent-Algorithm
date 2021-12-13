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

k1 = k;
x = 1:k1;
plot(x,v2,'r');
xlabel('k');
ylabel('伪随机数');
title('0-1均匀分布的随机序列')








