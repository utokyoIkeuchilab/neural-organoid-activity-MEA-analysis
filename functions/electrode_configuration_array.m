function [Signal_array]=electrode_configuration_array(LP_HP_Signal, electode_position)

length_electrode_position=length(electode_position);
tl=length(LP_HP_Signal(:,1));

Signal_array=zeros(tl, 64);

for i=1:length_electrode_position
readpoistion=electode_position(1, i);
Signal_array(:, readpoistion)= LP_HP_Signal(:, i);
end

end