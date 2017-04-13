function [ Iapp ] = synapticCurrentA( arrival_times, strengths, totalTime)

tau = 150;
taus = tau/4;
numNeurons = size(arrival_times, 1);

Iapp = zeros(numNeurons,totalTime);


for j = 1:numNeurons
    
    for k=1:size(arrival_times{j},2)
%         t = arrival_times{j}(k);
        if ((arrival_times{j}(k)<=totalTime))
            Iapp(j,:) = Iapp(j,:) + repmat(1e-12*strengths{j}(k),1,totalTime).*expTransform(arrival_times{j}(k),totalTime);
        end
    end
end

end