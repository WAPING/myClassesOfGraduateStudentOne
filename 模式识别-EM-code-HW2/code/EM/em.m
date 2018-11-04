load data;
x = data(:,1);
y = data(:,2);

numData = length(x);

%% for EM initialization

% first, estimate one line from all the data
A = [x, y, ones(numData, 1)];
[u, d, v] = svd(A);
para = v(:, 3)';

% then, intialize the parameters of two lines by adding some noises
para1 = para+rand(1,3);
para1 = para1/norm(para1(1:2));

para2 = para+rand(1,3);
para2 = para2/norm(para2(1:2));

hf = figure;
pause;
sigma = 5*5;

%% EM iteration
for iter = 0:20
    % E Step
    
    % for each point, calculate its probability belonging to two lines
    lineDist1 = abs(para1(1)*x + para1(2)*y + para1(3));
    lineDist2 = abs(para2(1)*x + para2(2)*y + para2(3));
    
    lineProb1 = exp(-lineDist1.^2/sigma);
    lineProb2 = exp(-lineDist2.^2/sigma);
    psum = lineProb1 + lineProb2;
    lineProb1 = lineProb1./psum;
    lineProb2 = lineProb2./psum;
    
    % visualize the results
    if iter == 0
        showLineAndData(data, [para1; para2], lineProb1, 'Init', 0, hf);
    else
        showLineAndData(data, [para1; para2], lineProb1, ['Iter: ' num2str(iter)], iter, hf);        
    end
    drawnow;
    pause(0.1);

    % M step, estimate the parameters of each line
    A = [lineProb1.*x, lineProb1.*y, lineProb1.*ones(numData, 1)];
    [u, d, v] = svd(A);
    para1 = v(:, 3)';
    para1 = para1/norm(para1(1:2));
    
    A = [lineProb2.*x, lineProb2.*y, lineProb2.*ones(numData, 1)];
    [u, d, v] = svd(A);
    para2 = v(:, 3)';
    para2 = para2/norm(para2(1:2));
end