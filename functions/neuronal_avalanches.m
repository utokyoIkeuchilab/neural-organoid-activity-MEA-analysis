function [x, Avalanches_probability]=neuronal_avalanches(All_spikes, def_avalanch_ms)

All_spikes_rep1=All_spikes;
All_spikes_rep1(:, 2)=[];
Merged_All_spikes=sort(cell2mat(All_spikes_rep1));
Merged_All_spikes_ms=Merged_All_spikes*1000;
Merged_All_spikes_number=length(Merged_All_spikes_ms);
D=diff(Merged_All_spikes_ms);

fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Neuronal avalanches overview'
fig1.NumberTitle     = 'off'
fig1.DockControls    = 'on';
fig1.WindowStyle    = 'docked';
A=D<def_avalanch_ms;
subplot(411)
plot(Merged_All_spikes_ms);
subplot(412)
plot(D);
subplot(413)
plot(A);
ylim([0 2])
subplot(414)
% num_peaks=findpeaks(A);
% Integral=trapz(A);

ylim([0 2]);
t=1;
con=1;
clear avalanch;

for i=1:Merged_All_spikes_number-1
    
    if A(i)==0
     avalanch(:, t)= con-1;
     con=1;
     t=t+1;
    else
    
     con=con+1;
    
    end
    
end
plot(avalanch);

fig1 = figure;
fig1.PaperUnits      = 'centimeters';
fig1.Units           = 'centimeters';
fig1.Color           = 'w';
fig1.InvertHardcopy  = 'off';
fig1.Name            = 'Histogram Neuronal avalanches'
fig1.NumberTitle     = 'off'
fig1.DockControls    = 'on';
fig1.WindowStyle    = 'docked';
     
set(fig1,'defaultAxesXColor','k');
edge = logspace(0,2 , 10);
set(gca,'XScale','log')
set(gca,'YScale','log')
histogram(avalanch*def_avalanch_ms, edge);
[~, L]=bounds(avalanch);
[N, edges]=histcounts(avalanch, L);
% ylim([0 20])

fig2 = figure;
fig2.PaperUnits      = 'centimeters';
fig2.Units           = 'centimeters';
fig2.Color           = 'w';
fig2.InvertHardcopy  = 'off';
fig2.Name            = 'Neuronal avalanches'
fig2.NumberTitle     = 'off'
fig2.DockControls    = 'on';
fig2.WindowStyle    = 'docked';
set(fig2,'defaultAxesXColor','k');

S=sum(N);
Avalanches_probability=N/S;
x=1:1:L;
logProb=log(Avalanches_probability);
logx=log(x);

plot(x, Avalanches_probability,'o');
edges = logspace(0,2 ,10);
set(gca,'XScale','log')
set(gca,'YScale','log')
xlim([1 1000])

