%% Main script
clear all
close all
clc

%% Set parameters
Fs=20000; % Sampling frequency


%% Load and import data
Signal = struct2array(load('C:\Users\Tomoya\Projects\complex_activity_data_analysis\data\example_trace.mat'));


%% Preprocess data 
num_electrode=4;

% filter Signal, LP_Signal_fix = lowpass <1000Hz, HP_Signal_fix = bandpass 300-3000Hz
[LP_Signal_fix, HP_Signal_fix, time_ms]=filter_signal(Fs, num_electrode, Signal);

tl=length(time_ms);


%% Spike detection
%if you need visuaiztion of spike detection result set visual_on=1
%otherwise visual_on=0
visual_on=1;
magnification=4; % magnification *STDEV for spike detection

[All_spikes_pos, All_spikes_neg, Mean_posspks_amp, Mean_negspks_amp, Num_posspks,Num_negspks, All_interspike_interval_sec, Mean_interspike_interval_sec, All_spikes]=spike_detection(Fs, time_ms, num_electrode, HP_Signal_fix, visual_on, magnification);


%% Burst detection (need spike detection first)
bin_win= 100;% timewindow (in msec)
burst_th=5; %threshold to determine a burst (number of spikes within timewindow)
visual_on=1;

[All_burst_locs, All_burst_spikes, All_interburst_interval_sec, Mean_burst_frequency, dev_interburst_interval, inter_burst_interval_CV]=burst_detection(Fs, time_ms, num_electrode, LP_Signal_fix, HP_Signal_fix, All_spikes, bin_win, burst_th,visual_on);


%% Neuronal avalcnhes (need spike detection first)
def_avalanch_ms=3; % calculating time bin

[logx, Avalanches_probability]=neuronal_avalanches(All_spikes, def_avalanch_ms);


%% Wavelet_transformation
Downsample_rate=20;
t1 = 200; %start time of calculation range (in seconds)
t2 = 300; %end time of calculation range (in seconds)

wavelet_transformation(Fs, time_ms, num_electrode, LP_Signal_fix, Downsample_rate, t1*Fs/Downsample_rate, t2*Fs/Downsample_rate);


%% Wavelet_coherence Signal vs Signal
Downsample_rate=20;
t1 = 1;  %start time of calculation range (in seconds)
t2 = 300; %end time of calculation range (in seconds)
e1=2; %first electrode number
e2=3; %second electrode number
PhaseDisplayThreshold=1;

wavelet_coherence(Fs, time_ms,LP_Signal_fix, Downsample_rate, t1*Fs/Downsample_rate, t2*Fs/Downsample_rate, e1, e2, PhaseDisplayThreshold)


%% Integral Power
Downsample_rate=20; %Down sampling can be used in 1-20 range (20000 Hz-1000 Hz)
t1 = 1;  %start time of calculation range (in seconds)
t2 = 100; %end time of calculation range (in seconds)
electrode=3; %electrode to analyze
dFs = Fs/Downsample_rate;

DS_LP_Signal= downsample(Signal, Downsample_rate);
DS_time_ms= downsample(time_ms, Downsample_rate);
DS_time_ms_lim= DS_time_ms(t1*Fs/Downsample_rate:t2*Fs/Downsample_rate,:);
LP_Signal_fix_single=DS_LP_Signal(:, electrode); %write single electrode signal

%offset correction
LP_Signal_fix_single = LP_Signal_fix_single - mean(LP_Signal_fix_single);
LP_Signal_fix_single_lim= LP_Signal_fix_single(t1*Fs/Downsample_rate:t2*Fs/Downsample_rate,:);

% freqeuncy separation of signal
[wt,f] = cwt(LP_Signal_fix_single_lim,dFs);
xrec1 = icwt(wt,f,[0.2 0.5],'SignalMean',mean(LP_Signal_fix_single_lim));
xrec2 = icwt(wt,f,[0.5 4],'SignalMean',mean(LP_Signal_fix_single_lim));
xrec3 = icwt(wt,f,[4 8],'SignalMean',mean(LP_Signal_fix_single_lim));
xrec4 = icwt(wt,f,[8 12],'SignalMean',mean(LP_Signal_fix_single_lim));
xrec5 = icwt(wt,f,[12 30],'SignalMean',mean(LP_Signal_fix_single_lim));
xrec6 = icwt(wt,f,[30 300],'SignalMean',mean(LP_Signal_fix_single_lim));
  
[LFP_POWER, zerotwotozerofive_POWER,DELTA_POWER, THETA_POWER, ALPHA_POWER, BETA_POWER, GAMMA_POWER] = integral_power(DS_time_ms_lim,LP_Signal_fix_single_lim,xrec1, xrec2, xrec3,xrec4, xrec5, xrec6);


%% Local Phase-amplitude coupling
t1 = 1; %start time of calculation range (in seconds)
t2 = 60; %end time of calculation range (in seconds)
electrode=3;
[MI_delta_gamma,MI_theta_gamma,MI_delta_theta, MI_delta_delta, MI_theta_theta, MI_gamma_gamma]=PAC(Fs, time_ms,LP_Signal_fix,t1*Fs, t2*Fs,electrode);


%%  Inter-regional Phase-amplitude coupling

t1 = 1; %start time of calculation range (in seconds)
t2 = 60; %end time of calculation range (in seconds)
e1=1; %electrode to analyze
e2=4; %second electrode to analyze
irPAC(Fs, time_ms, LP_Signal_fix,t1*Fs, t2*Fs, e1, e2);

