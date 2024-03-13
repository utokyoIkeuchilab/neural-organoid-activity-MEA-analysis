function []=wavelet_coherence(Fs, time_ms,LP_Signal_fix, Downsample_rate, t1, t2, e1, e2, PhaseDisplayThreshold)

dFs=Fs/Downsample_rate;
DS_LP_Signal= downsample(LP_Signal_fix, Downsample_rate);
DS_time_ms= downsample(time_ms, Downsample_rate);
DS_time_ms_lim= DS_time_ms(t1:t2,:);

DS_LP_Signal_single_e1=DS_LP_Signal(:, e1);
DS_LP_Signal_single_e2=DS_LP_Signal(:, e2);
DS_LP_Signal_single_e1_lim= DS_LP_Signal_single_e1(t1:t2,:);
DS_LP_Signal_single_e2_lim= DS_LP_Signal_single_e2(t1:t2,:);


% Calculation range
% DC removal
% d = designfilt('bandstopiir','FilterOrder',2, ...
%                'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
%                'DesignMethod','butter','SampleRate',Fs);
%            
% DCR_LP_Signal = filtfilt(d,DS_LP_Signal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
    fig1 = figure;
    fig1.PaperUnits      = 'centimeters';
    fig1.Units           = 'centimeters';
    fig1.Color           = 'w';
    fig1.InvertHardcopy  = 'off';
    fig1.Name            = [num2str(e1), 'vs', num2str(e2),' Wavelet_coherence'];
    fig1.DockControls    = 'on';
    fig1.WindowStyle    = 'docked';
    fig1.NumberTitle     = 'off';
    set(fig1,'defaultAxesXColor','k');
    figure(fig1);

    wcoherence(DS_LP_Signal_single_e1_lim,DS_LP_Signal_single_e2_lim,dFs, 'PhaseDisplayThreshold',PhaseDisplayThreshold);
    ax = gca;
    ytick=round(pow2(ax.YTick),3);
    ax.YTickLabel=ytick;
    ax.YLabel.String='Frequency (Hz)';
    ax.Title.String = 'Wavelet Coherence';
    % colormap(flipud(hot))
    colormap(jet)
    caxis([0 1.5])
end