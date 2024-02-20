function [Signal]=binshort2signal(bin_filename,measurement_duration_ms, num_electrode, conversion_index)

fileID_bin = fopen(bin_filename);
measurement_duration_data=measurement_duration_ms*20;
A = fread(fileID_bin,[num_electrode measurement_duration_data],'short', 'n');
time_temp=[measurement_duration_ms: -0.05: 0];
time = rot90(time_temp);
time(measurement_duration_ms+1, :)=[];

trans_A = transpose(A);
B=trans_A*conversion_index;
Signal=horzcat(time, B);
end