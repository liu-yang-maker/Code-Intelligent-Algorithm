%适应度函数
function result=fun(x,y)
fit= exp(1)-20*exp(-0.2*(((x^2+y^2)/2)^0.5))-exp((cos(2*pi*x)+cos(2*pi*y))/2);
result=fit;