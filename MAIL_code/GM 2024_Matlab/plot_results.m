clear all;clc;
%plot the results of multiple imitation learning
data=csvread('result_of_interruption10-15_max3_dp51.csv');
batt_soc = data(1,:);
from_grid = data(2,:);
to_grid = data(3,:);
batt_discharge = data(4,:);
batt_charge = data(5,:);
dg_out = data(6,:);
cost = data(7,:);
batt_out = batt_discharge - batt_charge;

t=1:1:24;
figure()
plot(t,from_grid,t,to_grid,t,batt_out,t,dg_out,'LineWidth', 2.5)
ylim([-30 66])
set(gca, 'xlim', [1,24], 'xtick', 1:24)
xlabel('Time(hour)',fontsize=12)
ylabel('Power(kW)',fontsize=12)
legend('From Grid','To Grid','BESS Output','DG Output',fontsize=12)
ax = gca;
ax.FontSize = 12;
title('Power outputs of the proposed MAIL method')



