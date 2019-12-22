function [fq, PS] = calcFftPS(signal, Fs)
% Calculate FFT and return power spectra
%
% [fq, PS] = calcFft(signal, Fs)
%         Calculate the fft and power spectra like we've seen in the class
%         exercise.

    % FFt&PS calculations
    L = length(signal);
    Amp = abs(fft(signal));
    PS = Amp .^ 2;
    PS = [PS(1) 2*PS(2:floor(L/2))];
    fq = (1:floor(L/2))*Fs/L;
    
end

