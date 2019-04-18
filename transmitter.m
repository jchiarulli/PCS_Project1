function [dataModG, dataMod, dataIn] = transmitter(filename, M_level)
    Image = imread(filename);
    
    ImageVector = Image(:);

    ImageBits = de2bi(ImageVector);

    dataIn = reshape(ImageBits',[],1);
    
    dataIn = double(dataIn);
    
    M = M_level; % Size of signal constellation
    k = log2(M); % Number of bits per symbol

    dataInMatrix = reshape(dataIn,length(dataIn)/k,k); % Reshape data into binary k-tuples, k = log2(M)
    dataSymbolsIn = bi2de(dataInMatrix); % Convert to integers

    dataModG = qammod(dataSymbolsIn,M); % Gray coding, phase offset = 0

    dataMod = qammod(dataSymbolsIn,M,'bin'); % Binary coding, phase offset = 0
end
