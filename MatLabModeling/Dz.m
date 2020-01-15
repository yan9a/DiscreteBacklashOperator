function [ y ] = Dz( D,W,x )
%Dz One Sided Dead zone operator
%   D=Thresholds, W =weights, x=input, y=output

    L=length(x);
    %----------------------------------------------------------------------
    %Dead Zone Operator
    y=zeros(L,1);
    S=zeros(length(W),1);
    LD=length(D);
    for i=1:L
        %--------------------------
        %Dead zone operator
        %input: x(i),D,W
        %output: y(i)
        for j=1:LD
            %it needs ( 1 addition op , 1 comparison op ) x n
            S(j)=max(x(i)-D(j),0);
        end
        y(i)=W'*S;
        % n multiplication op + (n-1) addition op
        %--------------------------
    end 
end

