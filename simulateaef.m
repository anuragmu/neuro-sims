function [xa,V]=simulateaef(Iapp,T,dt,type)
N=size(Iapp,1);
vpeak=0;
iter=T/dt;

if type==1
    st='RS';
    C=200e-12;
    gL=10e-9;
    EL=-70e-3;
    Vt=-50e-3;
    Dt=2e-3;
    a=2e-9;
    tauw=30e-3;
    b= 0 ;
    Vr=-58e-3;
    Vi = -69.9999e-3;
    Ui = 1.5102e-10;
    
elseif type==2
    st='IB';
    C=130e-12;
    gL=18e-9;
    EL=-58e-3;
    Vt=-50e-3;
    Dt=2e-3;
    a=4e-9;
    tauw=150e-3;
    b= 120e-12 ;
    Vr=-50e-3;
        
    Vi = -57.9696e-3;
    Ui = 0.1217e-7;
else
    st='CH';
    C=200e-12;
    gL=10e-9;
    EL=-58e-3;
    Vt=-50e-3;
    Dt=2e-3;
    a=2e-9;
    tauw=120e-3;
    b= 100e-12 ;
    Vr=-46e-3;
    Vi = -57.9690e-3;
    Ui = 0.0620e-7;
end

V=Vi*ones(N,iter);
U=Ui*ones(N,iter);

xa(1)=0;
j=1;


while max(xa)< T-dt
    V(:,j+1)=V(:,j)+ (dt/C)* (Iapp(:,j) + (gL*Dt*exp((V(:,j)-Vt)/Dt)) - (gL*(V(:,j)-EL)) - U(:,j));
    U(:,j+1)=U(:,j)+ (dt/tauw )* (-U(:,j) + (a*(V(:,j)-EL)));
    spind=sign(V(:,j+1)-vpeak);
    if max(spind)>0
        ind=find(spind>0); %indices of neuron that just spiked
        V(ind,j)=vpeak;
        V(ind,j+1)=Vr;
        U(ind,j+1)=U(ind,j)+b;
    end
    xa(j+1)=xa(j)+dt;
    j=j+1;
end



%c='rgb';
%h=figure('Position',[100 100 820 700]);
% 
% for k=1:N
%     subplot(N,1,k)
%     set(gca,'fontsize',16)
%     plot(xa(1:j),(V(k,1:j)),c(k),'linewidth',2)
%     text(5.5,-90,['I_{app}= ',num2str((Iapp(k))),' pA'])
%     axis([0 500 -100 50])
%     if k==2
%         ylabel(['Membrane Potential (mV) for Neuron ',st])
%     end
%     grid
% end

%xlabel('Time (ms)')