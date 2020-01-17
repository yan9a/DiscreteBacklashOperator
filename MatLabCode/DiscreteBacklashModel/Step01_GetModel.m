%clear command windows
clc;

%clear workspace
clear all;

%close all windows
close all;
%--------------------------------------------------------------------------
%Step 01. Load data 
%read file
load Model_Vi_Do.dat;

Fs=200;  %sampling freq 200 Hz
Fi=1;    %Freq of input wave
n=25;    %order n
%--------------------------------------------------------------------------
%define start and length of input
si=3152;
L=Fs/Fi; %length for one cycle
d=Model_Vi_Do;

%define input and output column
IN_COL=1;%actuator input
OUT_COL=5;%Capacinive sensor

%define start of output
PhaseLag=0;%current output is appeared on next sample of capacitive senr
so=si+PhaseLag;

%Lower voltage in capacitive sensor corresponds to nearer plates and lower
%voltages
%When actr inputs voltages is negatives, it pushes flexture outside,
%that makes capacitors closers, 

Di=d(si:(si+L-1),IN_COL)';
Do=d(so:(so+L-1),OUT_COL)';

nD=length(Do);
T=1000/Fs; %Sampling period -5 ms
t=T.*(1:nD);

Do=Do-mean(Do);
%--------------------------------------------------------------------------
%Plot 
hFig1 = figure(1);
%set(hFig1, 'Position', [100 450 500 300])
plot(t,Di,'-bs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;
plot(t,Do,'-rd','LineWidth',1,...
                 'MarkerEdgeColor','r',...
                 'MarkerFaceColor','r',...
                 'MarkerSize',2)                    
hold off;        
grid on;
%axis([0 12 -80 80])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-80:40:80)
%title('Output vs input')
xlabel('Time (ms)');
ylabel('Output Displacement (\mum)');
% legend('Ground truth','Output from sensor',...
%        'Location','NE')
%--------------------------------------------------------------------------
%Split into lower part and upper part
LH=L/2;
xl=Di(1:LH); yl=Do(1:LH);
xu=Di(LH+1:L); yu=Do(LH+1:L);
%--------------------------------------------------------------------------
%Plot 
hFig2 = figure(2);
%set(hFig2, 'Position', [700 450 500 300])
plot(xl,yl,'-bs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;
plot(xu,yu,'-rd','LineWidth',1,...
                 'MarkerEdgeColor','r',...
                 'MarkerFaceColor','r',...
                 'MarkerSize',2)                    
hold off;        
grid on;
%axis([0 12 -80 80])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-80:40:80)
%title('Output vs input')
xlabel('Input Voltage (V)');
ylabel('Output Displacement (\mum)');
% legend('Ground truth','Output from sensor',...
%        'Location','NE')

xOl=xl; yOl=yl;
xOu=xu; yOu=yu;
%--------------------------------------------------------------------------
%##########################################################################
%--------------------------------------------------------------------------
%Step 02 -Rotate
%define lower left and upper right corners for input 0 to full scale x-FSX 3.6 V
x0=0; y0=min([yl yu]); x1=3.6; y1=max([yl yu]);
FSX=x1-x0;
%--------------------------------------------------------------------------
%remove offset
xl=xl-x0; yl=yl-y0; xu=xu-x0; yu=yu-y0;

%scale factor
K=(y1-y0)/(x1-x0);
yl=yl./K; yu=yu./K;

%rotate
tt=pi/4;
R45=[cos(tt) -sin(tt); sin(tt) cos(tt)];
rl=R45'*[xl; yl];
ru=R45'*[xu; yu];
ul=rl(1,:);vl=rl(2,:);
uu=ru(1,:);vu=ru(2,:);
%--------------------------------------------------------------------------
%Plot 
hFig3 = figure(3);
%set(hFig3, 'Position', [100 50 500 300])
plot(xl,yl,':g','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(xu,yu,':g','LineWidth',2,...
                 'MarkerEdgeColor','b',...
                 'MarkerFaceColor','b',...
                 'MarkerSize',2)
plot(ul,vl,'-b','LineWidth',2,...
                 'MarkerEdgeColor','b',...
                 'MarkerFaceColor','b',...
                 'MarkerSize',2) 
 plot(uu,vu,'-r','LineWidth',2,...
     'MarkerEdgeColor','r',...
     'MarkerFaceColor','r',...
     'MarkerSize',2)
hold off;        
grid on;
%axis([0 12 -200 100])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-200:50:100)
% title('Position vs Time')
% xlabel('Time (s)');
% ylabel('Position (\mum)');
% legend('Ground truth','Output from sensor',...
%        'Location','NE')
%--------------------------------------------------------------------------
%lower curve with removed offset and scale
xOK=xl;
yOK=yl;
%--------------------------------------------------------------------------
save -ascii -double -tabs ./DBO_Para/K.dat K
save -ascii -double -tabs ./DBO_Para/x0.dat x0
save -ascii -double -tabs ./DBO_Para/y0.dat y0
%--------------------------------------------------------------------------
%##########################################################################
%--------------------------------------------------------------------------
%Step 03. Get parameters

global xs;
global yB;
global yE;
dU=FSX/n;
xs=(0:dU:dU*n);
yB=0; yE=FSX;
%initialize coefficients to find excluding first and list one
C0=ones(1,n-1);
%options = optimset('MaxFunEvals',1000,'MaxIter',1000);
%LowerBoundC=0;
%UpperBoundC=FSX;
%xPt =lsqcurvefit(@LineSeg,C0,yOK,xOK,LowerBoundC,UpperBoundC,options);
xPt =lsqcurvefit(@LineSeg,C0,yOK,xOK);
%fixed start and end points
xPt=[yB xPt yE];
%--------------------------------------------------------------------------
%Plot 
hFig4 = figure(4);
%set(hFig4, 'Position', [700 50 500 300])
plot(yOK,xOK,':g','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
 plot(xs,xPt,'-rs','LineWidth',2,...
     'MarkerEdgeColor','r',...
     'MarkerFaceColor','r',...
     'MarkerSize',4)
hold off;        
grid on;
%axis([0 12 -200 100])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-200:50:100)
% title('Position vs Time')
% xlabel('Time (s)');
% ylabel('Position (\mum)');
% legend('Ground truth','Output from sensor',...
%        'Location','NE')
%--------------------------------------------------------------------------
xs=xPt*sqrt(2);
yB=0; yE=0;
%initialize coefficients to find excluding first and list one
C0=zeros(1,n-1);
%options = optimset('MaxFunEvals',1000,'MaxIter',1000);
%LowerBoundC=-10;
%UpperBoundC=10;
%vsu =lsqcurvefit(@LineSeg,C0,uu,vu,LowerBoundC,UpperBoundC,options);
vsl =lsqcurvefit(@LineSeg,C0,ul,vl);%resulting coefficients in vsl
usl=xs;
%flip for us to get odd symmetry
xs=xs(n+1)-fliplr(xs);
vsu =lsqcurvefit(@LineSeg,C0,uu,vu);
usu=xs;
%fixed start and end points
vsl=[yB vsl yE]; vsu=[yB vsu yE];

%flip before avg to get odd symmetry
vsuf=fliplr(vsu);

%find avg
vsa=(vsuf+vsl)/2;

%--------------------------------------------------------------------------
%Plot 
hFig5 = figure(5);
%set(hFig5, 'Position', [150 120 500 300])
plot(ul,vl,':g','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(uu,vu,':g','LineWidth',2,...
                 'MarkerEdgeColor','b',...
                 'MarkerFaceColor','b',...
                 'MarkerSize',2)
plot(usl,vsl,'-bs','LineWidth',1,...
                 'MarkerEdgeColor','b',...
                 'MarkerFaceColor','b',...
                 'MarkerSize',2) 
plot(usu,vsu,'-rs','LineWidth',1,...
 'MarkerEdgeColor','r',...
 'MarkerFaceColor','r',...
 'MarkerSize',2)
plot(usl,vsa,'-gs','LineWidth',1,...
                 'MarkerEdgeColor','g',...
                 'MarkerFaceColor','g',...
                 'MarkerSize',2)
hold off;        
grid on;
%axis([0 12 -200 100])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-200:50:100)
% title('Position vs Time')
% xlabel('Time (s)');
% ylabel('Position (\mum)');
% legend('Ground truth','Output from sensor',...
%        'Location','NE')
%--------------------------------------------------------------------------

%subtract avg
vsu2=vsu-vsa;
vsl2=vsl-vsa;

tt=pi/4;
R45=[cos(tt) -sin(tt); sin(tt) cos(tt)];

nlc=R45*[usl; vsa];%non-linear curve
hl=R45*[usl; vsl2];%hys lower
hu=R45*[usu; vsu2];%hys upper

%separate x and y
xc=nlc(1,:); yc=nlc(2,:);
xhu=hu(1,:); yhu=hu(2,:);
xhl=hl(1,:); yhl=hl(2,:);

dX=zeros(1,n); dY=zeros(1,n); 
for i=1 : n
    dX(i)=xc(i+1)-xc(i);
    dY(i)=yc(i+1)-yc(i);
end
S=[dX;dY];
S_Inv=[dY;dX];

dX=zeros(1,n); dY=zeros(1,n); 
for i=1 : n
    dX(i)=xhl(i+1)-xhl(i);
    dY(i)=yhl(i+1)-yhl(i);
end
H=[dX;dY];
H_Inv=[dY;dX];
%--------------------------------------------------------------------------
save -ascii -double -tabs ./DBO_Para/H.dat H
save -ascii -double -tabs ./DBO_Para/S.dat S
save -ascii -double -tabs ./DBO_Para/H_Inv.dat H_Inv
save -ascii -double -tabs ./DBO_Para/S_Inv.dat S_Inv
%--------------------------------------------------------------------------
%##########################################################################
%--------------------------------------------------------------------------
%Step 04. Show model

xt=[(0:0.01:FSX) (FSX:-0.01:0)];
%xt=xt*2-FSX/2; %to show if the input is out of bound
L=length(xt); yh=zeros(L,1);

%Hysteresis DBO operator -H=gears, B=current state
B=0; Xb=0; Yb=0;
%Non linear DPO operator - S=non-linear curve, P=current state
P=0; Xp=0; Yp=0;    
    for i=1:L
        Xi=xt(i); 
        [Yi B Xb Yb]=DBO(Xi,H,B,Xb,Yb);
        [Yi P Xp Yp]=DPO(Yi,S,P,Xp,Yp);
        yh(i)=Yi;
    end  %end of for loop
%scale
yt=yh.*K;
%put back offset
xt=xt+x0; yt=yt+y0; 
%--------------------------------------------------------------------------
%Plot 
hFig6 = figure(6);
set(hFig6, 'Position', [750 120 500 300])
plot(xOl,yOl,':g','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(xOu,yOu,':g','LineWidth',2,...
                 'MarkerEdgeColor','b',...
                 'MarkerFaceColor','b',...
                 'MarkerSize',2)
plot(xt,yt,'-b','LineWidth',1,...
                 'MarkerEdgeColor','b',...
                 'MarkerFaceColor','b',...
                 'MarkerSize',2) 
% plot([xhl xhu],[yhl yhu],'-r','LineWidth',2,...
%                  'MarkerEdgeColor','r',...
%                  'MarkerFaceColor','r',...
%                  'MarkerSize',2) 
% plot(xc,yc,'-rs','LineWidth',1,...
%  'MarkerEdgeColor','r',...
%  'MarkerFaceColor','r',...
%  'MarkerSize',3) 
hold off;        
grid on;
%axis([0 12 -200 100])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-200:50:100)
% title('Position vs Time')
% xlabel('Time (s)');
% ylabel('Position (\mum)');
% legend('Ground truth','Output from sensor',...
%        'Location','NE')
%--------------------------------------------------------------------------

