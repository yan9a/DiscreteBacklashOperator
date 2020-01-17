function [Yi B Xb Yb]= DBO(Xi,H,B,Xb,Yb)
%Hysteresis DBO operator
%Xi=input, Yi=output
%H=gears, B=current state, Xb,Yb = values of x and y for B 

%constants
n=size(H,2); 
B1=2^n-1; 
n_1=n-1;
dE=H(2,n)*0.1;% range to snap to next hysteresis state

%can be variables instead of re-calculating
Z=f0(B); S=min(f1(B),n_1); %can use feedback of Z and S also
%--------------------------
continueflag=1;
while continueflag
    %it needs 4 comparison op and 1 addition op to check
    %one of the 6 possible cases and while state
    % one more addition if snap function is added
    if(Xi>= Xb)  
        if(B==B1)%check upper bound
            %this case needs no arithmetic op
            Yi=Yb;
            continueflag=0;
        elseif(Xi>= (Xb+H(1,Z+1)-dE))   
            %this case needs 4 bitwise op, 2 addition op, 1 comparison op
            %bitwise=> or, shift z, f0, f1
            %1 comparison op for min
            B=bitor(B,2^Z);%set bit bz
            Xb=Xb+H(1,Z+1);
            Yb=Yb+H(2,Z+1);  
            Z=f0(B); S=min(f1(B),n_1); 
            continueflag=1;
        else
            %this case needs 2 addition op, 2 multiplication op
            Yi=Yb+H(2,Z+1)/H(1,Z+1)*(Xi-Xb);
            continueflag=0;
        end
    else
        if(B==0) %check lower bound 
            %this case needs no arithmetic op
            Yi=Yb;
            continueflag=0;
        elseif(Xi<= (Xb-H(1,S+1)+dE))
            %this case needs 5 bitwise op, 2 addition op
            %bitwise=> and, shift s, f0, f1, complement
            B=bitand(B,bitcmp(2^S,n));%clear bit bs
            Xb=Xb-H(1,S+1);
            Yb=Yb-H(2,S+1); 
            Z=f0(B); S=f1(B); 
            continueflag=1;           
        else
            %this case needs 2 addition op, 2 multiplication op
            Yi=Yb+H(2,S+1)/H(1,S+1)*(Xi-Xb);
            continueflag=0;
        end
    end
end %end of while
%End of DBS operator
%Total number of op without state change:  4 comp, 3 add, 2 mul
%additional op for each state change: 5 comp, 3 add, 5 bitwise
%--------------------------