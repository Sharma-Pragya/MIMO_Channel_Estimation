% -----------------------------------------------------------
% Project 2 Compressive Estimation of Millimeter-Wave Channels
% -----------------------------------------------------------


%% Defining general purpose variables

K                                   % number of subcarriers
Ns                                  % number of data streams
Nt                                  % number of tx antennas
Nr                                  % number of rx antennas
Lt                                  % number of RF chains at tx side
Lr                                  % number of RF chains at rx side


Nc                                  % delay tap length
Ts                                  % sampling period
Pl                                  % path loss b/w tx and rx
L                                   % number of paths




%% System definitions

% Frequency-selective hybrid precoder (F)
% Frf is the analog precoder and Fbb[k] the digital one. 
% The analog precoder is frequency-flat while the digital precoder is different for every subcarrier.

for k = 0:(K-1)
    F(k) = Frf*Fbb(k); 
end

% Discrete-time complex baseband signal at subcarrier k (X(k))
% s(k) is the transmitted symbol sequence at subcarrier k of size Ns×1

for k = 0:(K-1)
    X(k) = F(k)*s(k);
end

% delay tap of the channel (H(d))
% Prc(t) is a filter that includes the effects of pulse-shaping and other lowpass filtering evaluated at t
% alpha(l) is the complex gain of the lth path
% tau(l) is the delay of the lth path
% phi(l) and theta(l) ∈ [0,2π) are the angles-of-arrival and departure of the lth path
% Ar(phi) and At(theta) are the array steering vectors for the rx and tx antennas.

for d = 0:(Nc-1)
    Hd_sum = 0;
    for l = 1:L 
        Hd_sum = Hd_sum + (alpha(l) * Prc((d*Ts)-tau(l)) * Ar(l) * conj(At(l)) );
    end
    Hd(d) = sqrt((Nr*Nt)/(L*Pl)) * Hd_sum;
end

% the channel at subcarrier k can be written in terms of the different delay taps

for k = 0:(K-1)
    Hk_sum = 0;
    for d = 0:(Nc-1)
        Hk_sum = Hk_sum + Hd(d) * exp(-1j*2*pi*k*d/K);
    end
    Hk(k) = Hk_sum;
end

% Hybrid combiner W(k) = Wrf*Wbb(k)

for k = 0:(K-1)
    W(k) = Wrf*Wbb(k);
end

% Noise n(k) is a circularly symmteric complex Gaussian distributed additive noise vector

for k = 0:(K-1)
    n(k)
end

% Received signal at subcarrier k (Y(k))

for k = 0:(K-1)
    Y(k) = (conj(Wbb(k)) * conj(Wrf) * H(k) * Frf * Fbb(k) * s(k)) + (conj(Wbb(k)) * conj(Wrf) * n(k));
end