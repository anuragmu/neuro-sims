%% =================
tmstp = datestr(now,'dd-mmm-yyyy HH_MM AM');% time stamp to save file


t = 0:0.01:80;
%I1 = 2*ones(size(t)).*(heaviside(t-10)-heaviside(t-15));
%I1 = 2*sin(1.4*t-1)+0.5;
% I1 = 2*(square(01*t-2)+0.5);

[y, Fs] = audioread('Bass_drum_hit.wav');

new_fs = 300;
b = 1:ceil(Fs/new_fs):size(y,1);
temp = repmat(y(b,1),64,1);
temp = temp + 0.1;
I1(1:8001) = temp(1:8001);

 I = awgn(10*I1, 100);
%I = awgn(ones(8001,1), 10);

%x =  -0.9894*ones(size(t));
x1 =  1.5553*ones(size(t));
y1 =   -3.4322*ones(size(x1));
% x2 =  -1.4201*ones(size(t));
% y2 =  -3.4834*ones(size(x2));
x2 =  1.5553*ones(size(t));
y2 =   -3.4322*ones(size(x1));

alpha1 = 4.9;% >4 will give u burst of spikes
alpha2 = 5;
mu = 0.001;
%============== select here
% g = 0 % for unsynchronized response
g = 0.029*20; % anti phase sync
% g = 0.046; % in phase sync

%=============================
g12 = 1*g;
g21 = 1*g;

Be = 1;
Se = 1;
Beta1 = ones(size(t));
sig1 = ones(size(t));

Beta2 = ones(size(t));
sig2 = ones(size(t));


for n = 1:length(t)-1
    
    Beta1(n) = g21*Be*(x2(n)-x1(n))*I(n);
    sig1(n) = g21*Se*(x2(n)-x1(n))*I(n);
    
    Beta2(n) = g12*Be*(x1(n)-x2(n));
    sig2(n) = g12*Se*(x1(n)-x2(n));
    
    x1(n+1) = (alpha1/(1-x1(n))+y1(n)+Beta1(n))*(x1(n)<=0)+...
        (alpha1+y1(n)+Beta1(n))*(x1(n)>0 & x1(n)< (alpha1+y1(n)+Beta1(n)))+...
        -1*(x1(n)>=(alpha1+y1(n)+Beta1(n)));
    
    y1(n+1) = y1(n) - mu*(x1(n)+1) + mu*sig1(n);
    
    
    x2(n+1) = (alpha2/(1-x2(n))+y2(n)+Beta2(n))*(x2(n)<=0)+...
        (alpha2+y2(n)+Beta2(n))*(x2(n)>0 & x2(n)< (alpha2+y2(n)+Beta2(n)))+...
        -1*(x2(n)>=(alpha2+y2(n)+Beta2(n)));
    
    y2(n+1) = y2(n) - mu*(x2(n)+1) + mu*sig2(n);
end

figure(1)
subplot(311);plot(t,x1(1:end),'b',t,x2(1:end),'r');
subplot(312);plot(t,x1(1:end),'b',t,I(1:end),'r');
subplot(313);plot(t,I(1:end),'r',t,x2(1:end),'b');
% xlim([-3 3])
 ylim([-5 5])



print(gcf, '-dpng',['fig_' tmstp] );

% figure(2)
% subplot(311);plot(t,y1(1:end),'b',t,y2(1:end),'r');
% subplot(312);plot(t,y1(1:end),'b');
% subplot(313);plot(t,y2(1:end),'r');


%%===================================