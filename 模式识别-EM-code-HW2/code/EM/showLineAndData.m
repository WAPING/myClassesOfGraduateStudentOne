function showLineAndData(data, para, prob, str, frmNo, hf)

if nargin < 5
    hf = [];
end

x = data(:,1);
y = data(:,2);

if isempty(hf)
    figure;
else
    figure(hf);
    clf;
end
    
hold on;

if isempty(prob)
    plot(x, y, 'k.');
else
    colorVec = jet;
    numColor = size(jet, 1);
    idx = round(prob*numColor);
    idx = max(1, min(numColor, idx));
    scatter(x, y, 2, colorVec(idx, :));
end

numLine = size(para, 1);

lineColor = 'rbgkcm';

for iLine = 1:numLine
    a = para(iLine, 1);
    b = para(iLine, 2);
    c = para(iLine, 3);
    % a*x + b*y + c = 0

    if abs(b) > abs(a)
        x0 = min(x);
        x1 = max(x);

        y0 = -(a*x0+c)/b;
        y1 = -(a*x1+c)/b;
    else
        y0 = min(y);
        y1 = max(y);

        x0 = -(b*y0+c)/a;
        x1 = -(b*y1+c)/a;
    end

    plot([x0,x1], [y0,y1], lineColor(iLine), 'LineWidth', 2);
end
% axis equal

xlim([min(x), max(x)]);
ylim([min(y), max(y)]);

title(str);
print(sprintf('%02d.jpg', frmNo), '-djpeg','-r60');

