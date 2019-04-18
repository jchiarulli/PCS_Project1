function [receivedImage, dataOutG, dataOut] = receiver(receivedSignalG, receivedSignal, M_level, displayImage)
    M = M_level;
    k = log2(M);
    
    dataSymbolsOutG = qamdemod(receivedSignalG,M);
    
    dataSymbolsOut = qamdemod(receivedSignal,M,'bin');
    
    dataOutMatrixG = de2bi(dataSymbolsOutG,k);
    dataOutG = dataOutMatrixG(:);
    
    dataOutMatrix = de2bi(dataSymbolsOut,k);
    dataOut = dataOutMatrix(:);
    
    if displayImage == 1
        receivedImageBinaryMatrix = vec2mat(dataOutG,8);
    
        receivedImageDecimalNumbers = bi2de(receivedImageBinaryMatrix);
        receivedImageArray = reshape(receivedImageDecimalNumbers,180,180,3);
        receivedImage_uint8 = uint8(receivedImageArray);
    
        imwrite(receivedImage_uint8, 'Reconstructed_student.jpg');
        receivedImage = imshow(imread('Reconstructed_student.jpg'));
    else
        receivedImage = 0;
    end
end

