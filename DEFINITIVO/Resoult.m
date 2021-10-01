clear all1
close all

sol=[];
Resoult=[];
ResoultS=[];
for x=1:50

n=int2str(x);

matname = ['Subject',n,'.mat'];

if exist(matname,'file') ~= 2
    disp(['File ' matname ' not found.']);
   return;
end

load(matname);

name = s.name;
age  = s.Age;
sex  = deblank(s.Gender);
height = s.BH;
weight = s.BM;
side = 'Right';
EMGFreq =s.EMGFreq;
H=(height/100)^2;
BMI=weight/H;

data   = s.Data;
ntrial = length(s.Data);


 

walk_indexes = [];
for i = 1:ntrial
    if strcmpi(deblank(s.Data(i).Task),'Walking') && strcmpi(deblank(s.Data(i).Foot),'RX')
        walk_indexes = [walk_indexes i];
    end
end

%===== GET MOMENTS INDEX
imomH = strmatch('HipFlxMom',(s.MomVarName));
imomHAbb = strmatch('HipAddMom',(s.MomVarName));
imomK = strmatch('KneeFlxMom',(s.MomVarName));
imomA = strmatch('AnkleFlxMom',(s.MomVarName));
%======================================

for i=1:length(walk_indexes)

%===== GET MOMENTS
momH=s.Data(walk_indexes(i)).Mom(imomH,:);
momHAbb=s.Data(walk_indexes(i)).Mom(imomHAbb,:);
momK=s.Data(walk_indexes(i)).Mom(imomK,:);
momA=s.Data(walk_indexes(i)).Mom(imomA,:);
%======================================

%===== GET EMG INDEX
iTibialisAnteriorEmg = strmatch('Tibialis Anterior',(s.EmgVarName));
iSoleusEmg = strmatch('Soleus',(s.EmgVarName));
iGastrocnemiusMedialisEmg = strmatch('Gastrocnemius Medialis',(s.EmgVarName));
iPeroneusLongusEmg = strmatch('Peroneus Longus',(s.EmgVarName));
iRectusFemorisEmg = strmatch('Rectus Femoris',(s.EmgVarName));
iVastusMedialisEmg = strmatch('Vastus Medialis',(s.EmgVarName));
iBicepsFemorisEmg = strmatch('Biceps Femoris',(s.EmgVarName));
iGluteusMaximusEmg = strmatch('Gluteus Maximus',(s.EmgVarName));
%=======================
%===== GET EMG
TibialisAnteriorEmg=s.Data(walk_indexes(i)).EMG(iTibialisAnteriorEmg,:);
SoleusEmg=s.Data(walk_indexes(i)).EMG(iSoleusEmg,:);
GastrocnemiusMedialisEmg=s.Data(walk_indexes(i)).EMG(iGastrocnemiusMedialisEmg,:);
PeroneusLongusEmg=s.Data(walk_indexes(i)).EMG(iPeroneusLongusEmg,:);
RectusFemorisEmg=s.Data(walk_indexes(i)).EMG(iRectusFemorisEmg,:);
VastusMedialisEmg=s.Data(walk_indexes(i)).EMG(iVastusMedialisEmg,:);
BicepsFemorisEmg=s.Data(walk_indexes(i)).EMG(iBicepsFemorisEmg,:);
GluteusMaximusEmg=s.Data(walk_indexes(i)).EMG(iGluteusMaximusEmg,:);
%======================================
%===== FILTER EMG
TibialisAnteriorEmgF=EmgFilter(TibialisAnteriorEmg,EMGFreq);
SoleusEmgF=EmgFilter(SoleusEmg,EMGFreq);
GastrocnemiusMedialisEmgF=EmgFilter(GastrocnemiusMedialisEmg,EMGFreq);
PeroneusLongusEmgF=EmgFilter(PeroneusLongusEmg,EMGFreq);
RectusFemorisEmgF=EmgFilterRectusFemoris(RectusFemorisEmg,VastusMedialisEmg,EMGFreq);
VastusMedialisEmgF=EmgFilter(VastusMedialisEmg,EMGFreq);
BicepsFemorisEmgF=EmgFilter(BicepsFemorisEmg,EMGFreq);
GluteusMaximusEmgF=EmgFilter(GluteusMaximusEmg,EMGFreq);
%======================================

cd '/Users/giovannivesentini/Desktop/DEFINITIVO/DATA'
sol=Optimization(momH,momHAbb,momK,momA,weight,height);
cd '/Users/giovannivesentini/Desktop/DEFINITIVO'

sol=sol.*weight;

%============== SOL/EMG ======================

%SOL
%BicepsFemorisSol attenzione tra capo lungo e capo breve, vedi modello
BicepsFemorisSol = sol(:,9);
%BicepsFemorisSol = sol(:,17);
GluteusMaximusSol = sol(:,3);
%BicepsFemorisSol attenzione tra mediale/laterale, vedi modello
GastrocnemiusMedialisSol = sol(:,13);
PeroneusLongusSol = sol(:,20);
RectusFemorisSol = sol(:,1);
SoleusSol = sol(:,18);
TibialisAnteriorSol = sol(:,19);
VastusMedialisSol = sol(:,14);
%===========================================
speed=s.Data(i).speed
R=[]
R=cat(2,R,x);
R=cat(2,R,i);
R=cat(2,R,age);
%R=cat(2,R,sex);
R=cat(2,R,speed);
R=cat(2,R,weight);
R=cat(2,R,height);
R=cat(2,R,BMI);
[c,lags] = xcorr(BicepsFemorisSol,BicepsFemorisEmgF,10,'normalized');
M=max(c);
R=cat(2,R,M);
[c,lags] = xcorr(GastrocnemiusMedialisSol,GastrocnemiusMedialisEmgF,10,'normalized');
M=max(c);
R=cat(2,R,M);
[c,lags] = xcorr(SoleusSol,SoleusEmgF,10,'normalized');
M=max(c);
R=cat(2,R,M);
[c,lags] = xcorr(PeroneusLongusSol,PeroneusLongusEmgF,10,'normalized');
M=max(c);
R=cat(2,R,M);
[c,lags] = xcorr(TibialisAnteriorSol,TibialisAnteriorEmgF,10,'normalized');
M=max(c);
R=cat(2,R,M);
[c,lags] = xcorr(VastusMedialisSol,VastusMedialisEmgF,10,'normalized');
M=max(c);
R=cat(2,R,M);

Resoult=cat(1,Resoult,R);
ResoultS=cat(1,ResoultS,sex);
end
T = array2table(Resoult,'VariableNames',{'Subject' ,'Trial','Age' ,'Speed','Weight','Height','BMI','BicepsFemoris','GastrocnemiusMedialis','Soleus','PeroneusLongus','TibialisAnterior','VastusMedialisSol'});
TS = array2table(ResoultS,'VariableNames',{'Sex'});
end

    Final=[T,TS];