function [fanouts, delays] = createRandomFanouts (numExcitatory, numInhibitory, numFanout)

    numNeurons = numExcitatory + numInhibitory;
    fanouts = zeros(numNeurons, numFanout);
    delays = ones(numNeurons, numFanout);
%     strengths = 3000*ones(numNeurons, numFanout);
%     strengths(numExcitatory+1:numNeurons, numFanout)=-1;
    for i=1:numExcitatory
        fanouts(i,:) = datasample(1:numNeurons, numFanout ,'Replace',false);
    end
    
    delays(1:numExcitatory, :) = randi (20, numExcitatory, numFanout);

    for i=numExcitatory+1:numNeurons
        fanouts(i,:) = datasample(1:numExcitatory, numFanout ,'Replace',false);
    end

end