sx = 100;
sy = 50;
xVec = -sx:5:sx;
yVec = -sy:sy;
numLine =2;
sigma = 10*rand(1)+1;
numPert =10;
noise = 0;
noiseLevel = 0.01;

figure;
subplot(121);
hold on;
cVec = 'gbkmyc';

linePara = zeros(numLine, 3);
data = [];
pt1 = [(rand(1)-0.5)*sx, (rand(1)-0.5)*sy];
for i = 1:numLine
    pt2 = [(rand(1)-0.5)*sx, (rand(1)-0.5)*sy];    
    LPT = [pt1; pt2];
    coeff = pca(LPT, 'Economy', false);
    normal = coeff(:,2);
    p = [normal(1), normal(2), -mean(LPT,1)*normal];
    
    linePara(i, :) = p;
    if p(1) > p(2)
        xx = -(yVec*p(2) + p(3))/p(1);
        yy = yVec;
    else
        xx = xVec;
        yy = -(xVec*p(1) + p(3))/p(2);
    end
    numPt = length(xx);
    dxx = repmat(xx, numPert, 1) + randn(numPert, numPt);
    dyy = repmat(yy, numPert, 1) + randn(numPert, numPt);
    dpt = [dxx(:), dyy(:)];    
    data = [data; dpt];
    
    plot(dpt(:,1), dpt(:,2), ['.' cVec(mod(i-1, length(cVec))+1)]);
    plot(xx, yy, 'r', 'lineWidth', 2);
    pt1 = pt2;
end

if noise
    m = round(size(data, 1)*noiseLevel) + 1;
    nPt = [(rand(m, 1)-0.5)*sx*2, (rand(m, 1)-0.5)*sy*2];
    for i = 1:numLine
        m = size(nPt, 1);
        dist = abs(sum(repmat(linePara(i,1:2), m, 1).*nPt,2) + repmat(linePara(i,3), m, 1));
        nPt(dist < sigma, :) = [];
    end    
    plot(nPt(:,1), nPt(:,2), '+r');    
    data = [data; nPt];
end
axis equal;

subplot(122);
hold on;
plot(data(:,1), data(:,2), 'r.');
axis equal;
