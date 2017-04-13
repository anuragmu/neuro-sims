function [ Iapp ] = synapticCurrent( arrival_times, strengths, totalTime)

tau = 15;
taus = tau/4;
numNeurons = size(arrival_times, 1);

Iapp = zeros(numNeurons,totalTime);


% numSynapse = cellfun(@size,arrival_times,'uni',false);

% 
% t_insts = arrival_times{j};

for j = 1:numNeurons
    
    for t = arrival_times{j}
        Iapp(j,:) = Iapp(j,:) + repmat(1e-12*strengths{j}(arrival_times{j}==t),1,totalTime).*expTransform(t,totalTime);
    end
end

end