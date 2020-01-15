%clear command windows
clc;

%clear workspace
clear all;

%close all windows
close all;
%--------------------------------------------------------------------------
global peakAi
global R
global D
D=(0:1:7)';
R=[0 0.227272727 0.53030303 0.984848485 1.696428571 2.46 3.142857142 3.624999998]';
%--------------------------------------------------------------------------
load ActrI_CSensor_ActrV_Hz1000.dat;%load data file
d=ActrI_CSensor_ActrV_Hz1000;
s1=59*1000+461;%start point
e1=s1+1000-1;%end point to get 1 second period

%actuator interpolation makes 1 sample delay, we don't take account it
PhaseLagSN=1;
s2=s1-PhaseLagSN;
e2=e1-PhaseLagSN;

ACTRI=3;%actuator input
CapS=5;%Capacinive sensor

Ao=-d(s1:e1,CapS);%get sensor value (input positive is output negative)
Ai=d(s2:e2,ACTRI);%get input
n=length(Ao);
t=(1:n)';%time in millisecond because sampling rate is 1k

maxAo=max(Ao); minAo=min(Ao);
maxAi=max(Ai); minAi=min(Ai);
offsetAi=(maxAi+minAi)/2;
offsetAo=(maxAo+minAo)/2;

Ao=Ao-offsetAo;%adjust offset
Ai=Ai-offsetAi;%adjust offset

Ao=Ao/(maxAo-minAo)*(maxAi-minAi);%convert position to volt
dEr=Ao-Ai;
%--------------------------------------------------------------------------
%Plot wave
hFig1 = figure(1);
set(hFig1, 'Position', [100 500 500 300])
plot(t,Ao,'-bs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(t,Ai,'-gs','LineWidth',2,...
                 'MarkerEdgeColor','g',...
                 'MarkerFaceColor','g',...
                 'MarkerSize',2)
plot(t,dEr,'-rs','LineWidth',2,...
                 'MarkerEdgeColor','r',...
                 'MarkerFaceColor','r',...
                 'MarkerSize',2)             
hold off;        
grid on;
%axis([0 12 -200 100])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-200:50:100)
title('Position vs Time')
xlabel('Time (s)');
ylabel('Volt (V)');
legend('output','input','error',...
        'Location','NE')
%--------------------------------------------------------------------------

peakAi=(maxAi-minAi)/2;
wLen=length(R)+length(D);
W0=0.5*ones(wLen,1);
options = optimset('MaxFunEvals',10000,'MaxIter',1000);
[Wf,resnorm,residual,exitflag,output] =lsqcurvefit(@HyDz,W0,Ai,Ao,-10,10,options);
Am=HyDz(Wf,Ai);

%--------------------------------------------------------------------------
%Plot curve
hFig2 = figure(2);
set(hFig2, 'Position', [700 500 500 300])
plot(Ai,Ao,'-gs','LineWidth',1,...
                'MarkerEdgeColor','g',...
                'MarkerFaceColor','g',...
                'MarkerSize',2)
hold on;
plot(Ai,Am,'-bs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold off;        
grid on;
%axis([0 12 -80 80])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-80:40:80)
title('Output vs input')
xlabel('Input Volt');
ylabel('Output Volt');
legend('input','model',...
         'Location','NW')
%--------------------------------------------------------------------------
Wh=Wf(1:length(R));
Ws=Wf(length(R)+1:length(Wf));
%--------------------------------------------------------------------------
%find DZ operator inverse
%input: D,Ws
%output: D1,Ws1
lh=length(Ws);
Ws1=zeros(lh,1);
D1=zeros(lh,1);
Ws1(1)=1/Ws(1);
D1(1)=0;
sw=Ws(1);%sum of weights
for i=2:lh
    Ws1(i)=-Ws(i)/sw;
    sw=sw+Ws(i);
    Ws1(i)=Ws1(i)/sw;
    D1(i)=sum((D(i)-D(1:i)).*Ws(1:i));
end
%--------------------------------------------------------------------------
%find PI inverse
%input: R,Wh
%output: R1,Wh1
lh=length(Wh);
Wh1=zeros(lh,1);
R1=zeros(lh,1);
Wh1(1)=1/Wh(1);
R1(1)=0;
sw=Wh(1);%sum of weights
for i=2:lh
    Wh1(i)=-Wh(i)/sw;
    sw=sw+Wh(i);
    Wh1(i)=Wh1(i)/sw;
    R1(i)=sum((R(i)-R(1:i)).*Wh(1:i));
end
%--------------------------------------------------------------------------