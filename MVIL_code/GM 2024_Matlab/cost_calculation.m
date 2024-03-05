function [y] = cost_calculation(power,combine_states,k,Fault_hour)

init; 
dg_cap = 100;
DA_price(Fault_hour) = 100;
for i_c = 1:2*(N+1)
   if DA_load(k) > DA_E(k)
      
      if power(i_c) <= 0 
          
          batt_discharge = min(-power(i_c),max(0,DA_load(k)-DA_E(k))); 
          remaining_demd = DA_load(k) - DA_E(k) - batt_discharge; 
          final_cost(i_c) = 0;
          if remaining_demd > 0
            cost_comparison1 = (combine_states(i_c,2)*dg_a*(max(15,min(remaining_demd,dg_cap)))^2) + (dg_b*(max(15,min(remaining_demd,dg_cap))*combine_states(i_c,2))) + dg_c*combine_states(i_c,2);
            cc1_rem_demd = max(0,remaining_demd - (max(15,min(remaining_demd,dg_cap))*combine_states(i_c,2)));
%             if k == Fault_hour 
%                if cc1_rem_demd > 0 
%                     cost_comparison1 = inf;
%                else
%                     cost_comparison1 = cost_comparison1;
%                end
%             else
            cost_comparison1 = cost_comparison1 + (cc1_rem_demd*DA_price(k));
            %end
%             if cc1_rem_demd > 0.9*DA_load(k)
%                 cost_comparison1 = inf;
%             end
            final_cost(i_c) = cost_comparison1;
%             min_req_cal = min(remaining_demd,0.9*DA_load(k)); 
%             cost_comparison2 = (min_req_cal*DA_price(k));
%             if remaining_demd > min_req_cal && combine_states(i_c,2) > 0
%                 cost_comparison2 = cost_comparison2 + (dg_a*(max(15,min(remaining_demd - min_req_cal,50)))^2) + (dg_b*(max(15,min(remaining_demd - min_req_cal,50)))) + dg_c;
%             else
%                 cost_comparison2 = inf; 
%             end
%             cost_com = [cost_comparison1 cost_comparison2];
%             final_cost(i_c) = min(cost_com);
          end
          
      else
          remaining_demd = DA_load(k) - DA_E(k) + power(i_c);
          final_cost(i_c) = 0;
          if remaining_demd > 0
            cost_comparison1 = (combine_states(i_c,2)*dg_a*(max(15,min(remaining_demd,dg_cap)))^2) + (dg_b*(max(15,min(remaining_demd,dg_cap))*combine_states(i_c,2))) + dg_c*combine_states(i_c,2);
            cc1_rem_demd = max(0,remaining_demd - (max(15,min(remaining_demd,dg_cap))*combine_states(i_c,2)));
%             if cc1_rem_demd > 0.9*DA_load(k)
%                cc1_rem_demd = inf;
%             end
%             if k == Fault_hour
%                if cc1_rem_demd > 0 
%                     cost_comparison1 = inf;
%                else
%                     cost_comparison1 = cost_comparison1;
%                end
%             else
            cost_comparison1 = cost_comparison1 + (cc1_rem_demd*DA_price(k));
            %end
            final_cost(i_c) = cost_comparison1;
%             min_req_cal = min(remaining_demd,0.9*DA_load(k)); 
%             cost_comparison2 = (min_req_cal*DA_price(k));
%             if remaining_demd > min_req_cal && combine_states(i_c,2) > 0
%                 cost_comparison2 = cost_comparison2 + (dg_a*(max(15,min(remaining_demd - min_req_cal,50)))^2) + (dg_b*(max(15,min(remaining_demd - min_req_cal,50)))) + dg_c;
%             else
%                 cost_comparison2 = inf; 
%             end
%             cost_com = [cost_comparison1 cost_comparison2];
%             final_cost(i_c) = min(cost_com);
          end
           
      end
   else
      if power(i_c) <= 0 
         cost_comparison1 = (combine_states(i_c,2)*dg_a*(15)^2) + (dg_b*(15)*combine_states(i_c,2)) + dg_c*combine_states(i_c,2); 
         extra_enrg = DA_load(k) - DA_E(k) + power(i_c);
         if k == Fault_hour 
         final_cost(i_c) = cost_comparison1-(extra_enrg*DA_price(k)); 
         else
         final_cost(i_c) = cost_comparison1 + (DA_price(k)*(extra_enrg)); 
         end
      else
         enrgy_req = DA_load(k) + power(i_c) - DA_E(k); 
         final_cost(i_c) = 0;
         if enrgy_req > 0 
            cost_comparison1 = (combine_states(i_c,2)*dg_a*(max(15,min(enrgy_req,dg_cap)))^2) + (dg_b*(max(15,min(enrgy_req,dg_cap))*combine_states(i_c,2))) + dg_c*combine_states(i_c,2);
            cc1_rem_demd = max(0,enrgy_req - (max(15,min(enrgy_req,dg_cap))*combine_states(i_c,2)));
%             if k == Fault_hour
%                if cc1_rem_demd > 0 
%                     cost_comparison1 = inf;
%                else
%                     cost_comparison1 = cost_comparison1;
%                end
%             else
            cost_comparison1 = cost_comparison1 + (cc1_rem_demd*DA_price(k));
            %end
%             if cc1_rem_demd > 0.9*DA_load(k)
%                 cost_comparison1 = inf;
%             end 
            final_cost(i_c) = cost_comparison1; 
         else
            cost_comparison1 = (combine_states(i_c,2)*dg_a*(15)^2) + (dg_b*(15)*combine_states(i_c,2)) + dg_c*combine_states(i_c,2);  
            if k == Fault_hour 
            final_cost(i_c) = cost_comparison1 - (enrgy_req*DA_price(k));  
            else
            final_cost(i_c) = cost_comparison1 + (enrgy_req*DA_price(k));  
            end
         end
         
      end 
        
   end
     
end


y = final_cost;

end