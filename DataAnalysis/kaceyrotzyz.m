%% Script for testing out ROT functions

% Created ROTZYZ function-- used Symbolic Variables to test out created
% function 

% November 16,2021- for use of checking the "rotzyz" function created. 
% using function "Syms". Able to solve a system of equations by defining
% variables. 

%% Testing

syms x
eqn = sin(x) == cos(x);
solve(eqn,x)

%% 

% give values of gamma, beta, gamma prime
syms gamma beta gamma_prime beta_prime
R = rotz(gamma)*roty(beta)*rotz(gamma_prime);
ans = solve(R,gamma,beta,gamma_prime);
R = rotz(gamma);
solve

R2 =  roty(beta)*rotz(gamma)*roty(beta_prime);


testR = subs(R,{gamma,beta,gamma_prime},{0,pi/2,0})

[g,b,ga]= rotzyz(testR)