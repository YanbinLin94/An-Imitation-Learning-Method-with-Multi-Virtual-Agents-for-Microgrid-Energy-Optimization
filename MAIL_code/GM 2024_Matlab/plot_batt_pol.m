clear all;clc;
%plot the results of multiple imitation learning
data=csvread('comparative_batt_pol_soc51.csv');
proposed_method = data(1,:);
dp = data(2,:);
Aggregated = data(3,:);

t=1:1:24;
figure()
subplot(3,1,1)
stairs(t,proposed_method,'r')
ylim([0 1])
set(gca, 'xlim', [1,24], 'xtick', 1:24)
ylabel('SOC',fontsize=12)
legend('MAIL',fontsize=12)
ax = gca;
ax.FontSize = 12;
subplot(3,1,2)
stairs(t,dp)
ylim([0 1])
set(gca, 'xlim', [1,24], 'xtick', 1:24)
ylabel('SOC',fontsize=12)
legend('DP',fontsize=12)
ax = gca;
ax.FontSize = 12;
subplot(3,1,3)
stairs(t,Aggregated)
ylim([0 1])
set(gca, 'xlim', [1,24], 'xtick', 1:24)
xlabel('Time(hour)',fontsize=12)
ylabel('SOC',fontsize=12)
legend('Aggregated Q',fontsize=12)
ax = gca;
ax.FontSize = 12;
% title('Output of different methods')

a=data(1:3,:);
figure()
stairs(a')
ylim([0 1])
set(gca, 'xlim', [1,24], 'xtick', 1:24)
xlabel('Time(hour)',fontsize=12)
ylabel('SOC',fontsize=12)
legend('MAIL','DP','Aggregated Q',fontsize=12)
ax = gca;
ax.FontSize = 12;
title('SOC Comparations of different methods')




