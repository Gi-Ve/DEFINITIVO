clear all
close all
clc

matname = 'Subject47.mat';
if exist(matname,'file') ~= 2
    disp(['File ' matname ' not found.']);
    return;
end


load(matname)

name = s.name;
age  = s.Age;
sex  = deblank(s.Gender);
side = 'Right';
EMGFreq= s.EMGFreq;



data   = s.Data;
ntrial = length(s.Data);

M=s.Data(1).Marker;
MS=s.StandingData.Marker;


 


walk_indexes = [];
for i = 1:ntrial
    if strcmpi(deblank(s.Data(i).Task),'Walking') && strcmpi(deblank(s.Data(i).Foot),'RX')
        walk_indexes = [walk_indexes i];
    end
end


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
i=1
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
RectusFemorisEmgF=EmgFilter(RectusFemorisEmg,EMGFreq);
VastusMedialisEmgF=EmgFilter(VastusMedialisEmg,EMGFreq);
BicepsFemorisEmgF=EmgFilter(BicepsFemorisEmg,EMGFreq);
GluteusMaximusEmgF=EmgFilter(GluteusMaximusEmg,EMGFreq);
%======================================
f1=figure('Position', [10 10 1000 2500]);

[a,b]=size(M);
 a=a/3;
 
l=length(TibialisAnteriorEmg);




for j=0:0
    
 Perc=(j*100)/b;
 StrPerc=num2str(uint8(Perc));
 k = round((Perc/100)*l);
 
 subplot(4,2,1)
 plot(TibialisAnteriorEmg,'Color','b');hold on
 %plot(TibialisAnteriorEmgF,'Color','r','LineWidth',3);hold on
 %xline(k,'-',{'% GAIT CYCLE:',StrPerc},'Color','r');
 hold off
 axis tight;
 xlabel('Time Sample') 
 ylabel('Amplitude [mV]')
 title('TibialisAnteriorEmg')
 legend('Raw Signals','Filtered Signals');
 
 subplot(4,2,2)
 plot(SoleusEmg,'Color','b');hold on
 %plot(SoleusEmgF,'Color','r','LineWidth',3);hold on
 %xline(k,'-','Color','r');
 hold off
 axis tight;
 xlabel('Time Sample') 
 ylabel('Amplitude [mV]')
 title('SoleusEmg')
 legend('Raw Signals','Filtered Signals');
 
 subplot(4,2,3)
 plot(GastrocnemiusMedialisEmg,'Color','b');hold on
 %plot(GastrocnemiusMedialisEmgF,'Color','r','LineWidth',3);hold on
 %xline(k,'-','Color','r');
 hold off
 axis tight;
 xlabel('Time Sample') 
 ylabel('Amplitude [mV]')
 title('GastrocnemiusMedialisEmg')
 legend('Raw Signals','Filtered Signals');
 
 subplot(4,2,4)
 plot(PeroneusLongusEmg,'Color','b');hold on
 %plot(PeroneusLongusEmgF,'Color','r','LineWidth',3);hold on
 %xline(k,'-','Color','r');
 hold off
 axis tight;
 xlabel('Time Sample') 
 ylabel('Amplitude [mV]')
 title('PeroneusLongusEmg')
 legend('Raw Signals','Filtered Signals');
 
 subplot(4,2,5)
 plot(RectusFemorisEmg,'Color','b');hold on
 %plot(RectusFemorisEmgF,'Color','r','LineWidth',3);hold on
 %xline(k,'-','Color','r');
 hold off
 axis tight;
 xlabel('Time Sample') 
 ylabel('Amplitude [mV]')
 title('RectusFemorisEmg')
 legend('Raw Signals','Filtered Signals');
 
 subplot(4,2,6)
 plot(VastusMedialisEmg,'Color','b');hold on
 %plot(VastusMedialisEmgF,'Color','r','LineWidth',3);hold on
 %xline(k,'-','Color','r');
 hold off
 axis tight;
 xlabel('Time Sample') 
 ylabel('Amplitude [mV]')
 title('VastusMedialisEmg')
 legend('Raw Signals','Filtered Signals');
 
 subplot(4,2,7)
 plot(BicepsFemorisEmg,'Color','b');hold on
 %plot(BicepsFemorisEmgF,'Color','r','LineWidth',3);hold on
 %xline(k,'-','Color','r');
 hold off
 axis tight;
 xlabel('Time Sample') 
 ylabel('Amplitude [mV]')
 title('BicepsFemorisEmg')
 legend('Raw Signals','Filtered Signals');
 
 subplot(4,2,8)
 plot(GluteusMaximusEmg,'Color','b');hold on
 %plot(GluteusMaximusEmgF,'Color','r','LineWidth',3);hold on
 %xline(k,'-','Color','r');
 hold off
 axis tight;
 xlabel('Time Sample') 
 ylabel('Amplitude [mV]')
 title('GluteusMaximusEmg')
 legend('Raw Signals','Filtered Signals');
 
 drawnow
end
