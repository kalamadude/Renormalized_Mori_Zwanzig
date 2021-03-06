%shows how exact energy derivative compares to ROM energy derivatives R1 through R3
addpath ../simulation_functions
addpath ../nonlinear
addpath ../analysis

%parameter details for simulation
simulation_params.epsilon = 0.1;  %coefficient on linear term in KdV
simulation_params.alpha = 1;      %coefficient on nonlinear term in KdV
simulation_params.dt = 1e-3;      %timestep
simulation_params.endtime = 10;   %end of simulation
simulation_params.howoften = 10;  %how often to save state vector
simulation_params.blowup = 1;     %if 1, instabilities cause simulation to end, but not give error
simulation_params.tol = inf;      %tolerance for identifying instabilities
simulation_params.N = 128;        %number of positive modes to simulate

simulation_params.initialization = @(x) full_init_KdV(x);   

%find exact solution
[t_list,u_list] = PDE_solve(simulation_params);

simulation_params = full_init_KdV(simulation_params);

[u_deriv_list,energy_flow_list,nonlin0_energy_flow,nonlin1_energy_flow,nonlin2_energy_flow,nonlin3_energy_flow,nonlin4_energy_flow] = generate_deriv_data_4func(t_list,u_list,simulation_params,20);


energy_deriv = figure;

subplot(3,1,1)
set(gca,'FontSize',16)
plot(t_list,sum(energy_flow_list(1:20,:)),'k')
title('Exact mass derivative of first 20 modes','fontsize',16,'interpreter','latex')
xlabel('time','fontsize',16,'interpreter','latex')
ylabel('$\Delta M_F$','fontsize',16,'interpreter','latex')


subplot(3,1,2)
set(gca,'FontSize',16)
plot(t_list,sum(squeeze(nonlin2_energy_flow(1,1:20,:))),'k')
title('Mass derivative due to $R_k^2$ of first 20 modes','fontsize',16,'interpreter','latex')
xlabel('time','fontsize',16,'interpreter','latex')
ylabel('$\Delta M_F^2$','fontsize',16,'interpreter','latex')


subplot(3,1,3)
set(gca,'FontSize',16)
plot(t_list,sum(squeeze(nonlin4_energy_flow(1,1:20,:))),'k')
title('Mass derivative due to $R_k^4$ of first 20 modes','fontsize',16,'interpreter','latex')
xlabel('time','fontsize',16,'interpreter','latex')
ylabel('$\Delta M_F^4$','fontsize',16,'interpreter','latex')

saveas(energy_deriv,'compare_energy','png')