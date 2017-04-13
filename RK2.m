function [y] = RK2 (x,h)
numNeurons = size(x, 1);
numTimesteps = size(x,2);

y = -0.070*ones(numNeurons, numTimesteps); %initializing output at steady-state voltage

for i = 1:numTimesteps-1

    y0 = y(:,i);
    
    k1 = -100*y0 -7 + x(:,i)/0.3;
    
    y1 = y0 + h*k1;  %forward Euler approxmation
    
    k2 = -100*y1 -7 + x(:,i+1)/0.3;
    
    y(:,i+1) = y0 + h/2*(k1+k2);  %Runge Kutta order 2 approximation
    
    y(:,i+1) = y(:,i+1).*(y(:,i+1) < 0.020) - 0.07*(y(:,i+1) > 0.020); %resetting voltage and sending out a spike at V_{thresh}
        
end