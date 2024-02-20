function []=frequency_separation(Fs, time_ms,num_electrode, LP_Signal_fix,Downsample_rate, t1, t2)

dFs=Fs/Downsample_rate;
DS_LP_Signal= downsample(LP_Signal_fix, Downsample_rate);
DS_time_ms= downsample(time_ms, Downsample_rate);
DS_time_ms_lim= DS_time_ms(t1:t2,:);
% time_ms_lim= time_ms(t1:t2,:);


for i=1:num_electrode
    
    LP_Signal_fix_single=DS_LP_Signal(:, i);
    LP_Signal_fix_single_lim= LP_Signal_fix_single(t1:t2,:);
    
    [wt,f] = cwt(LP_Signal_fix_single_lim,dFs);
    xrec1 = icwt(wt,f,[0.2 0.5],'SignalMean',mean(LP_Signal_fix_single_lim));
    xrec2 = icwt(wt,f,[0.5 4],'SignalMean',mean(LP_Signal_fix_single_lim));
    xrec3 = icwt(wt,f,[4 8],'SignalMean',mean(LP_Signal_fix_single_lim));
%   xrec4 = icwt(wt,f,[8 12],'SignalMean',mean(LP_Signal_fix_single_lim));
%   xrec5 = icwt(wt,f,[12 30],'SignalMean',mean(LP_Signal_fix_single_lim));
    xrec6 = icwt(wt,f,[30 300],'SignalMean',mean(LP_Signal_fix_single_lim));
    
    fig1 = figure;
    fig1.PaperUnits      = 'centimeters';
    fig1.Units           = 'centimeters';
    fig1.Color           = 'w';
    fig1.InvertHardcopy  = 'off';
    fig1.Name            = ['#',num2str(i),' Brain wave analysis'];
    fig1.DockControls    = 'on';
    fig1.WindowStyle    = 'docked';
    fig1.NumberTitle     = 'off';
    set(fig1,'defaultAxesXColor','k');
    figure(fig1);
    
    
    subplot(511)
    plot(DS_time_ms_lim, LP_Signal_fix_single_lim,'LineWidth', 0.5)
    title('Original LFP Right orgnoid')
    set(gca,'ytick',[]);
    set(gca,'ycolor',[1 1 1])
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])
    xlim([min(DS_time_ms_lim) max(DS_time_ms_lim)])

    
    subplot(512)
    plot(DS_time_ms_lim, xrec1, 'LineWidth', 0.75)
    title('Bandpass Filtered Reconstruction [0.2-0.5] Hz')
    ylim([-0.02 0.02])
    xlim([min(DS_time_ms_lim) max(DS_time_ms_lim)])
    set(gca,'ytick',[]);
    set(gca,'ycolor',[1 1 1])
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])
    
    subplot(513)
    plot(DS_time_ms_lim, xrec2, 'LineWidth', 0.75)
    title('Delta wave [0.5-4] Hz')
    ylim([-0.03 0.03])
    xlim([min(DS_time_ms_lim) max(DS_time_ms_lim)])

    set(gca,'ytick',[]);
    set(gca,'ycolor',[1 1 1])
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])
    
    subplot(514)
    plot(DS_time_ms_lim, xrec3, 'LineWidth', 0.75)
    title('Theta wave [4-8] Hz')
    ylim([-0.01 0.01])
    xlim([min(DS_time_ms_lim) max(DS_time_ms_lim)])

    set(gca,'ytick',[]);
    set(gca,'ycolor',[1 1 1])
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])
     
%     subplot(715)
%     plot(time_ms_lim, xrec4)
%     title('Alpha w]ave [8-12] Hz')
% %     ylim([-0.001 0.001])
% 
%     subplot(716)
%     plot(time_ms_lim, xrec5)
%     title('Beta [12-30] Hz')
%     xlabel('Time (msec)')
% %     ylim([-0.001 0.001])
%     
    subplot(515)
    plot(DS_time_ms_lim, xrec6, 'LineWidth', 0.5)
    title('Gamma wave [30-300] Hz')
    xlabel('Time (msec)')
    ylim([-0.02 0.02])
    xlim([min(DS_time_ms_lim) max(DS_time_ms_lim)])

    set(gca,'ytick',[]);
    set(gca,'ycolor',[1 1 1])
    set(gca,'xtick',[]);
    set(gca,'xcolor',[1 1 1])

end

end