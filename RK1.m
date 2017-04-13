function [V,U] = RK1 (x,h,neuronType)
numNeurons = size(x, 1);
numTimesteps = size(x,2);
switch neuronType 
    case 'RS'   
        C = 10^-12*200;
        g_l = 10^-9*10;
        E_l = 10^-3*-70;
        V_t = 10^-3*-50;
        del_t = 10^-3*2;
        a = 10^-9*2;
        tau_w = 10^-3*30;
        b = 10^-12*0;
        V_r = 10^-3*-58;
        
        Vss = -44.5 * 10^-3;
        Uss = 50.9 * 10^-12;


    case 'IB'
        C = 10^-12*130;
        g_l = 10^-9*18;
        E_l = 10^-3*-58;
        V_t = 10^-3*-50;
        del_t = 10^-3*2;
        a = 10^-9*4;
        tau_w = 10^-3*150;
        b = 10^-12*120;
        V_r = 10^-3*-50;
        
        Vss = -46 * 10^-3;
        Uss = 47.9 * 10^-12;

    case 'CH'
        C = 10^-12*200;
        g_l = 10^-9*10;
        E_l = 10^-3*-58;
        V_t = 10^-3*-50;
        del_t = 10^-3*2;
        a = 10^-9*2;
        tau_w = 10^-3*120;
        b = 10^-12*100;
        V_r = 10^-3*-46;  
        
        Vss = -46.1 * 10^-3;
        Uss = 23.9 * 10^-12;
        
end

V = Vss*ones(numNeurons, numTimesteps);
U = Uss*ones(numNeurons, numTimesteps);

for i = 1:numTimesteps-1

    V0 = V(:,i);
    U0 = U(:,i); 
    
    k = (-g_l*(V0 - E_l) + g_l*del_t*exp((V0-V_t)/del_t) - U0 + x(:,i+1))/C;
    l = (a*(V0 - E_l) - U0)/tau_w;
    
    V(:, i+1) = V0 + h*k;
    U(:, i+1) = U0 + h*l;
    
   V(:,i+1) = V(:,i+1).*(V(:,i+1) < 0) + V_r*(V(:,i+1) > 0); %resetting voltage and sending out a spike at V_{thresh}
   U(:, i+1) = U(:, i+1) + b*(V(:,i+1) > 0);
end