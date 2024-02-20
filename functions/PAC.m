function [MI_delta_gamma,MI_theta_gamma,MI_delta_theta, MI_delta_delta, MI_theta_theta, MI_gamma_gamma]=PAC(Fs, time_ms, LP_Signal_Fix,t1, t2,electrode)


Signal_single=LP_Signal_Fix(:, electrode);


% t1 = 1; 
% t2 = 500000; 

time_ms_lim= time_ms(t1:t2,:);
Signal_single_lim= Signal_single(t1:t2, :);


[wt,f] = cwt(Signal_single_lim,Fs);

xrec1= icwt(wt,f,[0.2 0.5],'SignalMean',mean(Signal_single_lim));
xrec2 = icwt(wt,f,[0.5 4],'SignalMean',mean(Signal_single_lim));
xrec3 = icwt(wt,f,[4 8],'SignalMean',mean(Signal_single_lim));
% xrec4 = icwt(wt,f,[8 12],'SignalMean',mean(Signal_single_lim)); 
% xrec5 = icwt(wt,f,[12 30],'SignalMean',mean(Signal_single_lim));
xrec6 = icwt(wt,f,[30 300],'SignalMean',mean(Signal_single_lim));


hi_delta = hilbert(xrec2); %delta
env_delta=abs(hi_delta);

hi_theta = hilbert(xrec3); %theta
env_theta=abs(hi_theta);

hi_gamma = hilbert(xrec6); %gamma
env_gamma=abs(hi_gamma);

delta_phase=angle(hi_delta);
theta_phase =angle(hi_theta);
gamma_phase =angle(hi_gamma);


phase_theta = linspace(0,360,360);
phase=deg2rad(phase_theta);

nBins=36;

[MI_delta_gamma,~, amplP_delta_gamma, binCenters_delta_gamma]=modulationIndex(delta_phase,env_gamma,nBins);
[MI_theta_gamma,~, amplP_theta_gamma, binCenters_theta_gamma]=modulationIndex(theta_phase,env_gamma,nBins);
[MI_delta_theta,~, amplP_delta_theta, binCenters_delta_theta]=modulationIndex(delta_phase,env_theta,nBins);

[MI_delta_delta,~, amplP_delta_delta, binCenters_delta_delta]=modulationIndex(delta_phase,env_delta,nBins);
[MI_theta_theta,~, amplP_theta_theta, binCenters_theta_theta]=modulationIndex(theta_phase,env_theta,nBins);
[MI_gamma_gamma,~, amplP_gamma_gamma, binCenters_gamma_gamma]=modulationIndex(gamma_phase,env_gamma,nBins);
% inter-regional ~
  fig1 = figure;
    fig1.PaperUnits      = 'centimeters';
    fig1.Units           = 'centimeters';
    fig1.Color           = 'w';
    fig1.InvertHardcopy  = 'off';
    fig1.Name            = ['#', num2str(electrode),' Local Phase-amplitude coupling'];
    fig1.DockControls    = 'on';
    fig1.WindowStyle    = 'docked';
    fig1.NumberTitle     = 'off';
    set(fig1,'defaultAxesXColor','k');
    figure(fig1);
    
subplot(231)
bar([rad2deg(binCenters_delta_gamma)+200 rad2deg(binCenters_delta_gamma+2*pi)+200],[amplP_delta_gamma amplP_delta_gamma], 'r');
title('Local PAC (delta phase/gamma amp)');
ylabel('Moduation Index');

subplot(232)
bar([rad2deg(binCenters_theta_gamma)+200 rad2deg(binCenters_theta_gamma+2*pi)+200],[amplP_theta_gamma amplP_theta_gamma], 'r');
title('Local PAC (theta phase/gamma amp)');
ylabel('Moduation Index');

subplot(233)
bar([rad2deg(binCenters_delta_theta)+200 rad2deg(binCenters_delta_theta+2*pi)+200],[amplP_delta_theta amplP_delta_theta], 'r');
title('Local PAC (delta phase/theta amp)');
ylabel('Moduation Index');

subplot(234)
bar([rad2deg(binCenters_delta_delta)+200 rad2deg(binCenters_delta_delta+2*pi)+200],[amplP_delta_delta amplP_delta_delta], 'r');
title('Local PAC (delta phase/delta amp)');
ylabel('Moduation Index');

subplot(235)
bar([rad2deg(binCenters_theta_theta)+200 rad2deg(binCenters_theta_theta+2*pi)+200],[amplP_theta_theta amplP_theta_theta], 'r');
title('Local PAC (theta phase/theta amp)');
ylabel('Moduation Index');

subplot(236)
bar([rad2deg(binCenters_gamma_gamma)+200 rad2deg(binCenters_gamma_gamma+2*pi)+200],[amplP_gamma_gamma amplP_gamma_gamma], 'r');
title('Local PAC (gamma phase/gamma amp)');
ylabel('Moduation Index');

disp("Modulatio Index");
disp([MI_delta_gamma MI_theta_gamma MI_delta_theta]);
disp([MI_delta_delta MI_theta_theta MI_gamma_gamma]);