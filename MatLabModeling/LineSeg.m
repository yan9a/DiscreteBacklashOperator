function [y] = LineSeg(ys,x)

global xs

L=length(x);
y=zeros(1,L);
LS=length(xs);
for i=1:L
    xt=x(i);
    %--------------------------
    if(xt==0)
        y(i)=0;
    else
        %interpolate
        for j=1:LS
            x2=xs(j);
            
            if(x2>=xt) 
                y2=ys(j);
                y1=ys(j-1);
                x1=xs(j-1);
                break;
            end
        end    
        y(i)=y1+(y2-y1)/(x2-x1)*(xt-x1);
    end
end 
