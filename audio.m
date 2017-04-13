[y, Fs] = audioread('Bass_drum_hit.wav');

new_fs = 350;
b = 1:ceil(Fs/new_fs):size(y,1);
plot(y(b,1));

temp = repmat(y(b,1),16,1);
temp = temp + 0.1;
plot(temp);
%%
I1(1:8001) = temp(1:8001);

soundsc(I1);