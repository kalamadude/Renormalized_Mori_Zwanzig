% produces plots demonstrating the scaling laws for algebraically decaying
% renormalization coefficient ROMs of Burgers' equation

clear all;close all;

endtime = 10;
N_list = 10:2:24;

% load the exact data if it exists (or create it)
if ~(exist(sprintf('u_list%i.mat',endtime),'file') == 2)
    
    [t_list,u_list,exact_derivative] = create_data(1,10000,10,1e-4,100);
     
else
     load(sprintf('u_list%i',endtime));
     load(sprintf('t_list%i',endtime));
     load(sprintf('exact_derivative%i',endtime));
end

% calculate optimal renormalization coefficients and laws
[c1KdVo,c2KdVo,c3KdVo,c4KdVo] = renormalize(1,N_list,u_list,t_list,exact_derivative,1);

[c1KdVo_laws,r1KdV] = create_scaling_laws(N_list,c1KdVo);
[c2KdVo_laws,r2KdV] = create_scaling_laws(N_list,c2KdVo);
[c3KdVo_laws,r3KdV] = create_scaling_laws(N_list,c3KdVo);
[c4KdVo_laws,r4KdV] = create_scaling_laws(N_list,c4KdVo);


colors = linspecer(4,'qualitative');
dots = zeros(4,4);

% load data into arrays for looping
coeff_array = zeros(4,length(N_list),4);
coeff_array(1,:,1) = c1KdVo;
coeff_array(1:2,:,2) = c2KdVo;
coeff_array(1:3,:,3) = c3KdVo;
coeff_array(1:4,:,4) = c4KdVo;

scaling_laws = zeros(4,2,4);
scaling_laws(1,:,1) = c1KdVo_laws;
scaling_laws(1:2,:,2) = c2KdVo_laws;
scaling_laws(1:3,:,3) = c3KdVo_laws;
scaling_laws(1:4,:,4) = c4KdVo_laws;

% plot the data and fits
for j = 1:4
    figure(1)
    subplot(2,2,1)
    a = plot(log(N_list),log(squeeze(coeff_array(1,:,j))),'.','markersize',20,'color',colors(j,:));
    dots(1,j) = a;
    hold on
    plot([2,log(N_list(end))*1.1],polyval(scaling_laws(1,:,j),[2,log(N_list(end))*1.1]),'color',colors(j,:))
    
    title('t-model coefficient','fontsize',16)
    xlabel('log(N)')
    ylabel('log(a''_1)')
    
    if j > 1
        
        subplot(2,2,2)
        a = plot(log(N_list),log(-squeeze(coeff_array(2,:,j))),'.','markersize',20,'color',colors(j,:));
        dots(2,j) = a;
        hold on
        plot([2,log(N_list(end))*1.1],polyval(scaling_laws(2,:,j),[2,log(N_list(end))*1.1]),'color',colors(j,:))
        
        title('t^2-model coefficient','fontsize',16)
        xlabel('log(N)')
        ylabel('log(-a''_2)')
        
        if j > 2
            
            subplot(2,2,3)
            a = plot(log(N_list),log(squeeze(coeff_array(3,:,j))),'.','markersize',20,'color',colors(j,:));
            dots(3,j) = a;
            hold on
            plot([2,log(N_list(end))*1.1],polyval(scaling_laws(3,:,j),[2,log(N_list(end))*1.1]),'color',colors(j,:))
            
            title('t^3-model coefficient','fontsize',16)
            xlabel('log(N)')
            ylabel('log(a''_3)')
            
            if j > 3
                
                subplot(2,2,4)
                a = plot(log(N_list),log(-squeeze(coeff_array(4,:,j))),'.','markersize',20,'color',colors(j,:));
                dots(4,j) = a;
                hold on
                plot([2,log(N_list(end))*1.1],polyval(scaling_laws(4,:,j),[2,log(N_list(end))*1.1]),'color',colors(j,:))
                
                title('t^4-model coefficient','fontsize',16)
                xlabel('log(N)')
                ylabel('log(-a''_4)')
            end
        end
    end
end



% add legends and save files
subplot(2,2,1)
legend([dots(1,1) dots(1,2) dots(1,3) dots(1,4)],{'n = 1','n = 2','n = 3','n = 4'},'location','southwest')


subplot(2,2,2)
legend([dots(2,2) dots(2,3) dots(2,4)],{'n = 2','n = 3','n = 4'},'location','southwest')


subplot(2,2,3)
legend([dots(3,3) dots(3,4)],{'n = 3','n = 4'},'location','southwest')


subplot(2,2,4)
legend([dots(4,4)],{'n = 4'},'location','southwest')
saveas(gcf,'burgers_coeffs_algebraic','png')