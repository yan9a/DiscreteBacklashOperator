function y = DBS(D,B,Pi,x)
%Hysteresis DBS operator
%   D=gears, B=current state, Pi =initial pt, x=input, y=output

    L=length(x); y=zeros(L,1);
    LD=size(D);  n=LD(2);
    Xk=Pi(1); Yk=Pi(2);  Z=f0(B,n); S=f1(B,n);
    for i=1:L
        %--------------------------
        %DBS operator
        %input: x(i)
        %output: y(i)
        Xi=x(i); 
        
        while 1
            %it needs 2 comparison op and 1 addition op to check
            %one of the four possible cases
            if(Xi>= Xk)   
                if(Xi>= (Xk+D(1,Z+1)))   
                    %this case needs 3 bitwise op, 2 addition op
                    B=bitor(B,2^Z);%set bit bz
                    Xk=Xk+D(1,Z+1);
                    Yk=Yk+D(2,Z+1);
                    Z=f0(B,n); S=f1(B,n);                 
                    continue
                else
                    %this case needs 2 addition op, 2 multiplication op
                    y(i)=Yk+D(2,Z+1)/D(1,Z+1)*(Xi-Xk);
                    break
                end
            else
                if(Xi<= (Xk-D(1,S+1)))
                    %this case needs 3 bitwise op, 2 addition op
                    B=bitand(B,bitcmp(2^S,n));%clear bit bs
                    Xk=Xk-D(1,S+1);
                    Yk=Yk-D(2,S+1);
                    Z=f0(B,n); S=f1(B,n);                    
                    continue
                else
                    %this case needs 2 addition op, 2 multiplication op
                    y(i)=Yk+D(2,S+1)/D(1,S+1)*(Xi-Xk);
                    break
                end
            end
            
        end
        %End of DBS operator
        %Total number of op without state change:  2 comp, 3 add, 2 mul
        %additional op for each state change: 2 comp, 3 add, 3 bitwise
        %--------------------------
        %[x(i) X0(4) y(i)]
    end 
end
