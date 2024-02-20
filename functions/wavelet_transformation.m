function []=wavelet_transformation(Fs, time_ms, num_electrode, LP_Signal_fix, Downsample_rate, t1, t2)

dFs=Fs/Downsample_rate;
DS_LP_Signal= downsample(LP_Signal_fix, Downsample_rate);
DS_time_ms= downsample(time_ms, Downsample_rate);
DS_time_ms_lim= DS_time_ms(t1:t2,:);

% Calculation range
% DC removal
% d = designfilt('bandstopiir','FilterOrder',2, ...
%                'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
%                'DesignMethod','butter','SampleRate',Fs);
%            
% DCR_LP_Signal = filtfilt(d,DS_LP_Signal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for i=1:num_electrode
    DS_LP_Signal_single=DS_LP_Signal(:, i);
    
    DS_LP_Signal_lim= DS_LP_Signal_single(t1:t2,:);
    [wt,f] = cwt(DS_LP_Signal_lim, dFs,'FrequencyLimits',[0 100]);
    % cwt(DS_LP_LE1_lim,dFs, 'FrequencyLimits',[0 100]);
    
    fig1 = figure;
    fig1.PaperUnits      = 'centimeters';
    fig1.Units           = 'centimeters';
    fig1.Color           = 'w';
    fig1.InvertHardcopy  = 'off';
    fig1.Name            = ['#', num2str(i), ' Time-Frequency analysis'];
    fig1.DockControls    = 'on';
    fig1.WindowStyle    = 'docked';
    fig1.NumberTitle     = 'off';
    set(fig1,'defaultAxesXColor','k');
    figure(fig1);
    
    title('Signal and Scalogram')
    subplot(211)
    plot(DS_time_ms_lim/1000, DS_LP_Signal_lim);
    xlim([t1/1000 t2/1000]);
    ylim([-0.2 0.2]);
    xlabel('Time (s)');
    ylabel('Amplitude (mV)');
    
    subplot(212)
    [minf,maxf] = cwtfreqbounds(numel(DS_LP_Signal_lim),dFs);
    tms = (0:numel(DS_LP_Signal_lim)-1)/dFs;
    AX = gca;
    freq = 2.^(round(log2(minf)):round(log2(maxf)));
    AX.YTickLabelMode = 'auto';
    AX.YTick = freq;
    caxis([0 0.03])
    surface(tms,f,abs(wt));
    axis tight
    shading flat
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    set(gca,'yscale','log')
    colormap jet;
    
end