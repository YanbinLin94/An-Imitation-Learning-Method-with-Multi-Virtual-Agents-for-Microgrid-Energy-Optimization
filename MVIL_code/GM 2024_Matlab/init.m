eta_dis=0.9; batt_para(1)=eta_dis; %discharging
eta_ch=0.9; batt_para(2)=eta_ch; %charging
Es=150/eta_dis; batt_para(3)=Es;  % batt energy capacity
pmax_dis=30;   batt_para(4)=pmax_dis; %batt discharging power capacity
pmax_ch=30;   batt_para(5)=pmax_ch; %batt charging power capacity
s_l=0.1; s_u=0.9; %soc lower and upper bound

L0=0.5; %initial SOC
LK=0.1; %specified SOC at the end
K=24;
%N=2; %soc discrete
batt_cost = 0.05; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file = 'testing.xlsx';
% data = xlsread(file);

DA_load = [61.05,55.39,53.15,53.10,52.98,55.53,66.27,83.15,78.98,67.34,67.83,64.36,61.35,59.11,59.04,63.01,76.97,104.91,119.59,117.77,110.19,102.31,87.24,72.45];
DA_load = ((DA_load*90)/max(DA_load)); 
PV_irradiation = [0 0 0 0 0 1 115 320 528 702 838 922 949 922 838 702 528 320 115 1 0 0 0 0];
DA_wind = [24.87,14.22,16.13,14.34,10.22,1.94,0,0,0,0,0,0,0,0,0,1.6,10.55,10.10,9.61,13.09,14.75,9.33,3.80,4.19];
PV = [0,0,0,0,0,0,2.00,6.95,16.87,26.52,33.86,38.62,40.83,40.46,37.98,32.98,25.60,5.16,1.83,0,0,0,0,0];
DA_E = PV + DA_wind;
DA_E = ((DA_E*90)/max(DA_E)); 
%%%%%%%%%%%%%%%%%%%%DR Incentives %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%w_dr_incentive =0.02; 
%DA_price = (DA_load./DA_E)*w_dr_incentive; 

lambda=xlsread('price.xlsx','B2:B8761'); %load price information
DA_price = lambda(1:24)/1000; 

%%%% DG Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dg_a = 0.00104;
dg_b = 0.0304;
dg_c = 1.3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
