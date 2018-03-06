function coeff_array = renormalize(u,N_list,t_list,time)
%
% A function to take a fully resolved u to compute optimal renormalization
% coefficients for several ROMs
%
%%%%%%%%%
%INPUTS:%
%%%%%%%%%
%
%       u  =  an MxMxMx3x4xlength(t_list) array of fully resolved Fourier modes
%
%  N_list  =  a vector of resolutions (less than M) for which to compute
%             optimal renormalization coefficients
%
%  t_list  =  a vector of the times corresponding to the solution u
%
%    time  =  a logical variable (1 if algebraic time dependence of
%             renormalization coefficients is retained, 0 if they are not)
%
%
%%%%%%%%%%
%OUTPUTS:%
%%%%%%%%%%
%
%  coeff_array  =  a 4xlength(N_list) array of the optimal coefficients of
%                  each term in the ROM model for each resolution in N_list

% initialize the output
coeff_array = zeros(4,length(N_list));

% extract data about the size of the full array
s = size(u);
N_full = s(1);
M_full = 3*N_full;
t = s(6);

% initialize an array into which the exact derivative of the energy in each
% mode will be stored
exact_everything = zeros(s);

% make k array
k_vec_full = [0:M_full-1,-M_full:1:-1];
[kx_full,ky_full,kz_full] = ndgrid(k_vec_full,k_vec_full,k_vec_full);
k_full = zeros(2*M_full,2*M_full,2*M_full,3);
k_full(:,:,:,1) = kx_full;
k_full(:,:,:,2) = ky_full;
k_full(:,:,:,3) = kz_full;

% make vectors of resolved and unresolved modes in the full simulation
a_full = 2:M_full;
b_full = 2*M_full:-1:M_full+2;

% compute exact derivative of the energy in each mode at each timestep
for i = 1:t
    
    disp('Current analyzing exact solution')
    current_t = t_list(i);
    disp(sprintf('Current time is t = %i\n',t_list(i)))
    
    % extract the current u
    u_current = squeeze(u(:,:,:,:,:,i));
    
    % construct the full version of it
    u_full = u_fullify(u_current,M_full);
    
    % compute the time derivative and convert it into the same shape as u
    % itself
    du_dt = Ck(u_full,u_full,a_full,b_full,k_full,[]);
    du_dt = u_squishify(du_dt,N_full);
    
    % compute the energy derivative of each mode for this timestep
    exact_everything(:,:,:,:,:,i) = du_dt.*conj(u_current) + conj(du_dt).*u_current;
end

% compute contribution to the derivative of the energy in each mode for
% each ROM at each resolution
for j = 1:length(N_list);
    
    % compute N and M for the current ROM
    N = N_list(j);
    M = 2*N;
    
    % construct output arrays of the proper size
    exact = zeros(M,M,M,3,t);
    R0 = zeros(M,M,M,3,t);
    R1 = zeros(M,M,M,3,t);
    R2 = zeros(M,M,M,3,t);
    R3 = zeros(M,M,M,3,t);
    R4 = zeros(M,M,M,3,t);
    
    % compute the indices corresponding to terms in this ROM from the exact
    % data computed above
    res_exact = [1:N,2*M_full - N+1:2*M_full];
    
    % make k array for the ROM
    k_vec = [0:M-1,-M:1:-1];
    [kx,ky,kz] = ndgrid(k_vec,k_vec,k_vec);
    k = zeros(2*M,2*M,2*M,3);
    k(:,:,:,1) = kx;
    k(:,:,:,2) = ky;
    k(:,:,:,3) = kz;
    
    % compute indices of resolved and unresolved modes
    a = 2:M;
    b = 2*M:-1:M+2;
    a_tilde = N+1:M;
    
    % loop through every timestep
    for i = 1:t
        disp(sprintf('Current resolution is N = %i',N))
        current_t = t_list(i);
        disp(sprintf('Current time is t = %i\n',current_t))
        % find the exact derivative for the terms in this ROM
        exact_full = u_fullify(squeeze(exact_everything(:,:,:,:,:,i)),M_full);
        exact(:,:,:,:,i) = exact_full(res_exact,res_exact,res_exact,:);
        
        % extract u and convert it into a full array with the proper
        % elements eliminated
        temp_u = squeeze(u(:,:,:,:,:,i));
        temp_u_full = u_fullify(temp_u,M_full);
        u_current = u_squishify(temp_u_full,N);
        u_full = u_fullify(u_current,M);
        
        % compute the R_k^i terms for i = 1,2,3,4
        [~,t0hat,t0tilde] = markov_term(u_full,a,b,k,a_tilde);
        t0 = u_squishify(t0hat,N);
        [~,t1hat,t1tilde] = tmodel_term(u_full,t0tilde,a,b,k,a_tilde);
        t1 = u_squishify(t1hat,N);
        [t2,Ahat,Atilde,Bhat,Btilde] = t2model_term(u_full,t0hat,t0tilde,t1tilde,a,b,k,a_tilde);
        t2 = u_squishify(t2,N);
        [t3,Ehat,Etilde,Fhat,Ftilde] = t3model_term(u_full,t0hat,t0tilde,t1hat,t1tilde,Ahat,Atilde,Btilde,a,b,k,a_tilde);
        t3 = u_squishify(t3,N);
        t4 = t4model_term(u_full,t0hat,t0tilde,t1hat,t1tilde,Ahat,Atilde,Bhat,Btilde,Ehat,Etilde,Fhat,Ftilde,a,b,k,a_tilde);
        t4 = u_squishify(t4,N);
        
        % if time dependence is included, scale the terms
        if time
            
            t1 = t1*current_t;
            t2 = t2*current_t^2;
            t3 = t3*current_t^3;
            t4 = t4*current_t^4;
            
        end
        
        % compute the energy derivative due to the R_0 term
        t0_energy = t0.*conj(u_current) + conj(t0).*u_current;
        t0_energy = u_fullify(t0_energy,M_full);
        R0(:,:,:,:,i) = t0_energy(res_exact,res_exact,res_exact,:);
        
        % compute the energy derivative due to the R_1 term
        t1_energy = t1.*conj(u_current) + conj(t1).*u_current;
        t1_energy = u_fullify(t1_energy,M_full);
        R1(:,:,:,:,i) = t1_energy(res_exact,res_exact,res_exact,:);
        
        % compute the energy derivative due to the R_2 term
        t2_energy = t2.*conj(u_current) + conj(t2).*u_current;
        t2_energy = u_fullify(t2_energy,M_full);
        R2(:,:,:,:,i) = t2_energy(res_exact,res_exact,res_exact,:);
        
        % compute the energy derivative due to the R_3 term
        t3_energy = t3.*conj(u_current) + conj(t3).*u_current;
        t3_energy = u_fullify(t3_energy,M_full);
        R3(:,:,:,:,i) = t3_energy(res_exact,res_exact,res_exact,:);
        
        % compute the energy derivative due to the R_4 term
        t4_energy = t4.*conj(u_current) + conj(t4).*u_current;
        t4_energy = u_fullify(t4_energy,M_full);
        R4(:,:,:,:,i) = t4_energy(res_exact,res_exact,res_exact,:);
        
    end
    
    % compute the RHS for the least squares solve
    R0 = R0 - exact;
    b = -[sum(R0(:).*R1(:))
        sum(R0(:).*R2(:))
        sum(R0(:).*R3(:))
        sum(R0(:).*R4(:))];
    
    % construct the matrix for the least squares solve
    A11 = sum(R1(:).*R1(:));
    A12 = sum(R1(:).*R2(:));
    A13 = sum(R1(:).*R3(:));
    A14 = sum(R1(:).*R4(:));
    
    A21 = A12;
    A22 = sum(R2(:).*R2(:));
    A23 = sum(R2(:).*R3(:));
    A24 = sum(R2(:).*R4(:));
    
    A31 = A13;
    A32 = A23;
    A33 = sum(R3(:).*R3(:));
    A34 = sum(R3(:).*R4(:));
    
    A41 = A14;
    A42 = A24;
    A43 = A34;
    A44 = sum(R4(:).*R4(:));
    
    % solve the system and store the result
    A = [A11 A12 A13 A14
        A21 A22 A23 A24
        A31 A32 A33 A34
        A41 A42 A43 A44];
    coeff_array(:,j) = A\b
end
