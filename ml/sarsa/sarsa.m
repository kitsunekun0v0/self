function [weight, learning_curve] = sarsa(n_episode,lr,eps,gamma)
% n_episode: number of episode.
% lr: learning rate.
% gamma: reward decay.
% eps: epsilon greedy.

%% define the environment
N = 7; M = 10; % # of row and column of the gridworld
n_state = N*M; % totle # f states
state_matrix = eye(n_state); % represent each state by a vector

n_action = 4; % # of action
v_change = [-1 0 1 0]; %vertical movement
h_change = [0 1 0 -1]; %horizontal movement

T = [4 8]; %terminal
end_state = sub2ind([N,M],T(1),T(2));

R = 10; %reward at the terminal state
max_step = 150; %maximum steps for each episode
weight = rand(n_action,n_state); %initialise the weight
learning_curve = zeros(1,n_episode);

%% SARSA
for episode = 1:n_episode
    S = [randi(N) randi(M)]; %randomly set a start state
    start_state = sub2ind([N,M],S(1),S(2));
    
    current_state = S; %set current state
    index = start_state;
    step = 0;
    
    %for each step in an episode
    while (index~=end_state) && (step<=max_step)
        step = step + 1;
        input = state_matrix(:,index); %convert state into an input vector
        
        %compute Q value. Q value = exp(weight*input)/sum(exp(weight*input))
        q_target = exp(weight*input)/sum(exp(weight*input));
        %choose an action with epsilon greedy policy
        if rand>eps
            action = find(q_target==max(q_target));
        else
            action = randi(n_action);
        end
        
        %observe new state
        new_state(1) = current_state(1) + v_change(action);
        new_state(2) = current_state(2) + h_change(action);
        
        %not move out of the gridworld
        new_state(1) = (new_state(1)<1) + new_state(1)*((new_state(1)>0)&&(new_state(1)<=N)) + N*(new_state(1)>N);
        new_state(2) = (new_state(2)<1) + new_state(2)*((new_state(2)>0)&&(new_state(2)<=M)) + M*(new_state(2)>M);
        
        new_index = sub2ind([N,M],new_state(1),new_state(2));
        
        %update Q value
        if step>1
            dw = (r - q_predict + gamma*q_target(action))*(action_vec_pre-pre_Q)*input_pre';
            weight = weight + lr*dw;
        end
        
        action_vector = zeros(n_action,1);
        action_vector(action,1) = 1;
        
        %store variables for next step
        pre_Q = q_target; %p_Q = Q
        input_pre = input;
        action_vec_pre = action_vector; %output_old = output
        q_predict = q_target(action); %Q_old = Q(action)
        index = new_index;
        current_state(1) = new_state(1);
        current_state(2) = new_state(2);
        r = 0;
        
        %check if state is terminal
        if index==end_state
            dw = (R-q_predict)*q_predict*(action_vec_pre-pre_Q)*input_pre';
            weight = weight + lr*dw;
        end
        
    end
    
    learning_curve(1, episode) = step;
end

end