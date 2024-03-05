clear all;clc;
%plot the results of multiple imitation learning
data=csvread('comparative_batt_pol_soc51.csv');
proposed_method = data(1,:);
dp = data(2,:);
avijit = data(3,:);

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
stairs(t,avijit)
ylim([0 1])
set(gca, 'xlim', [1,24], 'xtick', 1:24)
xlabel('Time(hour)',fontsize=12)
ylabel('SOC',fontsize=12)
legend('Aggregated Q',fontsize=12)
ax = gca;
ax.FontSize = 12;
% title('Output of different units')

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


% DA_load = [61.05,55.39,53.15,53.10,52.98,55.53,66.27,83.15,78.98,67.34,67.83,64.36,61.35,59.11,59.04,63.01,76.97,104.91,119.59,117.77,110.19,102.31,87.24,72.45];
% DA_load = ((DA_load*90)/max(DA_load)); 
% PV_irradiation = [0 0 0 0 0 1 115 320 528 702 838 922 949 922 838 702 528 320 115 1 0 0 0 0];
% DA_wind = [24.87,14.22,16.13,14.34,10.22,1.94,0,0,0,0,0,0,0,0,0,1.6,10.55,10.10,9.61,13.09,14.75,9.33,3.80,4.19];
% PV = [0,0,0,0,0,0,2.00,6.95,16.87,26.52,33.86,38.62,40.83,40.46,37.98,32.98,25.60,5.16,1.83,0,0,0,0,0];
% DA_E = PV + DA_wind;
% DA_E = ((DA_E*90)/max(DA_E)); 
% lambda=xlsread('price.xlsx','B2:B8761'); %load price information
% DA_price = lambda(1:24)/1000; 
% NET_LOAD = DA_load - DA_E;
% 
% figure
% subplot(4,1,1)
% stairs(1:24,DA_load)
% set(gca, 'xlim', [1,24], 'xtick', 1:24)
% ylabel('Load(kW)',fontsize=10)
% % ylim([20,100])
% subplot(4,1,2)
% stairs(1:24,DA_E)
% set(gca, 'xlim', [1,24], 'xtick', 1:24)
% ylabel('RG Output(kW)',fontsize=10)
% % ylim([0,1])
% subplot(4,1,3)
% stairs(1:24,DA_price)
% set(gca, 'xlim', [1,24], 'xtick', 1:24)
% ylabel('Energy Price($/kWh)',fontsize=10)
% % ylim([0,1])
% subplot(4,1,4)
% stairs(1:24,NET_LOAD)
% set(gca, 'xlim', [1,24], 'xtick', 1:24)
% ylabel('Net Load(kW)',fontsize=10)




