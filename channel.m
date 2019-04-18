function [receivedSignalG, receivedSignal] = channel(transmittedSignalG, transmittedSignal, snr)    
    receivedSignalG = awgn(transmittedSignalG, snr, 'measured');
    
    receivedSignal = awgn(transmittedSignal, snr, 'measured');
end

