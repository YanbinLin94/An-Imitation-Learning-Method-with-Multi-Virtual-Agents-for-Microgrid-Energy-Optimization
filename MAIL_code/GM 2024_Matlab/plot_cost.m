clear all;clc;
%plot the results of multiple imitation learning
data=csvread('comparative_cost_soc51.csv');
proposed_method = data(1,:);
dp = data(2,:);
Aggregated_Q = data(3,:);
%cooperative_method = data(4,:);

t=1:1:24;
figure()
% plot(t,proposed_method,t,dp,t,Aggregated_Q,t,cooperative_method,'LineWidth', 2.5)
plot(t,proposed_method,t,dp,t,Aggregated_Q,'LineWidth', 2.5)
ylim([-4 6])
set(gca, 'xlim', [1,24], 'xtick', 1:24)
xlabel('Time(hour)',fontsize=12)
ylabel('Cost($)',fontsize=12)
% legend('Proposed Method','DP','Aggregated Q','Cooperative Q-learning',fontsize=12)
legend('MAIL','DP','Aggregated Q',fontsize=12)
ax = gca;
ax.FontSize = 12;
title('Cost of different units')


t=1:1:24;
figure()
plot(t,proposed_method,t,dp,'LineWidth', 2.5)
ylim([-4 6])
set(gca, 'xlim', [1,24], 'xtick', 1:24)
xlabel('Time(hour)',fontsize=12)
ylabel('Cost($)',fontsize=12)
legend('MAIL','DP',fontsize=12)
ax = gca;
ax.FontSize = 12;
title('Cost of MAIL and DP methods')

 
