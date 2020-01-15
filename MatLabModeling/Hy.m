function [ y ] = Hy(R,W,X0,x )
%Hy PI operator
%   R=Thresholds, W =weights, x=input, y=output

    L=length(x);
    y=zeros(L,1);
    LD=length(R);    
    for i=1:L
        %--------------------------
        %PI operator
        %input: x(i),R,W,X0
        %output: y(i)
        
        for j=1:LD
            %it needs ( 2 addition op , 2 comparison op ) x n
            X0(j)=max(x(i)-R(j),min(x(i)+R(j),X0(j)));
        end
        y(i)=W'*X0; % n multiplication op + (n-1) addition op
        %--------------------------
        %[x(i) X0(4) y(i)]
    end 
end
