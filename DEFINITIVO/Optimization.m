clear all1
close all

x = inputdlg({'Enter Subject: '});
x=x{1};

matname = ['Subject',x,'.mat'];

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

data   = s.Data;
ntrial = length(s.Data);


 

walk_indexes = [];
for i = 1:ntrial
    if strcmpi(deblank(s.Data(i).Task),'Walking') && strcmpi(deblank(s.Data(i).Foot),'RX')
        walk_indexes = [walk_indexes i];
    end
end


str=sprintf('Number of trial %d. Wich trial do you want to evaluate?',length(walk_indexes));
i = inputdlg(str);
i=str2num(i{1});

M=s.Data(i).Marker;
[a,b]=size(M);
 a=a/3;
%===== GET MOMENTS INDEX
imomH = strmatch('HipFlxMom',(s.MomVarName));
imomHAbb = strmatch('HipAddMom',(s.MomVarName));
imomK = strmatch('KneeFlxMom',(s.MomVarName));
imomA = strmatch('AnkleFlxMom',(s.MomVarName));
%======================================

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


%===== GET OPTIMIZATION SOLUTION =============================
cd '/Users/giovannivesentini/Desktop/DEFINITIVO/DATA'

answer = questdlg('Choose Optimization method', ...
	'OPTIMIZATION METHOD', ...
	'MIN/MAX','POLYNOMIAL','SOFT-SATURATION','MIN/MAX');
% Handle response
switch answer
    case 'MIN/MAX'
        sol=Optimization(momH,momHAbb,momK,momA,weight,height);
    case 'POLYNOMIAL'
        sol=OptimizationPoly(momH,momHAbb,momK,momA);
    case 'SOFT-SATURATION'
        sol=OptimizationSoftSaturation(momH,momHAbb,momK,momA);
   %{
        case 'EXIT'
        disp('SEE YOU')
        quit();
        %}
end
cd '/Users/giovannivesentini/Desktop/DEFINITIVO'

sol=sol.*weight;
 l=length(sol);
 x=(1:3:87);
    y=(2:3:87);
    z=(3:3:87);
x1=(0:2:100);


%====================== PLOT ===================
f1=figure('Position', [10 10 900 900], 'Visible','on');

  for i=1:1 
   %{ 
    subplot(3,2,1)
    plot(M(z,i),M(y,i),'o','Color','b','MarkerFaceColor','r');hold on 
    title('FRONTAL PLANE')
    axis equal;
    axis off 
    hold off
    %}
    
    %{
    subplot(3,2,2)
    plot(M(x,i),M(y,i),'o','Color','r','MarkerFaceColor','b'); hold on
    axis equal;
    axis([-inf inf -inf inf])
    axis off
    title('SAGITTAL PLANE')
    hold off
   %}
    
 Perc=(i*100)/b;
 disp(Perc);
 StrPerc=num2str(uint8(Perc));
 k = 2*round((Perc/100)*l);
 disp(k);
 
 subplot(2,2,1)
plot(x1,sol(:,1),x1,sol(:,2),x1,sol(:,3),...
    x1,sol(:,4),x1,sol(:,5),x1,sol(:,9),'LineWidth',1); 
hold on
%xline(k,'-',{'% GAIT CYCLE:',StrPerc},'Color','r','LineWidth',2);
lgd=legend('RF','IL','GMAX','PS','SM','BFCL');
title('HIP FLEX/EX')
xlabel('GAIT CYCLE %') 
ylabel('Force [N]') 
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
 hold off
grid;

 subplot(2,2,2)
plot(x1,sol(:,6),x1,sol(:,7),x1,sol(:,8),...
    x1,sol(:,10),x1,sol(:,11),x1,sol(:,12),'LineWidth',1);
hold on
%xline(k,'-','Color','r','LineWidth',2);
lgd=legend('ADDB','ADDG','ADDL','GMEDa','GMEDp','GMIN');
title('HIP ADD/ABD')
xlabel('GAIT CYCLE %') 
ylabel('Force [N]') 
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
 hold off
grid;
 
 subplot(2,2,3)
plot(x1,sol(:,1),x1,sol(:,14),x1,sol(:,15),...
    x1,sol(:,16),x1,sol(:,17),'LineWidth',1);
hold on
%xline(k,'-','Color','r','LineWidth',2);
lgd=legend('RF','VM','VI','VL','BFCB');
title('KNEE FLEX/EX')
xlabel('GAIT CYCLE %') 
ylabel('Force [N]') 
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
 hold off
grid;
 
 subplot(2,2,4)
plot(x1,sol(:,13),x1,sol(:,18),...
    x1,sol(:,19),x1,sol(:,20),'LineWidth',1);
hold on
%xline(k,'-','Color','r','LineWidth',2);
lgd=legend('GAS','SO','TA','PE');
title('ANKLE FLEX/EX')
xlabel('GAIT CYCLE %') 
ylabel('Force [N]') 
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
 hold off
grid;

Movie(i) = getframe(gcf) ;
    drawnow
  end
  
   % create the video writer with 1 fps
  writerObj = VideoWriter('myVideo.avi');
  writerObj.FrameRate = 10;
  % set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(Movie)
    % convert the image to a frame
    frame = Movie(i) ;    
    %writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);


f2=figure('Visible','on');
subplot(2,2,1)
plot(momH)
xlabel('GAIT CYCLE %') 
ylabel('Moment Nm/Kg')
title('HIP MOMENT')
grid;
hold on
subplot(2,2,2)
plot(momA)
xlabel('GAIT CYCLE %') 
ylabel('Moment Nm/Kg')
title('ANKLE MOMENT')
grid;
hold on
subplot(2,2,3)
plot(momK)
xlabel('GAIT CYCLE %') 
ylabel('Moment Nm/Kg')
title('KNEE MOMENT')
grid;
hold on
subplot(2,2,4)
plot(momHAbb)
xlabel('GAIT CYCLE %') 
ylabel('Moment Nm/Kg')
title('HIP ABBDUCTION MOMENT')
grid;
saveas(gcf,'Subject6(MOMENT).svg')


%============== SOL/EMG ======================

%SOL
if 0 == 0
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
end


f3=figure('Position', [10 10 1000 2500]);

subplot(12,2,[1,3,5])
plot(x1,rescale(BicepsFemorisSol),'Color','r','LineWidth',2); hold on
plot(x1,rescale(BicepsFemorisEmgF),'Color','b');
[c,lags] = xcorr(BicepsFemorisSol,BicepsFemorisEmgF,10,'normalized');
str = string(max(c));
%text(1,0.5,str)
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
%title('BicepsFemoris')
lgd=legend('BicepsFemorisForce','BicepsFemorisEMG');
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
axis tight;

subplot(12,2,7)
plot(Boolean(BicepsFemorisSol)*1.2,'Marker','s','Color','r','MarkerFaceColor','r','LineStyle','none'); hold on
plot(Boolean(BicepsFemorisEmgF),'Marker','s','Color','b','MarkerFaceColor','b','LineStyle','none');
set(gca, 'XLim', [1,51])
axis off;



subplot(12,2,[2,4,6])
plot(x1,rescale(GastrocnemiusMedialisSol),'Color','r','LineWidth',2); hold on
plot(x1,rescale(GastrocnemiusMedialisEmgF),'Color','b');
[c,lags] = xcorr(GastrocnemiusMedialisSol,GastrocnemiusMedialisEmgF,10,'normalized');
str = string(max(c));
%text(1,0.5,str)
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
%title('GastrocnemiusMedialis')
lgd=legend('GastrocnemiusMedialisForce','GastrocnemiusMedialisEMG');
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
axis tight;

subplot(12,2,8)
plot(Boolean(GastrocnemiusMedialisSol)*1.2,'Marker','s','Color','r','MarkerFaceColor','r','LineStyle','none'); hold on
plot(Boolean(GastrocnemiusMedialisEmgF),'Marker','s','Color','b','MarkerFaceColor','b','LineStyle','none');
set(gca, 'XLim', [1,51])
axis off;

subplot(12,2,[10,12,14])
plot(x1,rescale(PeroneusLongusSol),'Color','r','LineWidth',2); hold on
plot(x1,rescale(PeroneusLongusEmgF),'Color','b');
[c,lags] = xcorr(PeroneusLongusSol,PeroneusLongusEmgF,10,'normalized');
str = string(max(c));
text(1,0.5,str)
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
%title('PeroneusLongus')
lgd=legend('PeroneusLongusForce','PeroneusLongusEMG');
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
axis tight;


subplot(12,2,16)
plot(Boolean(PeroneusLongusSol)*1.2,'Marker','s','Color','r','MarkerFaceColor','r','LineStyle','none'); hold on
plot(Boolean(PeroneusLongusEmgF),'Marker','s','Color','b','MarkerFaceColor','b','LineStyle','none');
set(gca, 'XLim', [1,51])
axis off;




subplot(12,2,[9,11,13])
plot(x1,rescale(SoleusSol),'Color','r','LineWidth',2); hold on
plot(x1,rescale(SoleusEmgF),'Color','b');
[c,lags] = xcorr(SoleusSol,SoleusEmgF,10,'normalized');
str = string(max(c));
text(1,0.5,str)
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
%title('Soleus')
lgd=legend('SoleusForce','SoleusEMG');
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
axis tight;


subplot(12,2,15)
plot(Boolean(SoleusSol)*1.2,'Marker','s','Color','r','MarkerFaceColor','r','LineStyle','none'); hold on
plot(Boolean(SoleusEmgF),'Marker','s','Color','b','MarkerFaceColor','b','LineStyle','none');
set(gca, 'XLim', [1,51])
axis off;

subplot(12,2,[17,19,21])
plot(x1,rescale(TibialisAnteriorSol),'Color','r','LineWidth',2); hold on
plot(x1,rescale(TibialisAnteriorEmgF),'Color','b');
[c,lags] = xcorr(TibialisAnteriorSol,TibialisAnteriorEmgF,10,'normalized');
str = string(max(c));
text(1,0.5,str)
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
%title('TibialisAnterior')
lgd=legend('TibialisAnteriorForce','TibialisAnteriorEMG');
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
axis tight;

subplot(12,2,23)
plot(Boolean(TibialisAnteriorSol)*1.2,'Marker','s','Color','r','MarkerFaceColor','r','LineStyle','none'); hold on
plot(Boolean(TibialisAnteriorEmgF),'Marker','s','Color','b','MarkerFaceColor','b','LineStyle','none');
set(gca, 'XLim', [1,51])
axis off;

subplot(12,2,[18,20,22])
plot(x1,rescale(VastusMedialisSol),'Color','r','LineWidth',2); hold on
plot(x1,rescale(VastusMedialisEmgF),'Color','b');
[c,lags] = xcorr(VastusMedialisSol,VastusMedialisEmgF,10,'normalized');
str = string(max(c));
%text(1,0.5,str)
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
%title('VastusMedialis')
lgd=legend('VastusMedialisForce','VastusMedialisEMG');
lgd.FontSize = 15;
s=gca;
set(s,'fontsize',15)
axis tight;


subplot(12,2,24)
plot(Boolean(VastusMedialisSol)*1.2,'Marker','s','Color','r','MarkerFaceColor','r','LineStyle','none'); hold on
plot(Boolean(VastusMedialisEmgF),'Marker','s','Color','b','MarkerFaceColor','b','LineStyle','none');
set(gca, 'XLim', [1,51])
axis off;


figure(4)
title('Cross Correlation')
subplot(3,2,1)
[c,lags] = xcorr(BicepsFemorisSol,BicepsFemorisEmgF,10,'normalized');
stem(lags,c);hold on
title('BicepsFemoris')
subplot(3,2,2)
[c,lags] = xcorr(GastrocnemiusMedialisSol,GastrocnemiusMedialisEmgF,10,'normalized');
stem(lags,c)
title('GastrocnemiusMedialis')
subplot(3,2,3)
[c,lags] = xcorr(SoleusSol,SoleusEmgF,10,'normalized');
stem(lags,c)
title('SoleusSol')
subplot(3,2,4)
[c,lags] = xcorr(PeroneusLongusSol,PeroneusLongusEmgF,10,'normalized');
stem(lags,c)
title('PeroneusLongus')
subplot(3,2,5)
[c,lags] = xcorr(TibialisAnteriorSol,TibialisAnteriorEmgF,10,'normalized');
stem(lags,c)
title('TibialisAnterior')
subplot(3,2,6)
[c,lags] = xcorr(VastusMedialisSol,VastusMedialisEmgF,10,'normalized');
stem(lags,c)
title('VastusMedialis')
%{

subplot(8,2,9)
plot(x1,rescale(RectusFemorisSol),x1,rescale(RectusFemorisEmgF));
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
title('RectusFemoris')
legend('RectusFemorisSol','RectusFemorisEmg');


subplot(8,2,10)
plot(x1,rescale(SoleusSol),x1,rescale(SoleusEmgF));
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
title('Soleus')
legend('SoleusSol','SoleusEmg');


subplot(8,2,13)
plot(x1,rescale(TibialisAnteriorSol),x1,rescale(TibialisAnteriorEmgF));
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
title('TibialisAnterior')
legend('TibialisAnteriorSol','TibialisAnteriorEmg');


subplot(8,2,14)
plot(x1,rescale(VastusMedialisSol),x1,rescale(VastusMedialisEmgF));
xlabel('GAIT CYCLE %') 
ylabel('Scaled Value')
title('VastusMedialis')
legend('VastusMedialisSol','VastusMedialisEmg');

%}