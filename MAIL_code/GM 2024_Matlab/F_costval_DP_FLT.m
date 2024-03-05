function [temp] = F_costval_DP_FLT(power,k,DA_load,DA_E,DA_price,fault_time)
dg_a = 0.0009;
dg_b = 0.0213;
dg_c = 1.1;
min_dg = 0.3*100;
j = k;
pow_siz = size(power,2);

sig = 0;
time = k;
%if time == fault_time(1) || time == fault_time(2) || time == fault_time(3) || time == fault_time(4) || time == fault_time(5) || time == fault_time(6)
% if interrupted hours are larger than 4, please change this line; 
% for example, interrupted time is 10-15

if time == fault_time(1) || time == fault_time(2) || time == fault_time(3) || time == fault_time(4)
    sig = 1;
end

for each_pow = 1:pow_siz
	real_batt = power(each_pow);
	fi_cost = [];
if DA_load(j) > DA_E(j)
      
      if real_batt <= 0 
          batt_discharge = -real_batt; 
          batt_dch = min(batt_discharge,DA_load(j)-DA_E(j)); 
          remaining_demd = DA_load(j) - DA_E(j) - batt_dch; 
          batt_charge = 0; 
          from_grid = max(0,remaining_demd);
          to_grid = 0;
          
          if sig == 1
             dg_cost = (dg_a*(max(from_grid,min_dg))^2)+(dg_b*max(from_grid,min_dg))+dg_c;
             dg_output = max(from_grid,min_dg);
             from_grid = 0;
             fi_cost = dg_cost;
          else
                   
          grid_cost = from_grid*DA_price(j);
          dg_cost = (dg_a*(max(from_grid,min_dg))^2)+(dg_b*max(from_grid,min_dg))+dg_c;
          cost_com = [grid_cost dg_cost];
          [c_opt,pos_opt]=min(cost_com);
          if pos_opt == 1
             dg_output = 0;
          else
             dg_output = max(from_grid,min_dg);
             from_grid = 0;
          end
              
          fi_cost = c_opt;
          end
          
          output = [from_grid to_grid batt_discharge batt_charge dg_output]; 
          
      else
          remaining_demd = DA_load(j) - DA_E(j) + real_batt;
          batt_discharge = 0;
          batt_charge = real_batt;
          from_grid = max(0,remaining_demd);
          to_grid = 0;
          
          if sig == 1
             dg_cost = (dg_a*(max(from_grid,min_dg))^2)+(dg_b*max(from_grid,min_dg))+dg_c;
             dg_output = max(from_grid,min_dg);
             from_grid = 0;
             fi_cost = dg_cost;
          else
          
          
          grid_cost = from_grid*DA_price(j);
          dg_cost = (dg_a*(max(from_grid,min_dg))^2)+(dg_b*max(from_grid,min_dg))+dg_c;
          cost_com = [grid_cost dg_cost];
          [c_opt,pos_opt]=min(cost_com);
          if pos_opt == 1
             dg_output = 0;
          else
             dg_output = max(from_grid,min_dg);
             from_grid = 0;
          end
 
          fi_cost = c_opt;
          end
          output = [from_grid to_grid batt_discharge batt_charge dg_output]; 
      end
          
else        
      if real_batt <= 0 
         batt_discharge = -real_batt;
         extra_enrg = DA_E(j) - DA_load(j);
         batt_charge = 0; 
         from_grid = 0;
         to_grid = extra_enrg + batt_discharge;
         fi_cost = -to_grid*DA_price(j);
         dg_output = 0;
         
         
         if sig == 1
             to_grid = 0;
             fi_cost = 0;
         end
         output = [from_grid to_grid batt_discharge batt_charge dg_output]; 
      else
         enrgy_req = DA_load(j) + real_batt - DA_E(j); 
         batt_discharge = 0;
         batt_charge = real_batt; 
         from_grid = max(0,enrgy_req);
         to_grid = min(0,enrgy_req);
         dg_output = 0;
         posi_or_negi = (from_grid+to_grid);
         fi_cost = (from_grid+to_grid)*DA_price(j);
                 
         if sig == 1          
            if from_grid > 0 
                
               dg_output = max(from_grid,min_dg);
               dg_cost = (dg_a*(max(from_grid,min_dg))^2)+(dg_b*max(from_grid,min_dg))+dg_c;
               fi_cost = dg_cost;
            end
            from_grid = 0;
            to_grid = 0;
             
         else      
         
         if posi_or_negi>0
            
          grid_cost = posi_or_negi*DA_price(j);
          dg_cost = (dg_a*(max(from_grid,min_dg))^2)+(dg_b*max(from_grid,min_dg))+dg_c;
          cost_com = [grid_cost dg_cost];
          [c_opt,pos_opt]=min(cost_com);
          if pos_opt == 1
             dg_output = 0;
          else
             dg_output = max(from_grid,min_dg);
             from_grid = 0;
             fi_cost = c_opt;
          end 
                
         end
         end
         output = [from_grid to_grid batt_discharge batt_charge dg_output]; 
         end
    
end
sav_cost_pow(each_pow) = fi_cost;
end
temp = sav_cost_pow; 
end