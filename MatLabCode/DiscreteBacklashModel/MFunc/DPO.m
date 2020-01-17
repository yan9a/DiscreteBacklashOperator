function [Yi P Xp Yp]= DPO(Xi,S,P,Xp,Yp)
%DPO operator
%Xi=input, Yi=output
%S=points parameters, P=current point, Xp,Yp = values of x and y for P

%constants
n_1=size(S,2)-1;
%--------------------------
continueflag=1;
while continueflag
    %it needs up to 4 comparison op and 1 addition op to check
    %one of the 5 possible cases and while state
    if(Xi>= Xp)   
        if(Xi>(Xp+S(1,P+1)))                                               
            if(P<n_1)
                %this case needs 3 addition op
                Xp=Xp+S(1,P+1);
                Yp=Yp+S(2,P+1);
                P=P+1;  
                continueflag=1;
            else
                %this case needs 1 addition op
                Yi=Yp+S(2,P+1);
                continueflag=0;
            end             
        else
            %this case needs 2 addition op, 2 multiplication op
            Yi=Yp+S(2,P+1)/S(1,P+1)*(Xi-Xp);
            continueflag=0;
        end
    else
        if(P>0)
            %this case needs 3 addition op
            P=P-1;                    
            Xp=Xp-S(1,P+1);
            Yp=Yp-S(2,P+1);
            continueflag=1;
        else
            %this case needs no arithmetic op
            Yi=Yp;
            continueflag=0;
        end;
    end

end %end of while
%End of DPO operator
%Total number of op without state change:  4 comp, 2 add, 2 mul
%additional op for each state change: 4 comp, 4 add
%--------------------------
