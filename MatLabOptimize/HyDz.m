function [y] = HyDz(W,x)

global peakAi
global R
global D

Y0=R*0;
L=length(x);
y=zeros(L,1);
Wh=W(1:length(R));
for i=1:L
    xt=x(i);
    %--------------------------
    %PI operator
    %input: xt,R,Wh,Y0
    %output: yt,Y0
    Y0=max(xt-R,min(xt+R,Y0));
    yt=Wh'*Y0;
    %--------------------------
    y(i)=yt;
end 
x=y+peakAi;
D0=zeros(length(D),1);
Ws=W(length(R)+1:length(W));
for i=1:L
    xt=x(i);
    %--------------------------
    %Dead zone operator
    %input: xt,D,Ws,D0
    %output: yt,D0
    D0=max(xt-D,0);
    yt=Ws'*D0;
    %--------------------------
    y(i)=yt;
end 
y=y-peakAi;