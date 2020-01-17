function [y] = LineSeg(ys,x)

global xs
global yB
global yE
L=length(x);
y=zeros(1,L);
ys=[yB ys yE];
LS=length(ys);
for i=1:L
    xt=x(i);
    %--------------------------
    %find segment
    for j=2:LS
        if(xs(j)>=xt) 
            break;
        end
    end    
    %interpolate
    x2=xs(j);
    y2=ys(j);
    y1=ys(j-1);
    x1=xs(j-1);
    y(i)=y1+(y2-y1)/(x2-x1)*(xt-x1);
    %--------------------------
end 
