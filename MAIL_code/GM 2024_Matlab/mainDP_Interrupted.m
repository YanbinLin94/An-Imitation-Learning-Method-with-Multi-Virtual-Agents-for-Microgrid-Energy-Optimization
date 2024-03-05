clear,clc

init
tic
N=50; %SOC discrete size; if SOC size=51, then N is 50
delta=(s_u-s_l)/N;
states=s_l:delta:s_u;
SS{K}=0;

stateNum=1;
stateK0=L0;
costK0=0; %stateNum by 1;
fault_time = [10 11 12 13]; % Interrupted time slots. You can change it to [11 12 13 14] or [12 13 14 15]. 
% create interruption_status
Interruption_status = zeros(24,1);
time_slots = length(fault_time);
Time = 1:1:24;

for index=1:24
    if any(fault_time(:) == index)
        Interruption_status(index) = 1;
    end
end

for k=1:K
    powercost=zeros(stateNum,N+1);
    for n=1:stateNum
        powerbatt=(states-stateK0(n))*Es; %energy change rate in batt
        index_ch=find(powerbatt>0); % charging power index
        index_dis=find(powerbatt<0); % discharing power index
        power=powerbatt;
        power(index_ch)=power(index_ch)/eta_ch; % charging power at AC
        power(index_dis)=power(index_dis)*eta_dis; %discharing power at AC
        index_inf=find(power>pmax_ch | power<-pmax_dis ); % infeasible solution
        %temp=power*lambda(k); %charging/discharging cost
        [temp] = F_costval_DP_FLT(power,k,DA_load,DA_E,DA_price,fault_time);
        temp(index_inf)=inf; %penalty infeasible solution with inf cost
        powercost(n,:)=temp;
    end
    costtemp=costK0*ones(1,N+1)+powercost;
    toc2=toc;

    
    [costK0,indexK0]=min(costtemp,[],1);
    index_fea=find(costK0<inf);
    stateNum=length(index_fea); %update stateNum at current stage
    costK0=costK0(index_fea);
    costK0=costK0';
    stateK0=states(index_fea);
    if k==1
        temp0{1}=L0;
    else
        temp0=SS{k-1};
    end
    for m=1:stateNum
        temp=temp0{indexK0(m)};
        temp=[temp stateK0(m)];
        SStemp{m}=temp;
    end
    SS{k}=SStemp;
    SStemp=[];
    toc3=toc;
end
toc
%%
socDP=SS{1,K}{1,(round((LK-s_l)/delta))+1};
pkDP=zeros(1,K);
for i=1:K
    pbatt=(socDP(i+1)-socDP(i))*Es;
    if pbatt>0
        pkDP(i)=pbatt/eta_ch;
    elseif pbatt<0
        pkDP(i)=pbatt*eta_dis;
    end
    time = i;
    real_batt = pkDP(i);
    [c_SR,val_out] = F_costval_RL_FLT(real_batt,time,DA_load,DA_E,DA_price,fault_time);
    save_dp_cost(i) = c_SR;
    save_outs(i,:) = val_out;
end
pkDP=-pkDP;
socDP(1)=[];
Total_cost = sum(save_dp_cost)

% save a table with soc policy, other units outputs and conditions
Table = [DA_E', DA_load', DA_price, DA_wind', PV', PV_irradiation', Interruption_status, Time', socDP', save_outs];
writematrix(Table,'interrupt10-13_dp51.xls');% remember to change the file name according to the interrupted times and the discrete size.

%%
figure
subplot(3,1,1)
stairs(0:24,[lambda(1:24);lambda(24)])
set(gca, 'xlim', [0,24], 'xtick', 0:24)
ylim([20,100])
xlabel('Time(hour)')
ylabel('$/kWh')
title('Grid Power Price')

subplot(3,1,2)
stairs(0:24,[pkDP pkDP(24)])
set(gca, 'xlim', [0,24], 'xtick', 0:24)
xlabel('Time(hour)')
ylabel('kW')
title('Power Output')

subplot(3,1,3)
plot(0:24,[L0 socDP])
set(gca, 'xlim', [0,24], 'xtick', 0:24)
ylim([0,1])
xlabel('Time(hour)')
ylabel('SOC')
title('Battery SOC')


