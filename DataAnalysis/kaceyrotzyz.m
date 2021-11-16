%% Creating Function for ROTZYZ

% November 16,2021- for use of checking the "rotzyz" function created. 
% using function "Syms". Able to solve a system of equations by defining
% variables. 

%% Testing

syms x
eqn = sin(x) == cos(x);
solve(eqn,x)

%% 
syms gamma beta gamma_prime
%R = rotz(gamma)*roty(beta)*rotz(gamma_prime);
%ans = solve(R,gamma,beta,gamma_prime);
R = rotz(gamma);
solve