function [ stimulus ] = createStimulus(lambda, totalTime, numNeurons )

numSpikes = lambda*totalTime/10000;

a = floor(exprnd(totalTime/numSpikes,numNeurons, floor(numSpikes)+10));

stimulus = zeros(numNeurons, totalTime);
a = cumsum(a,2);


for i = 1:numNeurons
    stimulus(i,a(i,:)) = 1;
end
%zeros(numNeurons,totalTime);


 
end
