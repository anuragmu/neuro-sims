%% Problem 1: Representing synaptic connectivity and axonal delays: (a) Neural Network definition

fanouts = {[];[1,5];[1,5];[1,5];[]};
delays = {[];[1,8];[5,5];[9,1];[]};  
w=3000;
weights = {[];[w,w];[w,w];[w,w];[]};

%% Problem 1: Representing synaptic connectivity and axonal delays: (b) Case 1
numNeurons = 5;
totalTime =5000; 
x = zeros(numNeurons, totalTime);
%initializing cell arrays:
spike_times = cell(numNeurons, 1);
arrival_times = cell(numNeurons, 1);
pre_neuron =  cell(numNeurons, 1);
strengths =  cell(numNeurons, 1);
timeStep = 0.0001;

%Setting up square pulses at layer 1 neurons
x(2,:) = sin(10*[1:1:5000]);
x(3,:) = sin(50*[1:1:5000]);
x(4,:) = sin(100*[1:1:5000]);

[V, spikeFlags]=lif(x,timeStep);
spikeFlags = diff(spikeFlags, 1, 2);
numSpikes = sum(spikeFlags==1,2);

for i=2:4
    spike_times{i}=find(spikeFlags(i, :)==1)+1;
    for t = fanouts{i}
        arrival_times{t}(end+1) = spike_times{i} + delays{i}(fanouts{i}==t);
        pre_neuron{t}(end+1) = i;
        strengths{t}(end+1) = 3000;
    end
end

totalCurrent = synapticCurrent (arrival_times, strengths, totalTime);
x(1:4:5, :) = 1e9*totalCurrent(1:4:5, :);
[V, spikeFlags]=lif(x,timeStep);

%%
%Neural Responses for case one are plotted below:

figure(1);
for pn = 1:5
    subplot(3,2,pn);
    plot(1000*V(pn,1:5000));
    title(strcat('Response of Neuron ',num2str(pn(1,1))));
    xlabel('Time');
    ylabel('Membrane potential (in mV)');
end

% Synaptic Currents for case 1 are plotted below:

figure(2);
for pn = 1:5
    subplot(3,2,pn);
    plot(x(pn,1:5000))
    title(strcat('Total Synaptic Current at Neuron  ', num2str(pn)));
    xlabel('Time');
    ylabel('Current in nA');
end

%% Problem 1: Representing synaptic connectivity and axonal delays: (b) Case 2


numNeurons = 5;
totalTime =5000; 
x = zeros(numNeurons, totalTime);
%initializing cell arrays:
spike_times = cell(numNeurons, 1);
arrival_times = cell(numNeurons, 1);
pre_neuron =  cell(numNeurons, 1);
strengths =  cell(numNeurons, 1);
timeStep = 0.0001;

%Setting up square pulses at layer 1 neurons
x(2, 71:80) = 50;
x(3,31:40) = 50;
x(4, 1:10) = 50;

[V, spikeFlags]=lif(x,timeStep);
spikeFlags = diff(spikeFlags, 1, 2);
numSpikes = sum(spikeFlags==1,2);

for i=2:4
    spike_times{i}=find(spikeFlags(i, :)==1)+1;
    for t = fanouts{i}
        arrival_times{t}(end+1) = spike_times{i} + delays{i}(fanouts{i}==t);
        pre_neuron{t}(end+1) = i;
        strengths{t}(end+1) = 3000;
    end
end

totalCurrent = synapticCurrent (arrival_times, strengths, totalTime);
x(1:4:5, :) = 1e9*totalCurrent(1:4:5, :);
[V, spikeFlags]=lif(x,timeStep);

%%
%Neural Responses for case 2 are plotted below:
figure(3);
for pn = 1:5
    subplot(3,2,pn);
    plot(1000*V(pn,:));
    title(strcat('Response of Neuron ',num2str(pn(1,1))));
    xlabel('Time');
    ylabel('Membrane potential (in mV)');
end

% Synaptic Currents for case 2 are plotted below:

figure(4);
for pn = 1:5
    subplot(3,2,pn);
    plot(x(pn,1:500))
    title(strcat('Total Synaptic Current at Neuron  ', num2str(pn)));
    xlabel('Time');
    ylabel('Current in nA');
end



%% Problem 2: Dynamical Random network

numNeurons = 500;
numExcitatory = 400;
numInhibitory = 100;
numFanout = 50;
spike_times = cell(numNeurons, 1);
arrival_times = cell(numNeurons, 1);
pre_neuron =  cell(numNeurons, 1);
strengths =  cell(numNeurons, 1);



% initializing the fanouts
[fanouts, delays] = createRandomFanouts (numExcitatory, numInhibitory, numFanout);



% first 25  neurons are receving poisson stimulus
stimulus = zeros(25, totalTime);
lambda = 100; 
stimulus = createStimulus( lambda, totalTime, 25 );
% current output from first 25 neurons


for i = 1:25
    for j = 1:totalTime
        if (stimulus(i,j)==1)
            arrival_times{i}(end + 1) = j;
            strengths{i}(end+1) = 3000;
        end
    end
end

% This is really inefficient 

% for i = 1:totalTime  
%     totalCurrent = synapticCurrentA (arrival_times, strengths, i);
%     x = 1e9*totalCurrent;
%     [V, spikeFlags]=lif(x,timeStep);
%     spikeFlags = diff([spikeFlags ones(numNeurons,1)], 1, 2);
%     numSpikes = sum(spikeFlags==1,2);
% 
%     for j=1:numNeurons
%         spike_times{j}=find(spikeFlags(j, :)==1)+1;
%         for k=1:size(fanouts,2)
%             t = fanouts(j,k);
%             arrival_times{t}(end+1) = spike_times{j} + delays(j,k);
%             pre_neuron{t}(end+1) = j;
%             strengths{t}(end+1) = 3000;
%         end
%     end
    
% end
