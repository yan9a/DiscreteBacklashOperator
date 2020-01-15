function y = DPO(P,C,Pi,x)
%Non linear DPO operator
%   P=points, C=current state, Pi =initial pt, x=input, y=output

    L=length(x); y=zeros(L,1); 
    LD=size(P);  n=LD(2); n_1=n-1;
    Xk=Pi(1); Yk=Pi(2);  CL=max(C-1,0);
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
                if(Xi> (Xk+P(1,C+1)))   
                    %this case needs 1 comp op, 3 addition op                    
                    Xk=Xk+P(1,C+1);
                    Yk=Yk+P(2,C+1);
                    if(C<n_1)
                        CL=C;
                        C=C+1;                        
                    end
                    continue
                else
                    %this case needs 2 addition op, 2 multiplication op
                    y(i)=Yk+P(2,C+1)/P(1,C+1)*(Xi-Xk);
                    break
                end
            else
                if(Xi< (Xk-P(1,CL+1)))
                    %this case needs 1 cmp op, 3 addition op                    
                    Xk=Xk-P(1,CL+1);
                    Yk=Yk-P(2,CL+1);
                    C=CL;
                    if(CL>0)
                        CL=CL-1;                       
                    end;
                    continue
                else
                    %this case needs 2 addition op, 2 multiplication op
                    y(i)=Yk+P(2,CL+1)/P(1,CL+1)*(Xi-Xk);
                    break
                end
            end
            
        end
        %End of DPO operator
        %Total number of op without state change:  2 comp, 3 add, 2 mul
        %additional op for each state change: 3 comp, 4 add
        %--------------------------
        %[x(i) X0(4) y(i)]
    end 
end
