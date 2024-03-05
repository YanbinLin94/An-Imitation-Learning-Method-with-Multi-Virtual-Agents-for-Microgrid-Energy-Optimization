clc
clear all

init

N=50; %soc discrete
delta=(s_u-s_l)/N;
states=s_l:delta:s_u;
combine_st = [];

for st_add = 1:size(states,2)
    combine_st=[combine_st;states(st_add)*ones(size(states,2),1) states'];    
end

Each_cell = zeros(1,size(combine_st,1));

for tab_time = 1:K
    for tab_stat = 1:size(combine_st,1)
        value_table{tab_stat,tab_time} = Each_cell;     
    end
end
%cost_table = zeros(K,size(states,2));
states_power = states*Es;
initial_pos = 6;
gamma = 1;
z_value = -100:4:100;
a = 1;
Run = 50;
iter = 4000;
epsilon = 0.5;

N_repeat = 1;
help_ep = 100;

%for repeat = 1:N_repeat
    %value_table = zeros(size(states,2),K);
lambda = -lambda;
event_prob = 0;
fault_time = [10 11 12 13 14 15];
% lambda_fault = lambda1;
% lambda_fault(fault_time) = 1000;
% lambda = lambda_fault;

for rr = 1:Run 
    for tab_time = 1:K
        for tab_stat = 1:size(combine_st,1)
            value_table{tab_stat,tab_time} = Each_cell;     
        end
    end
    epsilon = 0.5;
    help_ep = 50;
    tic
for i = 1:iter 
    
    
    initial_pow = L0*Es;
    stateK0 = [L0 L0];
    %alpha = a/(a+i-1);
    alpha = 0.05;
    if i == help_ep
       epsilon =  epsilon/1.1;
       help_ep = help_ep+50;
    end
    save_transition = initial_pos;
    for time = 1:K
        help_combination = [];
        power = [];
        status = ones(1,size(combine_st,1));
        powerbatt=(combine_st-stateK0)*Es; %energy change rate in batt
        power=powerbatt;
        for indx = 1:size(combine_st,2)
        index_ch=find(powerbatt(:,indx)>0); % charging power index
        index_dis=find(powerbatt(:,indx)<0); % discharing power index
        power(index_ch,indx)=power(index_ch,indx)/eta_ch; % charging power at AC
        power(index_dis,indx)=power(index_dis,indx)*eta_dis; %discharing power at AC
        index_inf=find(power(:,indx)>pmax_ch | power(:,indx)<-pmax_dis ); % infeasible solution
        status(index_inf) = 0;
        end
        help_assign = find(status>0);
        %value_determin = value_table(:,time); 
        
        if rand < epsilon 
   
%         if time == fault_time(1) || time == fault_time(2) || time == fault_time(3) || time == fault_time(4)
%             assign_flt = find(power(help_assign,2)==0);
%             help_assign = help_assign(assign_flt);
%             taking_action = help_assign(randi([1,size(help_assign,2)],1,1));
%             h_pos = find(help_assign == taking_action);
%             %cost_cal = [];
%             for tw_st = 1:2
%                 real_batt = power(help_assign(h_pos),tw_st);
%                 [cost_cal,val_out] = F_costval_RL(real_batt,time,DA_load,DA_E,DA_price);
%                 cost_agts(tw_st) = cost_cal;
%             end
%             %cost_cal = (event_prob*(power(help_assign(h_pos),1)*lambda(time)))+((1-event_prob)*(power(help_assign(h_pos),2)*lambda(time))); 
%             optimized_cost = sum(cost_agts.*[event_prob (1-event_prob)]);
%         else
            taking_action = help_assign(randi([1,size(help_assign,2)],1,1));
            h_pos = find(help_assign == taking_action);
%             cost_cal = (0.5*(power(help_assign(h_pos),1)*lambda(time)))+(0.5*(power(help_assign(h_pos),2)*lambda(time))); 
%             optimized_cost = cost_cal;
            for tw_st = 1:2
                if tw_st == 1
                real_batt = power(help_assign(h_pos),tw_st);
                [cost_cal,val_out] = F_costval_RL(real_batt,time,DA_load,DA_E,DA_price);
                cost_agts(tw_st) = cost_cal;
                else
                real_batt = power(help_assign(h_pos),tw_st);
                [cost_cal,val_out] = F_costval_RL_FLT(real_batt,time,DA_load,DA_E,DA_price);
                cost_agts(tw_st) = cost_cal;
                end
            end
            %cost_cal = (event_prob*(power(help_assign(h_pos),1)*lambda(time)))+((1-event_prob)*(power(help_assign(h_pos),2)*lambda(time))); 
            optimized_cost = sum(cost_agts.*[event_prob (1-event_prob)]);
        %end
        
        else
        if time < K
%         if time == fault_time(1) || time == fault_time(2) || time == fault_time(3) || time == fault_time(4)
%             assign_flt = find(power(help_assign,2)==0);
%             help_assign = help_assign(assign_flt);
%             cost_cal = value_table{save_transition,time}(1,help_assign);
%             [opt_cost,pos] = min(cost_cal);
%             taking_action = help_assign(pos);
%             for tw_st = 1:2
%                 real_batt = power(taking_action,tw_st);
%                 [cost_cal,val_out] = F_costval_RL(real_batt,time,DA_load,DA_E,DA_price);
%                 cost_agts(tw_st) = cost_cal;
%             end
%             optimized_cost = sum(cost_agts.*[event_prob (1-event_prob)]); 
%         else
            cost_cal = value_table{save_transition,time}(1,help_assign);
            [opt_cost,pos] = min(cost_cal);
            taking_action = help_assign(pos);
            %optimized_cost = (0.5*(power(taking_action,1)*lambda(time)))+(0.5*(power(taking_action,2)*lambda(time))); 
            for tw_st = 1:2
                if tw_st == 1
                real_batt = power(taking_action,tw_st);
                [cost_cal,val_out] = F_costval_RL(real_batt,time,DA_load,DA_E,DA_price);
                cost_agts(tw_st) = cost_cal;
                else
                real_batt = power(taking_action,tw_st);
                [cost_cal,val_out] = F_costval_RL_FLT(real_batt,time,DA_load,DA_E,DA_price);
                cost_agts(tw_st) = cost_cal;
                end
              
            end
            optimized_cost = sum(cost_agts.*[event_prob (1-event_prob)]); 
        %end
        
        else
        for all_poss = 1:size(help_assign,2)
            for tw_st = 1:2
                if tw_st == 1
                real_batt = power(help_assign(all_poss),tw_st);
                [cst_cal,val_out] = F_costval_RL(real_batt,time,DA_load,DA_E,DA_price);
                cost_agts(tw_st) = cst_cal;
                else
                real_batt = power(help_assign(all_poss),tw_st);
                [cst_cal,val_out] = F_costval_RL_FLT(real_batt,time,DA_load,DA_E,DA_price);
                cost_agts(tw_st) = cst_cal;
                end
                    
            end
            cost_cal(all_poss) = sum(cost_agts.*[event_prob (1-event_prob)]); 
            save_mic_pol(all_poss,:) = val_out;
        end
        %cost_cal = (0.5*(power(help_assign,1)*lambda(time)))+(0.5*(power(help_assign,2)*lambda(time))); 
        [optimized_cost,pos] = min(cost_cal);
        taking_action = help_assign(pos);  
        val_out = save_mic_pol(pos,:);
        end   

        end
        %if time < K
        %value_determin = value_table(:,time);
%         else 
%         value_determin = zeros(17,1);
%         end
        
%         cost_cal = power(help_assign)*lambda(time) + value_determin(help_assign)';
%         [optimized_cost,pos] = min(cost_cal);
        pos_soc = combine_st(taking_action,:);
        
        if time < K-1 
           %[max_q_val] = ns_q(pos_soc,states,time,value_table,eta_ch,eta_dis,pmax_dis,pmax_ch,Es,lambda); 
           max_q_val = min(value_table{taking_action,time+1});
        end
        
        
        
        
        if time < K-1
%            if time == 1 
%               save_transition = [6 taking_action]; 
%            end
           value_table{save_transition,time}(1,taking_action) = optimized_cost + max_q_val; 
        else if time == K-1
           value_table{save_transition,time}(1,taking_action) = optimized_cost;
            end
        end
        save_transition = taking_action;
        stateK0 = pos_soc;
        batt_pol(time,:) = pos_soc;
        save_cost_t(time) = optimized_cost;
        save_microgrid_pol(time,:) = val_out;
    end

save_cost_iter(i) = sum(save_cost_t);      
save_timQ(i) = toc;    
end
save_cost_run(rr,:) = save_cost_iter;  
save_time_run(rr,:) = save_timQ; 
end
plot_avg_cost = sum(save_cost_run)/Run;
Plot_avg_time = sum(save_time_run)/Run;
plot(plot_avg_cost)
toc
%%%%%%%%%%%%%%For Real-time Decision%%%%%%%%%%%%%%%%%%%%%%%%%%%


