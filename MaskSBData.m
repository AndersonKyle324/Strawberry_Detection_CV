numPics = 20;

%resize and save images
% smallestImArea = 50246;
% for i=1:numPics
%     imName = "Multiple/t" + i + ".JPG";
%     im = imread(imName);
%     [x,y,z] = size(im);
%     scale = sqrt(smallestImArea / (x*y));
%     resizedIm = imresize(im, scale);
% 
%     imwrite(resizedIm, "Resized/t" + i + ".JPG");
% end

%create and save masks for resized images
% for i=8:numPics
%     imName = "Resized/s" + i + ".JPG";
%     im = imread(imName);
%     sbMask = roipoly(im);
%     sbMask = mat2gray(sbMask);
%     
%     imwrite(sbMask, "Masks/mask" + i + ".jpg");
% end

totalSBF1 = [];
totalSBF2 = [];
totalSBF3 = [];
totalNonSBF1 = [];
totalNonSBF2 = [];
totalNonSBF3 = [];

% F1 = "Red";
% F2 = "Green";
% F3 = "Blue";

F1 = "Hue";
F2 = "Saturation";
F3 = "Value";
sbAreaTotal = 0;

for i=1:numPics
    im = imread("Resized/s" + i + ".JPG");
    mask = imread("Masks/mask" + i + ".jpg");
    
    %use hsv color space
    im = rgb2hsv(im);
    
    %separate color fields for RGB
    imF1 = im(:,:,1);
    imF2 = im(:,:,2);
    imF3 = im(:,:,3);
    
    %Use Normalized RGB color space
%     normIm = size(im);
%     for j = size(im, 1)
%         for k = size(im, 2)
%             rgbSum = sum(im(j,k));
%             normIm(j,k,1) = imF1(j,k) / rgbSum;
%             normIm(j,k,2) = imF2(j,k) / rgbSum;
%             normIm(j,k,3) = imF3(k,k) / rgbSum;
%         end
%     end
    
%     imshow(normIm, []);
    
    %get im color values within SB mask for each field
    sbF1 = imF1(mask == 255);
    sbF2 = imF2(mask == 255);
    sbF3 = imF3(mask == 255);
    
    sbArea = size(sbF1, 1);
    sbAreaTotal = sbAreaTotal + sbArea;
    
    %get im color values outside of SB mask for each field
    nonSBF1 = imF1(mask == 0);
    nonSBF2 = imF2(mask == 0);
    nonSBF3 = imF3(mask == 0);
    
    %add RGB values for this image to the total for all images
    totalSBF1 = [totalSBF1; sbF1];
    totalSBF2 = [totalSBF2; sbF2];
    totalSBF3 = [totalSBF3; sbF3];
    
    totalNonSBF1 = [totalNonSBF1; nonSBF1];
    totalNonSBF2 = [totalNonSBF2; nonSBF2];
    totalNonSBF3 = [totalNonSBF3; nonSBF3];
end

subplot(6,1,1), imhist(totalSBF1); title("SB " + F1);
subplot(6,1,2), imhist(totalNonSBF1); title("Non " + F1);
subplot(6,1,3), imhist(totalSBF2); title("SB " + F2);
subplot(6,1,4), imhist(totalNonSBF2); title("Non " + F2);
subplot(6,1,5), imhist(totalSBF3); title("SB " + F3);
subplot(6,1,6), imhist(totalNonSBF3); title("Non " + F3);

avgSBArea = sbAreaTotal / numPics

avgSBF1 = mean(totalSBF1, 'all')
avgSBF2 = mean(totalSBF2, 'all')
avgSBF3 = mean(totalSBF3, 'all')

avgNonSBF1 = mean(totalNonSBF1, 'all')
avgNonSBF2 = mean(totalNonSBF2, 'all')
avgNonSBF3 = mean(totalNonSBF3, 'all')
