function [S, E, D, I, R, Death, Q, N] = prediction(N0, data_0, days, para)

ratio = 0.95;
   
    % set the parameter
    bias = para(1);
    beta1 = para(2);
    beta2 = para(3);
    delta_E = para(4);
    sigma = para(5);
    epsilon_E = para(6);
    epsilon_I = para(7);
    gamma_I = para(8);
    gamma_D = para(9);
    dd = para(10);

%first day data
E0 = data_0(1); 
D0 = data_0(2); 
I0 = data_0(3); 
R0 = data_0(4); 
Death0 = data_0(5);
S0 = (N0 - E0 - D0 - I0 - R0) * (1 - ratio);
Q0 = (N0 - E0 - D0 - I0 - R0) * ratio;


S = zeros(days,1);
E = zeros(days,1);  
D = zeros(days,1);  
I = zeros(days,1);
R = zeros(days,1);
N = zeros(days,1);
Q = zeros(days,1);
Death = zeros(days,1);

N(1) = N0; 
E(1) = E0;
D(1) = D0;
I(1) = I0;
R(1) = R0;
S(1) = S0;
Q(1) = Q0;
Death(1) = Death0;


for i = 1:days - 1
%     S(i+1) = S(i) - beta1 * S(i)*E(i)/(N(i) - Q(i))...
            - beta2 * S(i)*I(i)/(N(i) - Q(i)) + delta_E * E(i);

    E(i+1) = E(i) + beta1 * S(i)*E(i)/(N(i) - Q(i))...
             + beta2 * S(i)*I(i)/(N(i) - Q(i))...
            - sigma * E(i) - delta_E * E(i) - epsilon_E * E(i);

    I(i+1) = I(i) + sigma * E(i) - gamma_I * I(i) - epsilon_I * I(i);

    D(i+1) = D(i) + epsilon_E * E(i) + epsilon_I * I(i)...
            - dd * D(i) - gamma_D * D(i);

    R(i+1) = R(i) + gamma_I * I(i) + gamma_D * D(i);
    Death(i+1) = Death(i) + dd * D(i);
    N(i+1) = N0 - Death(i+1);
    temp = N(i+1) - E(i+1) - D(i+1) - I(i+1) - R(i+1);
    S(i+1) = temp * (1 - ratio);
    Q(i+1) = temp * (ratio);
end

