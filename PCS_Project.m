clear,clc

file = 'student.jpg';

transmittedImage = imread(file);

M = [4 16 64];

for i=1:length(M)
    [transmittedSignalG, transmittedSignal, dataIn] = transmitter(file, M(i));

    snr = 20;

    [receivedSignalG, receivedSignal]  = channel(transmittedSignalG, transmittedSignal, snr);
   
    sPlotFig = scatterplot(receivedSignalG,1,0,'g.');
    hold on
    scatterplot(transmittedSignalG,1,0,'k*',sPlotFig);
    title(['Scatter Plot Using ', num2str(M(i)), '-QAM & SNR = 20dB']);
    
    figure(i+3)
    
    subplot(1,2,1),  imshow(transmittedImage);
    title('Transmitted Image')
    subplot(1,2,2), [receivedImage, dataOutG, dataOut] = receiver(receivedSignalG, receivedSignal, M(i), 1);
    title(['Received Image Using ', num2str(M(i)), '-QAM & SNR = 20dB']);

    numberOfErrorsG = 0;
    
    for n=1:length(dataIn)
        if dataIn(n) - dataOutG(n) ~= 0
            numberOfErrorsG = numberOfErrorsG + 1;
        end
    end
    
    poeG = numberOfErrorsG/length(dataIn);
    
    fprintf('\nThe Gray coding bit error rate = %5.2e, based on %d errors for M = %d & SNR = 20dB\n', ...
    poeG,numberOfErrorsG,M(i));

    numberOfErrors = 0;

    for n=1:length(dataIn)
        if dataIn(n) - dataOut(n) ~= 0
            numberOfErrors = numberOfErrors + 1;
        end
    end
    
    poe = numberOfErrors/length(dataIn);
    
    fprintf('\nThe binary coding bit error rate = %5.2e, based on %d errors for M = %d & SNR = 20dB\n', ...
        poe,numberOfErrors,M(i));
    
    k = log2(M(i));
    
    EbNo20dB = snr - 10*log10(k);
        
    EbNo20 = 10^(EbNo20dB/10);
        
    PsqrtMBitError20 = 2*(1 - 1/sqrt(M(i)))*qfunc(sqrt(3*k*EbNo20/(M(i) - 1)));
       
    PMBitError20 = (1 - (1 - PsqrtMBitError20)^2)/k;
    
    fprintf('\nThe theoretical binary coding bit error rate = %5.2e, for M = %d & SNR = 20dB\n', ...
        PMBitError20,M(i));
    
    fprintf('\n');
    
    snr = -6:0.5:12;
    
    poeG_Values = zeros(1,length(snr));
    poe_Values = zeros(1,length(snr));
    
    for r=1:length(snr)
        [receivedSignalG, receivedSignal] = channel(transmittedSignalG, transmittedSignal, snr(r));
        
        [receivedImage, dataOutG, dataOut] = receiver(receivedSignalG, receivedSignal, M(i), 0);
        
        numberOfErrorsG = 0;
    
        for n=1:length(dataIn)
            if dataIn(n) - dataOutG(n) ~= 0
                numberOfErrorsG = numberOfErrorsG + 1;
            end
        end
    
        poeG = numberOfErrorsG/length(dataIn);
        
        numberOfErrors = 0;

        for n=1:length(dataIn)
            if dataIn(n) - dataOut(n) ~= 0
                numberOfErrors = numberOfErrors + 1;
            end
        end
    
        poe = numberOfErrors/length(dataIn);
          
        poeG_Values(r) = poeG;
        
        poe_Values(r) = poe;
    end
    
    PMBitError = zeros(1,length(snr));
    
    for l=1:length(snr)
        EbNodB = snr(l) - 10*log10(k);
        
        EbNo = 10^(EbNodB/10);
        
        PsqrtMBitError = 2*(1 - 1/sqrt(M(i)))*qfunc(sqrt(3*k*EbNo/(M(i) - 1)));
        
        PMBitError(l) = (1 - (1 - PsqrtMBitError)^2)/k;
    end
    
    PMSymbolError = zeros(1,length(snr));
    
    for l=1:length(snr)
        EbNodB = snr(l) - 10*log10(k);
        
        EbNo = 10^(EbNodB/10);
        
        PsqrtMSymbolError = 2*(1 - 1/sqrt(M(i)))*qfunc(sqrt(3*k*EbNo/(M(i) - 1)));
       
        PMSymbolError(l) = 1 - (1 - PsqrtMSymbolError)^2;
    end
    
    figure(i+6)
    
    semilogy(snr, poeG_Values, 'b', snr, PMBitError, 'r', snr, PMSymbolError, 'g');
    
    grid on
    ax = gca;
    ax.GridLineStyle = ':';
    
    xlim([-6 12]);
    xticks([-6:2:12]);
    
    title(['Probability of Error vs. SNR Curve for M = ', num2str(M(i)), ' Using Gray Mapping']);
    xlabel('SNR');
    ylabel('Probability of Error');
    legend({'Computed Probability of Error', 'Theorectical Probaility of Bit Error ', 'Theorectical Probability of a Symbol Error'}, 'Location', 'south');
    
    figure(i+9)
  
    semilogy(snr, poe_Values, 'b', snr, PMBitError, 'r', snr, PMSymbolError, 'g');
    
    grid on
    ax = gca;
    ax.GridLineStyle = ':';
    
    xlim([-6 12]);
    xticks([-6:2:12]);
    
    title(['Probability vs. SNR Curve for M = ', num2str(M(i)), ' Without Using Gray Mapping']);
    xlabel('SNR');
    ylabel('Probability of Error');
    legend({'Computed Probability of Error', 'Theorectical Probaility of Bit Error ', 'Theorectical Probability of a Symbol Error'}, 'Location', 'south');
end