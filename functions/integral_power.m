function [LFP_POWER, zerotwotozerofive_POWER, DELTA_POWER, THETA_POWER, ALPHA_POWER, BETA_POWER, GAMMA_POWER] = integral_power(DS_time_ms_lim,LP_Signal_fix_single_lim,xrec1, xrec2, xrec3, xrec4, xrec5, xrec6)

%LFP

square_LFP= LP_Signal_fix_single_lim.^2;

x= DS_time_ms_lim;

y= square_LFP;

LFP_POWER= trapz(x,y);

%0.2-0.5 

square_Delta= xrec1.^2;

x= DS_time_ms_lim;

y= square_Delta;

zerotwotozerofive_POWER= trapz(x,y);


%Delta 

square_Delta= xrec2.^2;

x= DS_time_ms_lim;

y= square_Delta;

DELTA_POWER= trapz(x,y);

%Theta

square_Theta= xrec3.^2;

x= DS_time_ms_lim;

y= square_Theta;

THETA_POWER= trapz(x,y);

%Alpha

square_Alpha= xrec4.^2;

x= DS_time_ms_lim;

y= square_Alpha;

ALPHA_POWER= trapz(x,y);

%Beta

square_Beta= xrec5.^2;

x= DS_time_ms_lim;

y= square_Beta;

BETA_POWER= trapz(x,y);

%Gamma

square_Gamma= xrec6.^2;

x= DS_time_ms_lim;

y= square_Gamma;

GAMMA_POWER= trapz(x,y);

%%Print results in export file

formatSpec_LFP= ['LFP Integral of power: ', num2str(LFP_POWER)];
formatSpec_Delta= ['Delta Integral of power: ', num2str(DELTA_POWER)];
formatSpec_Theta= ['Theta Integral of power: ', num2str(THETA_POWER)];
formatSpec_Alpha= ['Alpha Integral of power: ', num2str(ALPHA_POWER)];
formatSpec_Beta= ['Beta Integral of power: ', num2str(BETA_POWER)];
formatSpec_Gamma= ['Gamma Integral of power: ', num2str(GAMMA_POWER)];

disp(['LFP Integral of power: ' num2str(LFP_POWER)])
disp(['Delta Integral of power: ', num2str(DELTA_POWER)])
disp(['Theta Integral of power: ', num2str(THETA_POWER)])
disp(['Alpha Integral of power: ', num2str(ALPHA_POWER)])
disp(['Beta Integral of power: ', num2str(BETA_POWER)])
disp(['Gamma Integral of power: ', num2str(GAMMA_POWER)])

end

