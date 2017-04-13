function [ b ] = expTransform( tm, totalTime )

tau = 150;
taus = tau/4;

    a = 1:totalTime;
    a = tm*ones(1, totalTime) - a;
    b = (a<0).*(exp(a/tau) - exp(a/taus));

end

