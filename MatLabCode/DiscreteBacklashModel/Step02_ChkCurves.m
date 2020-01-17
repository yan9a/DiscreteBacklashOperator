%clear command windows
clc;

%clear workspace
clear all;

%close all windows
close all;
%--------------------------------------------------------------------------
%1. Load data 

%read file
load Test_Vi_Do_Di.dat;
d=Test_Vi_Do_Di;

%define input and output column
IN_COL=9;%actuator input
OUT_COL=5;%Capacinive sensor

%define start and length of input
%si=3852;% no H inv
%si=11852;% with H inv
%si=5052;% no H inv
si=11152;% with H inv
L=1000;

%define start of output
PhaseLag=1;%current output is appeared on next sample of capacitive senr
so=si+PhaseLag;

%Lower voltage in capacitive sensor corresponds to nearer plates and lower
%voltages
%When actr inputs voltages is negatives, it pushes flexture outside,
%that makes capacitors closers, 

Di=d(si:(si+L-1),IN_COL)';
Do=d(so:(so+L-1),OUT_COL)';

Dn=length(Do);
T=5; %Sampling period -5 ms
t=T.*(1:Dn);

Do=Do-mean(Do);
%--------------------------------------------------------------------------
%Plot 
hFig1 = figure(1);
set(hFig1, 'Position', [100 100 500 300])
plot(t,Di,'-b','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
hold on;
plot(t,Do,'-r','LineWidth',1,...
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
LH=L;
xl=Di(1:LH); yl=Do(1:LH);
%xu=Di(LH+1:L); yu=Do(LH+1:L);
%--------------------------------------------------------------------------
%Plot 
hFig2 = figure(2);
set(hFig2, 'Position', [700 100 500 300])
plot(Di,Do,'-b','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',2)
grid on;
%axis([0 12 -80 80])
%set(gca,'XTick',0:2:12)
%set(gca,'YTick',-80:40:80)
%title('Output vs input')
xlabel('Input Voltage (V)');
ylabel('Output Displacement (\mum)');
% legend('Ground truth','Output from sensor',...
%        'Location','NE')
%--------------------------------------------------------------------------

