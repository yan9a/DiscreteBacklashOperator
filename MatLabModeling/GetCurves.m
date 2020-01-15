%clear command windows
clc;

%clear workspace
clear all;

%close all windows
close all;
%--------------------------------------------------------------------------
%D:\yannaing\ResearchWork\Experiments\ExVoiceCoil\Ex20131205
%VC_LaserDoppler\SetC\Ex03_06Hz OvsI
s1=46461;
e1=s1+167-1;
load ActrI_CSensor_ActrV_Hz1000.dat;
d=ActrI_CSensor_ActrV_Hz1000;

PhaseLagSN=1;%current output is appeared on next sample of capacitive senr
s2=s1-PhaseLagSN;
e2=e1-PhaseLagSN;
%--------------------------------------------------------------------------
ACTRI=3;%actuator input
CapS=5;%Capacinive sensor
%--------------------------------------------------------------------------
%Lower voltage in capacitive sensor corresponds to nearer plates and lower
%voltages
%When actr inputs voltages is negatives, it pushes flexture outside,
%that makes capacitors closers, 

Ac=-d(s1:e1,CapS);
Ai=d(s2:e2,ACTRI);
n=length(Ac);
t=2.*(1:n)';
t=t/1000;
%--------------------------------------------------------------------------
Ac=Ac-mean(Ac);
xl=Ai(1:82); yl=Ac(1:82);
xu=Ai(86:167); yu=Ac(86:167);
%--------------------------------------------------------------------------
%Plot 
hFig2 = figure(2);
set(hFig2, 'Position', [700 100 500 300])
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
%--------------------------------------------------------------------------
save -ascii -double -tabs xl.dat xl
save -ascii -double -tabs yl.dat yl
save -ascii -double -tabs xu.dat xu
save -ascii -double -tabs yu.dat yu

