%clear command windows
clc;

%clear workspace
clear all;

%close all windows
close all;
%--------------------------------------------------------------------------
%Define D, W
D=(0:1:7)';
W=[0.100237539203700;1.26921707235047;0.180267590618615;-0.129802790710181;-0.111117829492332;-0.0942383482545810;-0.254849832667630;-8.29579755082829;];
D0=zeros(length(W),1);
%--------------------------------------------------------------------------
xa=(0:1:8);
x=xa;
ya=[0	33	66	94	122	147	169	190	210]/26.25;
L=length(x);
La=length(xa);
y=zeros(L,1);
t=(1:L);
ta=(1:La);
for i=1:L
    xt=x(i);
    %--------------------------
    %Dead zone operator
    %input: xt,D,W,Y0
    %output: yt,Y0
    D0=max(xt-D,0);
    yt=W'*D0;
    %--------------------------
    y(i)=yt;
end 
%--------------------------------------------------------------------------
%Plot 
hFig1 = figure(1);
set(hFig1, 'Position', [100 100 500 300])
plot(x,y,'-bs','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(xa,ya,'-gs','LineWidth',1,...
                 'MarkerEdgeColor','g',...
                 'MarkerFaceColor','g',...
                 'MarkerSize',2)
% plot(t,dEr,'-rs','LineWidth',2,...
%                  'MarkerEdgeColor','r',...
%                  'MarkerFaceColor','r',...
%                  'MarkerSize',2)             
hold off;        
grid on;
%axis([0 12 -200 100])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-200:50:100)
title('Output vs Input')
xlabel('Input (\mum)');
ylabel('Output (\mum)');
legend('PI operator','Actual',...
        'Location','NW')
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Plot 
hFig2 = figure(2);
set(hFig2, 'Position', [700 100 500 300])
plot(t,x,'-bs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;
plot(t,y,'-rd','LineWidth',2,...
                 'MarkerEdgeColor','r',...
                 'MarkerFaceColor','r',...
                 'MarkerSize',2)
             
plot(ta,ya,'-g','LineWidth',1,...
                 'MarkerEdgeColor','g',...
                 'MarkerFaceColor','g',...
                 'MarkerSize',2)
             
hold off;        
grid on;
%axis([0 12 -80 80])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-80:40:80)
title('Position vs time')
xlabel('Time (ms)');
ylabel('Position (\mum)');
legend('Input','PI','Actual',...
        'Location','SE')
%--------------------------------------------------------------------------
%find DZ operator inverse
%input: D,W
%output: D1,W1
lh=length(W);
W1=zeros(lh,1);
D1=zeros(lh,1);
W1(1)=1/W(1);
D1(1)=0;
sw=W(1);%sum of weights
for i=2:lh
    W1(i)=-W(i)/sw;
    sw=sw+W(i);
    W1(i)=W1(i)/sw;
    D1(i)=sum((D(i)-D(1:i)).*W(1:i));
end
%--------------------------------------------------------------------------
D=D1;
W=W1;

tmp=ya;
ya=[0	0.457142857	1.142857143	2.171428571	3.504761905	5.219047619	6.476190476	7.314285714	8];
xa=[0	0.228571429	0.876190476	2.133333333	3.504761905	5.180952381	6.20952381	7.085714286	8];
L=length(xa);
y=zeros(L,1);
t=(1:L);
for i=1:L
    xt=xa(i);
    %--------------------------
    %Dead zone operator
    %input: xt,D,W,Y0
    %output: yt,Y0
    D0=max(xt-D,0);
    yt=W'*D0;
    %--------------------------
    y(i)=yt;
end 
%--------------------------------------------------------------------------
%Plot 
hFig3 = figure(3);
set(hFig3, 'Position', [100 510 500 300])
plot(xa,y,'-bs','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(xa,ya,'-gs','LineWidth',1,...
                 'MarkerEdgeColor','g',...
                 'MarkerFaceColor','g',...
                 'MarkerSize',2)
% plot(t,dEr,'-rs','LineWidth',2,...
%                  'MarkerEdgeColor','r',...
%                  'MarkerFaceColor','r',...
%                  'MarkerSize',2)             
hold off;        
grid on;
%axis([0 12 -200 100])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-200:50:100)
title('Output vs Input')
xlabel('Input (\mum)');
ylabel('Output (\mum)');
legend('PI operator','Actual',...
        'Location','NW')
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Plot 
hFig4 = figure(4);
set(hFig4, 'Position', [700 510 500 300])
plot(t,xa,'-bs','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;
plot(t,y,'-rd','LineWidth',2,...
                 'MarkerEdgeColor','r',...
                 'MarkerFaceColor','r',...
                 'MarkerSize',2)
             
plot(t,ya,'-g','LineWidth',1,...
                 'MarkerEdgeColor','g',...
                 'MarkerFaceColor','g',...
                 'MarkerSize',2)
             
hold off;        
grid on;
%axis([0 12 -80 80])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-80:40:80)
title('Position vs time')
xlabel('Time (ms)');
ylabel('Position (\mum)');
legend('Input','PI','Actual',...
        'Location','SE')
%--------------------------------------------------------------------------
y=y';

%[9.97630237078972;-9.24608466838254;-0.0849407627092422;0.0589883812261150;0.0597924352520979;0.0592834847246794;0.218636498399199;-1.17829024329849;]
%[9.97630237078972;-9.24608466838254;-0.0849407627092421;0.0589883812261152;0.0597924352520982;0.0592834847246796;0.218636498399200;-1.17829024329849;]
