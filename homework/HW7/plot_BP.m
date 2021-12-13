s=-3:0.01:3;
o=zeros(size(s));
sum=zeros(10,1);
for k=1:601
    for m=1:10
        sum(m,1)=sigmod(W1(m,1)*s(1,k)-B1(m,1));
    end
    o(1,k)=W2*sum-B2;
end
plot(s,o);