function [DS_signal, DS_time_ms, dFs]=down_sampling(Fs,time_ms, Signal, Downsample_rate)

dFs=Fs/Downsample_rate;
DS_signal= downsample(Signal, Downsample_rate);
DS_time_ms= downsample(time_ms, Downsample_rate);
end