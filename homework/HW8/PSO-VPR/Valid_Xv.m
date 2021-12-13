function [a]=Valid_Xv(Xv,num_che)  %xr规范化
a=ceil(Xv);
for m=1:length(a)
    if a(m)<1
        a(m)=1;
    elseif a(m)>num_che
        a(m)=num_che;
    end
end
end
