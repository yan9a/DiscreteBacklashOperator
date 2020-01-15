%clear command windows
clc;

%clear workspace
clear all;

%close all windows
close all;
%--------------------------------------------------------------------------
load Pi.dat;
load Pc.dat;
Pc=Pc-1;
%--------------------------------------------------------------------------
%Define R, W and Y0
R=[0	0.227272727	0.53030303	0.984848485	1.696428571	2.46	3.142857142	3.624999998]';
W=[0.324799930124991;0.456393562950976;-0.0722255897419522;-0.0338007715655999;0.0492928598710330;0.0243283554753069;0.0401095827445039;0.389529710747864;];
%W=[0 0 0 1 0 0 0 0 0 0]';
Y0=R*0;
%Y0=[100 100 100 100 100 100 100 100 100 100]';
%--------------------------------------------------------------------------
x=[-4	-3.545454546	-2.93939394	-2.03030303	-0.607142857	0.919999999	2.285714283	3.249999996	3.999999995];
ya=[-4	-3.727272727	-3.242424243	-2.28939394	-1.053571428	0.579999999	1.818181816	2.952380949	3.999999995];
L=length(x);
y=zeros(L,1);
r1=y;
r2=y;
t=(1:L);
for i=1:L
    xt=x(i);
    %--------------------------
    %PI operator
    %input: xt,R,W,Y0
    %output: yt,Y0
    Y0=max(xt-R,min(xt+R,Y0));
    yt=W'*Y0;
    %--------------------------
    y(i)=yt;
end 
%--------------------------------------------------------------------------
%Plot 
hFig1 = figure(1);
set(hFig1, 'Position', [100 100 500 300])
plot(x,y,'-bs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',4)
hold on;             
plot(x,ya,'-gs','LineWidth',1,...
                 'MarkerEdgeColor','g',...
                 'MarkerFaceColor','g',...
                 'MarkerSize',2)
% plot(x,r1,'-rs','LineWidth',2,...
%                  'MarkerEdgeColor','r',...
%                  'MarkerFaceColor','r',...
%                  'MarkerSize',2)    
% plot(x,r2,'-rs','LineWidth',2,...
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
plot(t,y,'-rd','LineWidth',1,...
                 'MarkerEdgeColor','r',...
                 'MarkerFaceColor','r',...
                 'MarkerSize',4)
             
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
%find PI inverse
%input: R,W
%output: R1,W1
lh=length(W);
W1=zeros(lh,1);
R1=zeros(lh,1);
W1(1)=1/W(1);
R1(1)=0;
sw=W(1);%sum of weights
for i=2:lh
    W1(i)=-W(i)/sw;
    sw=sw+W(i);
    W1(i)=W1(i)/sw;
    R1(i)=sum((R(i)-R(1:i)).*W(1:i));
end
%--------------------------------------------------------------------------
Y0=zeros(length(W),1);
R=R1;
W=W1;
%--------------------------------------------------------------------------
tmp=ya;
ya=x;
x=ya;
L=length(x);
y=zeros(L,1);
t=(1:L);
for i=1:L
    xt=x(i);
    %--------------------------
    %PI operator
    %input: xt,R,W,Y0
    %output: yt,Y0
    Y0=max(xt-R,min(xt+R,Y0));
    yt=W'*Y0;
    %--------------------------
    y(i)=yt;
end 
%--------------------------------------------------------------------------
%Plot 
hFig3 = figure(3);
set(hFig3, 'Position', [100 510 500 300])
plot(x,y,'-bs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;             
plot(x,ya,'-gs','LineWidth',1,...
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
plot(t,x,'-bs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;
plot(t,y,'-rd','LineWidth',1,...
                 'MarkerEdgeColor','r',...
                 'MarkerFaceColor','r',...
                 'MarkerSize',4)
             
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
%[3.07881839634379;-1.79872580870270;0.130408501755715;0.0706136641913494;-
%0.100776278668368;-0.0448476064344323;-0.0678997617646165;-0.419002728833745;]
%[3.07881839634379;-1.79872580870270;0.130408501755715;0.0706136641913494;-
%0.100776278668368;-0.0448476064344324;-0.0678997617646166;-0.419002728833744;]