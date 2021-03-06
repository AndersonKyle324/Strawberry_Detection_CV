numPics = 4;
i=4;
imRGB = imread("Resized/t" + i + ".jpg");
figure(1);
imshow(imRGB);

im = rgb2hsv(imRGB);

k=3;
[m,n] = size(im(:,:,1));
x = reshape(im, m*n, 3);

% Use for kmeans
% xClustered = kmeans(double(x), k);
% imSegmented = reshape(xClustered, m, n);

% Use for EM
xDist = fitgmdist(double(x),k);
xClustered = cluster(xDist,double(x));
imSegmented = reshape(xClustered, m,n);

figure(2);
imshow(imSegmented, []);

sbK = findsbK(im, imSegmented, k);  %finds value of K that corresponds to strawberries

if(size(sbK,2) > 0)
    kIm = imSegmented == sbK(1); %Use mask on im to get rid of other k vals

    groups = bwconncomp(kIm); 	% connects groups of 1’s
    numGroups = groups.NumObjects; % number of unique groupings
    labelMat = labelmatrix(groups); 	% Labels groups of 1’s
    separateSBGroups = label2rgb(labelMat);	% converts groups to rgb arrays
    
    figure(3);
    imshow(separateSBGroups);
    
    maxArea = 8000;
    minArea = 600;
    numSBs = 0;
    
    sbValues = [];
    
    figure(1);
    for i=1:numGroups
        area = sum(labelMat(:) == i);
        disp("area:"+area);
        if(area > minArea  && area < maxArea)
            [x, y] = find(labelMat == i, 1);
            
            rectangle('Position', [y, x, sqrt(area), sqrt(area)], 'EdgeColor', 'w'); 
            disp("SB " + (i) + " x,y:" + x + ","+ y + " Area:" + area)
            
            sbValues = [sbValues i-1];
            numSBs = numSBs + 1;
        end
    end
    disp("Num berries found:" + numSBs)
   
else
    disp("No berries found")
end

function sbK = findsbK(im, imSegmented, k)
    sbK = [];

    hueIm = im(:,:,1);
    satIm = im(:,:,2);
    valIm = im(:,:,3);

    for i=1:k
        %mask ea HSV val
        hueSeg = hueIm(imSegmented == i);
        satSeg = satIm(imSegmented == i);
        valSeg = valIm(imSegmented == i);

        %Find avg RGB values for this val of k
        hueMean = mean(hueSeg, 'all');
        satMean = mean(satSeg, 'all');
        valMean = mean(valSeg, 'all');
        disp("Vals within " + " R:" + hueMean ...
            + " G:" + satMean + " B:" + valMean);

        %compare w/ HSV values found from part A
        if((hueMean < .16 || hueMean > .95)...
            && satMean > .4 ...
            && valMean > .6)
            %this k val is a strawberry
%             disp("GOOD " + thresh(:) + " R:" + redMean + " G:" + greenMean + " B:" + blueMean);
            sbK = [sbK; k];
        end
    end
end