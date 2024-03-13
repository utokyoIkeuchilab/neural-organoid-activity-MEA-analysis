function [All_burst_locs, All_burst_spikes, All_interburst_interval_sec, Mean_burst_frequency, dev_interburst_interval, inter_burst_interval_CV]=burst_detection(Fs, time_ms, num_electrode, LP_Signal_fix, HP_Signal_fix, All_spikes, bin_win, burst_th, visual_on)

% bin_win= 100;%msec bin_win has to be 100
     
tl=length(time_ms);
total_duration=tl/Fs;
bin_window=total_duration*1000/bin_win;
Mean_burst_frequency=zeros(num_electrode, 1);
dev_interburst_interval=zeros(num_electrode, 1);
% All_interburst_interval_sec=zeros(num_electrode, 1);

for i=1:num_electrode
    if visual_on==1
     fig1 = figure;
     fig1.PaperUnits      = 'centimeters';
     fig1.Units           = 'centimeters';
     fig1.Color           = 'w';
     fig1.InvertHardcopy  = 'off';
     fig1.Name            = ['#',num2str(i),' Burst detection overview'];
     fig1.NumberTitle     = 'off';
     fig1.DockControls    = 'on';
     fig1.WindowStyle    = 'docked';
     set(fig1,'defaultAxesXColor','k');
     figure(fig1);
     
    subplot(311)
    plot(time_ms/1000, LP_Signal_fix(:, i));
    ylabel('Amplitude (mV)'); xlabel('Time (s)')
    xlim([0 100])
    
    subplot(312)
    plot(time_ms/1000, HP_Signal_fix(:, i));
    ylabel('Amplitude (mV)'); xlabel('Time (s)')
    xlim([0 100])
    
    subplot(313)
    % histogram(All_spikes_neg{1, 1}, bin_window);
    [N,~] = histcounts(All_spikes{i, 1}, bin_window);
    [burst_spikes, burst_locs] = findpeaks(N,'MinPeakHeight',burst_th );
    
    hold on 
    plot(N);
    plot(burst_locs, burst_spikes, 'o');
    ylabel('Spike Count'); xlabel('Time (ds)')
    hold off
    xlim([0 100000/bin_win])
   
    All_burst_spikes{i,1}=burst_spikes;
    All_burst_locs{i,1}=burst_locs;
    All_burst_locs{i,1}=burst_locs;
    interburst_interval=diff(burst_locs/10);
    All_interburst_interval_sec{i,1}=interburst_interval;
    Mean_burst_frequency(i,1)=1/mean(interburst_interval);
    dev_interburst_interval(i,1)=std(interburst_interval);
    inter_burst_interval_CV(i,1)=nanstd(interburst_interval)/nanmean(interburst_interval);
    
    else
     [N,~] = histcounts(All_spikes{i, 1}, bin_window);
    [burst_spikes, burst_locs] = findpeaks(N,'MinPeakHeight',burst_th );
    All_burst_spikes{i,1}=burst_spikes;
    All_burst_locs{i,1}=burst_locs;
    interburst_interval=diff(burst_locs/10);
    All_interburst_interval_sec{i,1}=interburst_interval;
    Mean_burst_frequency(i,1)=1/mean(interburst_interval);
    dev_interburst_interval(i,1)=std(interburst_interval);
    inter_burst_interval_CV(i,1)=nanstd(interburst_interval)/nanmean(interburst_interval);
    end
end


end