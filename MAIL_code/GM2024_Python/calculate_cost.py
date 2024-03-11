%%%%%%%%% This code is written by Yanbin Lin in 2023.%%%%%%%%%
% If this code is used for any research purpose, please cite our PESGM’24 paper below.
% Yanbin Lin, Zhen Ni, and Yufei Tang, “An Imitation Learning Method with Multi virtual Agents for Microgrid Energy Optimization under Interrupted Periods,” in Proc. of IEEE Power & Energy Society General Meeting (PESGM’24), pp.1-5, Washington, DC, USA, Jul. 21-25, 2024. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

import numpy as np
import pandas as pd
from numpy import genfromtxt

data = pd.read_excel(r'price.xlsx', engine='openpyxl')
price = data[['Energy price']][0:24]/1000
#my_data = genfromtxt('policy10-15_dp1001_original.csv', delimiter=',')
my_data = genfromtxt('policy10-15_max3_dp11.csv', delimiter=',')
DA_load = [61.05,55.39,53.15,53.10,52.98,55.53,66.27,83.15,78.98,67.34,67.83,64.36,61.35,59.11,59.04,63.01,76.97,104.91,119.59,117.77,110.19,102.31,87.24,72.45]
max_DA_load = max(DA_load)
for i in range(24):
    DA_load[i] = (DA_load[i]*90)/max_DA_load
DA_load = np.array(DA_load)
DA_wind = np.array([24.87,14.22,16.13,14.34,10.22,1.94,0,0,0,0,0,0,0,0,0,1.6,10.55,10.10,9.61,13.09,14.75,9.33,3.80,4.19])
PV = np.array([0,0,0,0,0,0,2.00,6.95,16.87,26.52,33.86,38.62,40.83,40.46,37.98,32.98,25.60,5.16,1.83,0,0,0,0,0])
DA_E = PV + DA_wind
max_DA_E = max(list(DA_E))
for i in range(24):
    DA_E[i] = (DA_E[i]*90)/max_DA_E
Interruption_time = [9,10,11,12,13,14]

# calculate real battery energy for 24 times
Soc_diff = []
initial_soc = 0.5
for soc in my_data:
    Soc_diff.append(soc-initial_soc)
    initial_soc = soc

Real_batt = []
Batt_Charge = []
Batt_Discharge = []
for soc_d in Soc_diff:
    if soc_d > 0:
        Real_batt.append(soc_d*150/0.9/0.9)
        Batt_Charge.append(soc_d*150/0.9/0.9)
        Batt_Discharge.append(0)
    else:
        Real_batt.append(soc_d * 150)
        Batt_Discharge.append(-soc_d * 150)
        Batt_Charge.append(0)

NET_load = DA_load - DA_E
Batt_Charge = abs(np.array(Batt_Charge))
Batt_Discharge = abs(np.array(Batt_Discharge))
Remain_load = DA_load - DA_E - Batt_Discharge + Batt_Charge
From_Grid = []
To_Grid = []
for i in range(24):
    if Remain_load[i]>0:
        From_Grid.append(Remain_load[i])
        To_Grid.append(0)
    else:
        From_Grid.append(0)
        To_Grid.append(-Remain_load[i])

for interruption in Interruption_time:
    From_Grid[interruption] = 0
    To_Grid[interruption] = 0

Grid_Cost = []
for t in range(24):
    Grid_Cost.append(Remain_load[t] * (price['Energy price'].iloc[t]))

Dg_Cost = []
min_dg = 30
for t in range(24):
    if Remain_load[t]<30:
        Dg_Cost.append(0.0009*30*30+0.0213*30+1.1)
    else:
        Dg_Cost.append(0.0009 * Remain_load[t] *Remain_load[t] + 0.0213 * Remain_load[t] + 1.1)

Cost = []
Dg_output = []
for t in range(24):
    if Dg_Cost[t]<Grid_Cost[t]:
        Cost.append(Dg_Cost[t])
        Dg_output.append(Remain_load[t])
        From_Grid[t] = 0
        To_Grid[t] = 0
    else:
        Cost.append(Grid_Cost[t])
        Dg_output.append(0)
Dg_output = np.array(Dg_output)
Dg_Cost = np.array(Dg_Cost)
Cost = np.array(Cost)
From_Grid = np.array(From_Grid)
To_Grid = np.array(To_Grid)
Grid_Cost = np.array(Grid_Cost)
Total_cost = np.sum(Cost)
print("Total Cost is:",Total_cost)

Output_result = []
Output_result.append(my_data)
Output_result.append(From_Grid)
Output_result.append(To_Grid)
Output_result.append(Batt_Discharge)
Output_result.append(Batt_Charge)
Output_result.append(Dg_output)
Output_result.append(Cost)
Output_result = np.array(Output_result)
np.savetxt('result_of_interruption10-15_max3_dp11.csv', Output_result, delimiter=',')





