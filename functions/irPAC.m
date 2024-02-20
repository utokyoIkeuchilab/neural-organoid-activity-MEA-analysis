function []=irPAC(Fs, time_ms, LP_Signal_fix,t1, t2, e1, e2)

Left=LP_Signal_fix(:, e1);
Right=LP_Signal_fix(:, e2);

time_ms_lim= time_ms(t1:t2,:);

Left_lim= Left(t1:t2, :);
Right_lim= Right(t1:t2, :);


[wt_left,f_left] = cwt(Left_lim,Fs);
[wt_right,f_right] = cwt(Right_lim,Fs);


xrec1_left= icwt(wt_left,f_left,[0.2 0.5],'SignalMean',mean(Left_lim));
xrec2_left = icwt(wt_left,f_left,[0.5 4],'SignalMean',mean(Left_lim));
xrec3_left = icwt(wt_left,f_left,[4 8],'SignalMean',mean(Left_lim));
xrec4_left = icwt(wt_left,f_left,[8 12],'SignalMean',mean(Left_lim)); 
xrec5_left = icwt(wt_left,f_left,[12 30],'SignalMean',mean(Left_lim));
xrec6_left = icwt(wt_left,f_left,[30 300],'SignalMean',mean(Left_lim));

xrec1_right= icwt(wt_right,f_right,[0.2 0.5],'SignalMean',mean(Right_lim));
xrec2_right = icwt(wt_right,f_right,[0.5 4],'SignalMean',mean(Right_lim));
xrec3_right= icwt(wt_right,f_right,[4 8],'SignalMean',mean(Right_lim));
xrec4_right = icwt(wt_right, f_right,[8 12],'SignalMean',mean(Right_lim));
xrec5_right = icwt(wt_right,f_right,[12 30],'SignalMean',mean(Right_lim));
xrec6_right = icwt(wt_right,f_right,[30 300],'SignalMean',mean(Right_lim));


hi_left_delta = hilbert(xrec2_left); %delta
env_delta_left=abs(hi_left_delta);

hi_left_theta = hilbert(xrec3_left); %theta
env_theta_left=abs(hi_left_theta);

hi_left_gamma = hilbert(xrec6_left); %gamma
env_gamma_left=abs(hi_left_gamma);

delta_phase_left=angle(hi_left_delta);
theta_phase_left =angle(hi_left_theta);
gamma_phase_left =angle(hi_left_gamma);


%brainphys
hi_right_delta = hilbert(xrec2_right); %delta
env_delta_right=abs(hi_right_delta);

hi_right_theta = hilbert(xrec3_right); %theta
env_theta_right=abs(hi_right_theta);

hi_right_gamma = hilbert(xrec6_right); %gamma
env_gamma_right=abs(hi_right_gamma);

delta_phase_right =angle(hi_right_delta);
theta_phase_right =angle(hi_right_theta);
gamma_phase_right =angle(hi_right_gamma);

phase_theta = linspace(0,360,360);
phase=deg2rad(phase_theta);

nBins=18;

[MI_deltaR_gammaR,distKL_deltaR_gammaR, amplP_deltaR_gammaR, binCenters_deltaR_gammaR]=modulationIndex(delta_phase_right,env_gamma_right,nBins);
[MI_thetaR_gammaR,distKL_thetaR_gammaR, amplP_thetaR_gammaR, binCenters_thetaR_gammaR]=modulationIndex(theta_phase_right,env_gamma_right,nBins);

[MI_thetaR_deltaR,distKL_thetaR_deltaR, amplP_thetaR_deltaR, binCenters_thetaR_deltaR]=modulationIndex(theta_phase_right,env_delta_right,nBins);
[MI_gammaR_deltaR,distKL_gammaR_deltaR, amplP_gammaR_deltaR, binCenters_gammaR_deltaR]=modulationIndex(gamma_phase_right,env_delta_right,nBins);

[MI_deltaR_thetaR,distKL_deltaR_thetaR, amplP_deltaR_thetaR, binCenters_deltaR_thetaR]=modulationIndex(delta_phase_right,env_theta_right,nBins);
[MI_gammaR_thetaR,distKL_gammaR_thetaR, amplP_gammaR_thetaR, binCenters_gammaR_thetaR]=modulationIndex(gamma_phase_right,env_theta_right,nBins);
% inter-regional PAC

[MI_deltaR_gammaL,distKL_deltaR_gammaL, amplP_deltaR_gammaL, binCenters_deltaR_gammaL]=modulationIndex(delta_phase_right,env_gamma_left,nBins);
[MI_deltaL_gammaR,distKL_deltaL_gammaR, amplP_deltaL_gammaR, binCenters_deltaL_gammaR]=modulationIndex(delta_phase_left,env_gamma_right,nBins);

[MI_thetaR_gammaL,distKL_thetaR_gammaL, amplP_thetaR_gammaL, binCenters_thetaR_gammaL]=modulationIndex(theta_phase_right,env_gamma_left,nBins);
[MI_thetaL_gammaR,distKL_thetaL_gammaR, amplP_thetaL_gammaR, binCenters_thetaL_gammaR]=modulationIndex(theta_phase_left,env_gamma_right,nBins);

[MI_deltaR_thetaL,distKL_deltaR_thetaL, amplP_deltaR_thetaL, binCenters_deltaR_thetaL]=modulationIndex(delta_phase_right,env_theta_left,nBins);
[MI_deltaL_thetaR,distKL_deltaL_thetaR, amplP_deltaL_thetaR, binCenters_deltaL_thetaR]=modulationIndex(delta_phase_left,env_theta_right,nBins);

  fig1 = figure;
    fig1.PaperUnits      = 'centimeters';
    fig1.Units           = 'centimeters';
    fig1.Color           = 'w';
    fig1.InvertHardcopy  = 'off';
    fig1.Name            = [num2str(e1), 'vs', num2str(e2),' Local Phase-amplitude coupling'];
    fig1.DockControls    = 'on';
    fig1.WindowStyle    = 'docked';
    fig1.NumberTitle     = 'off';
    set(fig1,'defaultAxesXColor','k');
    figure(fig1);
    
subplot(331)
bar([rad2deg(binCenters_deltaR_gammaR)+200 rad2deg(binCenters_deltaR_gammaR+2*pi)+200],[amplP_deltaR_gammaR amplP_deltaR_gammaR], 'r');
title('Lcal PAC');
ylabel('Moduation Index');

subplot(332)
bar([rad2deg(binCenters_deltaR_gammaL)+200 rad2deg(binCenters_deltaR_gammaL+2*pi)+200],[amplP_deltaR_gammaL amplP_deltaR_gammaL]);
title('Delta R/Gamma L');
ylabel('Moduation Index');

subplot(333)
bar([rad2deg(binCenters_deltaL_gammaR)+200 rad2deg(binCenters_deltaL_gammaR+2*pi)+200],[amplP_deltaL_gammaR amplP_deltaL_gammaR]);
title('Delta L/Gamma R');
ylabel('Moduation Index');

subplot(334)
bar([rad2deg(binCenters_thetaR_gammaR)+200 rad2deg(binCenters_thetaR_gammaR+2*pi)+200],[amplP_thetaR_gammaR amplP_thetaR_gammaR], 'r');
title('Lcal PAC');
ylabel('Moduation Index');

subplot(335)
bar([rad2deg(binCenters_thetaR_gammaL)+200 rad2deg(binCenters_thetaR_gammaL+2*pi)+200],[amplP_thetaR_gammaL amplP_thetaR_gammaL]);
title('Theta R/Gamma L');
ylabel('Moduation Index');

subplot(336)
bar([rad2deg(binCenters_thetaL_gammaR)+200 rad2deg(binCenters_thetaL_gammaR+2*pi)+200],[amplP_thetaL_gammaR amplP_thetaL_gammaR]);
title('Theta L/Gamma R');

subplot(337)
bar([rad2deg(binCenters_deltaR_thetaR)+200 rad2deg(binCenters_deltaR_thetaR+2*pi)+200],[amplP_deltaR_thetaR amplP_deltaR_thetaR], 'r');
title('Lcal PAC');
ylabel('Moduation Index');

subplot(338)
bar([rad2deg(binCenters_deltaR_thetaL)+200 rad2deg(binCenters_deltaR_thetaL+2*pi)+200],[amplP_deltaR_thetaL amplP_deltaR_thetaL]);
title('Delta R/Theta L');
ylabel('Moduation Index');

subplot(339)
bar([rad2deg(binCenters_deltaL_thetaR)+200 rad2deg(binCenters_deltaL_thetaR+2*pi)+200],[amplP_deltaL_thetaR amplP_deltaL_thetaR]);
title('Delta L/Theta R');
ylabel('Moduation Index');

disp("Modulatio Index");
disp([MI_deltaR_gammaR MI_deltaR_gammaL MI_deltaL_gammaR ]);
disp([MI_thetaR_gammaR MI_thetaR_gammaL MI_thetaL_gammaR ]);
disp([MI_deltaR_thetaR MI_deltaR_thetaL MI_deltaL_thetaR ]);