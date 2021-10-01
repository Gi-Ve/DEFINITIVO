function [outputArg1] = OptimizationPoly(momH,momHAbb,momK,momA)
%OPTIMIZATION POLYNOMIAL CRITERIA LOWER LIMB


%%%% data loading: moment arms and joint moments %%%%

if 0 == 0
%================ hip flexion/extension ======================
valorimhipflex = momH;
newX = (0:0.02:1)';
newY = interp1((0:0.01:1),valorimhipflex,newX);
valorimhipflex = table(newX,newY);

valoribraccioRFhflex = readtable('valori_braccio_RFfl_hip.csv');
valoribraccioILhflex = readtable('valori_braccio_ILfl_hip.csv');
valoribraccioGMAXhflex = readtable('valori_braccio_GMAXfl_hip.csv');
valoribraccioPShflex = readtable('valori_braccio_PSfl_hip.csv');
valoribraccioSMhflex = readtable('valori_braccio_SMfl_hip.csv');
valoribraccioADDBhflex = readtable('valori_braccio_ADDBfl_hip.csv');
valoribraccioADDGhflex = readtable('valori_braccio_ADDGfl_hip.csv');
valoribraccioADDLhflex = readtable('valori_braccio_ADDLfl_hip.csv');
valoribraccioBFCLhflex = readtable('valori_braccio_BFCLfl_hip.csv');
valoribraccioGPIChflex = readtable('valori_braccio_GPICfl_hip.csv');

%%============== ankle flexion/extension =======================
valorimankleflex = momHAbb;
newX = (0:0.02:1)';
newY = interp1((0:0.01:1),valorimankleflex,newX);
valorimankleflex = table(newX,newY);

valoribraccioGASaflex = readtable('valori_braccio_GASfl_ankle.csv');
valoribraccioSOaflex = readtable('valori_braccio_SOfl_ankle.csv');
valoribraccioTAaflex = readtable('valori_braccio_TAfl_ankle.csv');
valoribraccioPEaflex = readtable('valori_braccio_PEfl_ankle.csv');

%============ knee flexion/extension ======================
valorimkneeflex = momK;
newX = (0:0.02:1)';
newY = interp1((0:0.01:1),valorimkneeflex,newX);
valorimkneeflex = table(newX,newY);

valoribraccioRFkflex = readtable('valori_braccio_RFfl_knee.csv');
valoribraccioGASkflex = readtable('valori_braccio_GASfl_knee.csv');
valoribraccioBFCBkflex = readtable('valori_braccio_BFCBfl_knee.csv');
valoribraccioBFCLkflex = readtable('valori_braccio_BFCLfl_knee.csv');
valoribraccioSMkflex = readtable('valori_braccio_SMfl_knee.csv');
valoribraccioVMkflex = readtable('valori_braccio_VMfl_knee.csv');
valoribraccioVIkflex = readtable('valori_braccio_VIfl_knee.csv');
valoribraccioVLkflex = readtable('valori_braccio_VLfl_knee.csv');


%================= hip abduction/adduction =========================
valorimhipadd = momA;
newX = (0:0.02:1)';
newY = interp1((0:0.01:1),valorimhipadd,newX);
valorimhipadd = table(newX,newY);

valoribraccioRFhadd = readtable('valori_braccio_RFad_hip.csv');
valoribraccioGMAXhadd = readtable('valori_braccio_GMAXad_hip.csv');
valoribraccioPShadd = readtable('valori_braccio_PSad_hip.csv');
valoribraccioSMhadd = readtable('valori_braccio_SMad_hip.csv');
valoribraccioADDBhadd = readtable('valori_braccio_ADDBad_hip.csv');
valoribraccioADDGhadd = readtable('valori_braccio_ADDGad_hip.csv');
valoribraccioADDLhadd = readtable('valori_braccio_ADDLad_hip.csv');
valoribraccioBFCLhadd = readtable('valori_braccio_BFCLad_hip.csv');
valoribraccioGMEDahadd = readtable('valori_braccio_GMEDaad_hip.csv');
valoribraccioGMEDphadd = readtable('valori_braccio_GMEDpad_hip.csv');
valoribraccioGPIChadd = readtable('valori_braccio_GPICad_hip.csv');
end


%==============function fminimax variables setting===============

if 0 == 0
% linear inequality constraints matrix - it contains 1/N for each muscle,
% where N stays for PCSA that is scaled based on subject mass
A = [(1/42.96),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0,(1/23.33),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0,0,(1/20.20),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0,0,0,(1/25.70),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0,0,0,0,(1/46.33),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0,0,0,0,0,(1/11.52),0,0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0,0,0,0,0,0,(1/18.35),0,0,0,0,0,0,0,0,0,0,0,0,0;...
    0,0,0,0,0,0,0,(1/22.73),0,0,0,0,0,0,0,0,0,0,0,0;...
    0,0,0,0,0,0,0,0,(1/27.34),0,0,0,0,0,0,0,0,0,0,0;...
    0,0,0,0,0,0,0,0,0,(1/25),0,0,0,0,0,0,0,0,0,0;...
    0,0,0,0,0,0,0,0,0,0,(1/25),0,0,0,0,0,0,0,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,(1/6.76),0,0,0,0,0,0,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,(1/50.60),0,0,0,0,0,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,(1/66.87),0,0,0,0,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,(1/82),0,0,0,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,(1/64.41),0,0,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,(1/8.18),0,0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,(1/186.69),0,0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,(1/16.88),0;...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,(1/24.55)];       
% linear inequality constraints vector
b = ones(20,1);
% linear equality constraints matrix: inizialization
Aeq = zeros(4,20);
% linear equality constraints vector: inizialization
beq = zeros(4,1);
% lower bounds vector: non-negativity constraint
lb = zeros(20,1);
% upper bounds vector
ub = [];
% solution array
sol = [];
% initial point for x
x0 = zeros(1,20);
% some optimization options
%{
options = optimoptions('fminimax', ...
    'StepTolerance', 0.1, ...
    'OptimalityTolerance', 1e-4,...
    'ConstraintTolerance', 1e-6, ...
    'Display', 'iter');
%}
% non linear constraints
nonlcon = [];
%{
options = optimoptions('fmincon', ...
    'StepTolerance', 0.1, ...
    'OptimalityTolerance', 1e-4,...
    'ConstraintTolerance', 1e-6, ...
    'Display', 'iter');
%}
p = inputdlg({'Set order for polynomial criterion'});
p=str2num(p{1});


end


%============optimization: iterations to solve min/max%criterion========

for k = 1:51
    % linear equality constraints matrix: filling
    % entering moment arm values 
    Aeq = [-valoribraccioRFhflex{k,2},-valoribraccioILhflex{k,2},valoribraccioGMAXhflex{k,2},-valoribraccioPShflex{k,2},...
        valoribraccioSMhflex{k,2},valoribraccioADDBhflex{k,2},valoribraccioADDGhflex{k,2},valoribraccioADDLhflex{k,2},...
        valoribraccioBFCLhflex{k,2},0,0,-valoribraccioGPIChflex{k,2},0,0,0,0,0,0,0,0;...
        valoribraccioRFkflex{k,2},0,0,0,-valoribraccioSMkflex{k,2},0,0,0,-valoribraccioBFCLkflex{k,2},0,0,0,...
        -valoribraccioGASkflex{k,2},valoribraccioVMkflex{k,2},valoribraccioVIkflex{k,2},valoribraccioVLkflex{k,2},...
        -valoribraccioBFCBkflex{k,2},0,0,0;...
        0,0,0,0,0,0,0,0,0,0,0,0,valoribraccioGASaflex{k,2},0,0,0,0,valoribraccioSOaflex{k,2},-valoribraccioTAaflex{k,2},...
        valoribraccioPEaflex{k,2};...
        valoribraccioRFhadd{k,2},0,valoribraccioGMAXhadd{k,2},-valoribraccioPShadd{k,2},-valoribraccioSMhadd{k,2},...
        -valoribraccioADDBhadd{k,2},-valoribraccioADDGhadd{k,2},-valoribraccioADDLhadd{k,2},-valoribraccioBFCLhadd{k,2},...
        valoribraccioGMEDahadd{k,2},valoribraccioGMEDphadd{k,2},valoribraccioGPIChadd{k,2},0,0,0,0,0,0,0,0];
    % linear equality constraints vector: filling
    % entering joint moment values
    beq = [valorimhipflex{k,2};valorimkneeflex{k,2};valorimankleflex{k,2};valorimhipadd{k,2}];
    % function calling
    [x,fval] = fmincon(@(x) myfun(x,p),x0,A,b,Aeq,beq,lb,ub,nonlcon);
    sol = vertcat(sol,x);
end


outputArg1 = sol;

end


function f = myfun(x,p)
f(1)=x(1)/42.96;
f(2)=x(2)/23.33;
f(3)=x(3)/20.20;
f(4)=x(4)/25.70;
f(5)=x(5)/46.33;
f(6)=x(6)/11.52;
f(7)=x(7)/18.35;
f(8)=x(8)/22.73;
f(9)=x(9)/27.34;
f(10)=x(10)/25;
f(11)=x(11)/25;
f(12)=x(12)/6.76;
f(13)=x(13)/50.60;
f(14)=x(14)/66.87;
f(15)=x(15)/82;
f(16)=x(16)/64.41;
f(17)=x(17)/8.18;
f(18)=x(18)/186.69;
f(19)=x(19)/16.88;
f(20)=x(20)/24.55;
f = sum(f.^p);
end

