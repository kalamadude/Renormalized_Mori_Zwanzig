function du_dt = tmodel_RHS(params)
%
% Computes the t-model for every mode in 3D Euler
%
%
%%%%%%%%%
%INPUTS:%
%%%%%%%%%
%
%   u_full  =  full array of current Fourier state (2Mx2Mx2Mx3)
%
%        a  =  indices of positive resolved modes 1:M
%
%        b  =  indices of negative resolved modes -M:-1
%
%        k  =  array of wavenumbers (2Mx2Mx2Mx3)
%
%  a_tilde  =  indices of positive unresolved modes
%
%        N  =  maximal mode of reduced model
%
%     time  =  current time in simulation
%
%    coeff  =  constant coefficient assigned to t-model
%
%
%%%%%%%%%%
%OUTPUTS:%
%%%%%%%%%%
%
%  du_dt  =  derivative of each mode

u_full = params.u_full;
a = params.a;
b = params.b;
k = params.k;
a_tilde = params.a_tilde;
N = params.N;
time = params.time;
coeff = params.coeff;

% compute the full model term
[t0,~,t0tilde] = markov_term(u_full,a,b,k,a_tilde);

% compute the t-model term
t1 = tmodel_term(u_full,t0tilde,a,b,k,a_tilde);

% compute the derivative
t0 = u_squishify(t0,N);
t1 = u_squishify(t1,N);

du_dt = t0 + t1 * time * coeff;