function [V,U] = RK4 (x,h, neuronType)
numNeurons = size(x, 1);
numTimesteps = size(x,2);

switch neuronType 
    case 'RS'   
        C = 10^-12*100;
        k_z = 10^-6*0.7;
        E_r = 10^-3*-60;
        E_t = 10^-3*-40;
        a = 10^3*0.03;
        b = 10^-9*-2;
        c = 10^-3*-50;
        d = 10^-12*100;
        v_peak = 10^-3*35;

    case 'IB'
        C = 10^-12*150;
        k_z = 10^-6*1.2;
        E_r = 10^-3*-75;
        E_t = 10^-3*-45;
        a = 10^3*0.01;
        b = 10^-9*5;
        c = 10^-3*-56;
        d = 10^-12*130;
        v_peak = 10^-3*50;
    case 'CH'
        C = 10^-12*50;
        k_z = 10^-6*1.5;
        E_r = 10^-3*-60;
        E_t = 10^-3*-40;
        a = 10^3*0.03;
        b = 10^-9*1;
        c = 10^-3*-40;
        d = 10^-12*150;
        v_peak = 10^-3*25;
end

V = (E_t + b/k_z) * ones(numNeurons, numTimesteps);
U = b*(V - E_r);

for i = 1:numTimesteps-1
    
    V0 = V(:,i);
    U0 = U(:,i);
    
    k1 = 1/C*(k_z*(V0-E_r).*(V0 - E_t) - U0 + x(:,i));
    l1 = a*(b*(V0 - E_r) - U0);
    
    V1 = V0 + 0.5*h*k1;
    U1 = U0 + 0.5*h*l1;
    
    k2 = 1/C*(k_z*(V1-E_r).*(V1 - E_t) - U1 + x(:,i));
    l2 = a*(b*(V1 - E_r) - U1);
    
    V2 = V0 + 0.5*h*k2;
    U2 = U0 + 0.5*h*l2;
    
    k3 = 1/C*(k_z*(V2-E_r).*(V2 - E_t) - U2 + x(:,i));
    l3 = a*(b*(V2 - E_r) - U2);
    
    V3 = V0 + h*k3;
    U3 = U0 + h*l3;
        
    k4 = 1/C*(k_z*(V3-E_r).*(V3 - E_t) - U3 + x(:,i));
    l4 = a*(b*(V3 - E_r) - U3);
    
    V(:,i+1) = V0 + h/6 * (k1 + 2*k2 + 2*k3 + k4);
    U(:,i+1) = U0 + h/6 * (l1 + 2*l2 + 2*l3 + l4);
    
    V(:,i+1) = V(:,i+1).*(V(:,i+1) < v_peak) + c*(V(:,i+1) > v_peak);
    U(:,i+1) = U(:,i+1) + d*(V(:,i+1) > v_peak);
end