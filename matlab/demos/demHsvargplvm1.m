% Simple script with random data, mostly to do gradchek and test
% development
rand('seed', 1e5)
randn('seed', 1e5);

addpath(genpath('../'));

%clear

N = 10;
D1 = 4;
D2 = 5;

Ytr{1} = rand(N,D1);
Ytr{2} = rand(N,D2);
Q = 2;
K = 3;

baseKern = {'linard2','white','bias'};
%baseKern = 'rbfardjit';

hsvargplvm_init;
options = hsvargplvmOptions(globalOpt);
options.optimiser = 'scg2';

if globalOpt.multOutput
    Ynew = [Ytr{1} Ytr{2}];
    Ytr = cell(1,size(Ynew,2));
    for i=1:size(Ynew,2)
        Ytr{i} = Ynew(:,i);
    end
end

model = hsvargplvmModelCreate(Ytr, options, globalOpt);

params = hsvargplvmExtractParam(model);
model = hsvargplvmExpandParam(model, params);
modelInit = model;


if exist('skipGradchek') && skipGradchek
    model = hsvargplvmOptimise(model, true, 20);
else
    model = hsvargplvmOptimise(model, true, 20, 'gradcheck', true);
end
