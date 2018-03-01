function t4 = t4model_term(u_full,t0hat,t0tilde,t1hat,t1tilde,Ahat,Atilde,Bhat,Btilde,Ehat,Etilde,Fhat,Ftilde,a,b,k,a_tilde)
%
% Computes the RHS for every mode in the t^4-model term for 3D Euler
%
%
%%%%%%%%%
%INPUTS:%
%%%%%%%%%
%
%   u_full  =  full array of current Fourier state (2Mx2Mx2Mx3)
%
%    t0hat  =  full array of current Fourier state of C_hat(u,u)
%
%  t0tilde  =  full array of current Fourier state of C_tilde(u,u)
%
%    t1hat  =  full array of current Fourier state of hat{t1-term}
%
%        a  =  indices of positive resolved modes 1:M
%
%        b  =  indices of negative resolved modes -M:-1
%
%        k  =  array of wavenumbers (2Mx2Mx2Mx3)
%
%  a_tilde  =  indices of unresolved modes
%
%
%%%%%%%%%%
%OUTPUTS:%
%%%%%%%%%%
%
%       t4  =  t^4-model term of derivative of each resolved mode
%
%    t4hat  =  resolved part of the t^4-model term of derivative of each resolved mode
%
%  t4tilde  =  unresolved part of the t^4-model term of derivative of each resolved mode

[~,term1aa_hat,~] = Dk(u_full,Ahat - 3*t1hat - 5*Atilde + 3*t1tilde,a,b,k,a_tilde);
[~,~,term1ab_tilde] = Dk(u_full,-3*Ahat + 5*t1hat + 3*Atilde - t1tilde,a,b,k,a_tilde);


[~,~,term1a_tilde] = Dk(u_full,2*Fhat - 2*Ehat + 6*Bhat + 2*Etilde ...
                                           - 6*Ftilde - 2*Btilde + term1aa_hat ...
                                           + term1ab_tilde,a,b,k,a_tilde);
                                       
[~,~,term1b_tilde] = Dk(t0hat,3*Ahat - 5*t1hat - 3*Atilde + t1tilde,a,b,k,a_tilde);
[~,~,term1c_tilde] = Dk(t0tilde,-Ahat + 3*t1hat + 5*Atilde - 3*t1tilde,a,b,k,a_tilde);

[term1,~,~] = Dk(u_full,term1a_tilde + term1b_tilde + term1c_tilde,a,b,k,a_tilde);

[~,~,term2a_tilde] = Dk(u_full,Ahat-2*t1hat-2*Atilde+t1tilde,a,b,k,a_tilde);
[term2,~,~] = Dk(t0tilde,-Etilde + 2*Ftilde + 2*Btilde + term2a_tilde,a,b,k,a_tilde);

[term3,~,~] = Dk(Atilde,Atilde-2*t1tilde,a,b,k,a_tilde);

[term4,~,~] = Dk(t1tilde,t1tilde,a,b,k,a_tilde);


t4 = 1/24*term1 + 1/6*term2 + 1/8*term3 + 1/8*term4;

