rng default
nominalFs = 48000;
f = 500;
Tx = 0:1/nominalFs:0.01;
irregTx = sort(Tx + 1e-4*rand(size(Tx)));
x = sin(2*pi*f*irregTx);
plot(irregTx,x,'.')
hold on

desiredFs = 44100;
[y, Ty] = resample(x,irregTx,desiredFs);
% x: the samples, that were sampled irregularly
% irregTx: the times the samples were taken
% desiredFs


plot(irregTx,x,'.-', Ty,y,'o-')



legend('Original','Resampled')
ylim([-1.2 1.2])