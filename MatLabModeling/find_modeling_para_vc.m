%clear command windows
clc;

%clear workspace
clear all;

%close all windows
close all;
%--------------------------------------------------------------------------
load xl.dat; load yl.dat;
load xu.dat; load yu.dat;

xl=xl'; yl=yl'; xu=xu'; yu=yu';
%define lower left and upper right corners for input 0 to 8.5 V
x0=0.5; y0=yl(1); x1=8.5; y1=yl(length(xl));

%--------------------------------------------------------------------------
%Plot 
hFig1 = figure(1);
set(hFig1, 'Position', [100 100 500 300])
plot(xl,yl,'-b','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(xu,yu,'-b','LineWidth',1,...
                 'MarkerEdgeColor','b',...
                 'MarkerFaceColor','b',...
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
%remove offset
xl=xl-x0; yl=yl-y0; xu=xu-x0; yu=yu-y0;


%gain A
K=(y1-y0) / (x1-x0);
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
hFig2 = figure(2);
set(hFig2, 'Position', [600 100 500 300])
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

%use order n=20
n=10;
delx=8*sqrt(2)/n;
global xs;
xs=(0:delx:delx*n);
ys0=xs*0;
options = optimset('MaxFunEvals',10000,'MaxIter',1000);
vsl =lsqcurvefit(@LineSeg,ys0,ul,vl,-10,10,options);
vsu =lsqcurvefit(@LineSeg,ys0,uu,vu,-10,10,options);

%fixed start and end points
vsl(1)=0; vsl(n+1)=0; vsu(1)=0; vsu(n+1)=0;
%find avg
vsa=(vsu+vsl)/2;

%--------------------------------------------------------------------------
%Plot 
hFig3 = figure(3);
set(hFig3, 'Position', [100 500 500 300])
plot(ul,vl,':g','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(uu,vu,':g','LineWidth',2,...
                 'MarkerEdgeColor','b',...
                 'MarkerFaceColor','b',...
                 'MarkerSize',2)
plot(xs,vsl,'-bs','LineWidth',1,...
                 'MarkerEdgeColor','b',...
                 'MarkerFaceColor','b',...
                 'MarkerSize',2) 
plot(xs,vsu,'-rs','LineWidth',1,...
 'MarkerEdgeColor','r',...
 'MarkerFaceColor','r',...
 'MarkerSize',2)
plot(xs,vsa,'-gs','LineWidth',1,...
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

nlc=R45*[xs; vsa];
hl=R45*[xs; vsl2];
hu=R45*[xs; vsu2];

xc=nlc(1,:); yc=nlc(2,:);
xhu=hu(1,:); yhu=hu(2,:);
xhl=hl(1,:); yhl=hl(2,:);



dXP=zeros(1,n); dYP=zeros(1,n); 
for i=1 : n
    dXP(i)=xc(i+1)-xc(i);
    dYP(i)=yc(i+1)-yc(i);
end
dXB=zeros(1,n); dYB=zeros(1,n); 
for i=1 : n
    dXB(i)=xhl(i+1)-xhl(i);
    dYB(i)=yhl(i+1)-yhl(i);
end
D=[dXB;dYB]; B=0; P=[dXP;dYP]; Pi=[0 0]; C=0;

xt=[(0:0.1:8) (8:-0.1:0)]';
yt=DBS(D,B,Pi,xt); xt2=yt;
%xt2=xt;
yt=DPO(P,C,Pi,xt2);

%scale
yl=yl.*K; yu=yu.*K;
yt=yt.*K;
%put back offset
xl=xl+x0; yl=yl+y0; xu=xu+x0; yu=yu+y0;
xt=xt+x0; yt=yt+y0; 
%--------------------------------------------------------------------------
%Plot 
hFig4 = figure(4);
set(hFig4, 'Position', [600 500 500 300])
plot(xl,yl,':g','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(xu,yu,':g','LineWidth',2,...
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

