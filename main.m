%% Main script
clear all
close all
clc

%% Set parameters
% Sampling frequency
Fs=20000;


%% Load and import data

filename = 'C:\Users\Tomoya\Projects\complex_activity_data_analysis\data\c2_d57_s3.csv';
delimiter = ',';
startRow = 4;
formatSpec = '%f%f%f%f%f%f%f%f%f%[^\n\r]';

fileID = fopen(filename,'r');
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false);
fclose(fileID);
Signal = [dataArray{1:end-1}];
clearvars  filename delimiter startRow formatSpec fileID dataArray ans;

%% Preprocess data process
tic
electode_position=[15 16 22 24 55 56 62 63];

num_electrode=8;
time=[2: -0.05: -1];
t = rot90(time);
%/////////////////////

% Bandpass filter
[LP_Signal_fix, HP_Signal_fix, time_ms]=filter_signal(Fs, num_electrode, Signal);

tl=length(time_ms);
toc

%% Spike detection
tic
%if you need visuaiztion of spike detection result set visual_on=1
%otherwise visual_on=0
visual_on=1;

magnification=4; % magnification *STDEV

[All_spikes_pos, All_spikes_neg, Mean_posspks_amp, Mean_negspks_amp, Num_posspks,Num_negspks, All_interspike_interval_sec, Mean_interspike_interval_sec, All_spikes]=spike_detection(Fs, time_ms, num_electrode, HP_Signal_fix, visual_on, magnification);
toc

%% Burst detection (need spike detection first)
%Burst determination
bin_win= 100;%msec
burst_th=5;
visual_on=1;

tic
[burst_locs, burst_spikes, All_interburst_interval_sec, Mean_burst_frequency, dev_interburst_interval, CV]=burst_detection(Fs, time_ms, num_electrode, LP_Signal_fix, HP_Signal_fix, All_spikes, bin_win, burst_th,visual_on);
toc


%% Neuronal avalcnhes (need spike detection first)

def_avalanch_ms=3;
[logx, Avalanches_probability]=neuronal_avalanches(All_spikes(5:8,:), def_avalanch_ms);


%% Wavelet_transformation

tic
%/////////////////////
t1 = 1; 
t2 = 30000;
Downsample_rate=20;

%/////////////////////
wavelet_transformation(Fs, time_ms, num_electrode, LP_Signal_fix, Downsample_rate, t1, t2);

toc

%% Wavelet_coherence Signal vs Signal
%/////////////////////
t1 = 1; 
t2 = 30000;
e1=6;
e2=7;
Downsample_rate=20;
PhaseDisplayThreshold=1;
%//////////////////////
tic
wavelet_coherence(Fs, time_ms,LP_Signal_fix, Downsample_rate, t1, t2, e1, e2, PhaseDisplayThreshold)
toc

%% Brain wave analysis(Frequency separation)
%--------------------------------------------------------------------------
%Calculation range
t1 = 1000000; 
t2 = 2000000;
Downsample_rate=1; %Down sampling can be used in 1-20 range (20000 Hz-1000 Hz)
%--------------------------------------------------------------------------

tic
frequency_separation(Fs, time_ms,num_electrode, LP_Signal_fix,Downsample_rate, t1, t2);
toc


%% Local Phase-amplitude coupling
t1 = 1; 
t2 = 500000; 
electrode=5;
[MI_delta_gamma,MI_theta_gamma,MI_delta_theta, MI_delta_delta, MI_theta_theta, MI_gamma_gamma]=PAC(Fs, time_ms,LP_Signal_fix,t1, t2,electrode);

%%  Inter-regional Phase-amplitude coupling

t1 = 1; 
t2 = 500000; 
e1=5;
e2=7;
irPAC(Fs, time_ms, LP_Signal_fix,t1, t2, e1, e2);

