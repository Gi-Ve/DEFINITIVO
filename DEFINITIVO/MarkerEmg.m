load('Subject1.mat')

M=s.Data(1).Marker;
MS=s.StandingData.Marker;
ntrial = length(s.Data);

[a,b]=size(M);
 a=a/3;
 
%========================GET MARKER COORDINATE=================

    RxCheec  =[MS(1,1),MS(2,1),MS(3,1)];
    
    LxCheec  =[MS(4,1),MS(5,1),MS(6,1)];
    
    C7       =[MS(7,1),MS(8,1),MS(9,1)];
    
    MSaxkif   =[MS(10,1),MS(11,1),MS(12,1)];
    
    RxShould =[MS(13,1),MS(14,1),MS(15,1)];
   
    LxShould =[MS(16,1),MS(17,1),MS(18,1)];
    
    RxElbow  =[MS(19,1),MS(20,1),MS(21,1)];
    
    LxElbow  =[MS(22,1),MS(23,1),MS(24,1)];
    
    RxWrist  =[MS(25,1),MS(26,1),MS(27,1)];
   
    LxWrist  =[MS(28,1),MS(29,1),MS(30,1)];
    
    Psis     =[MS(31,1),MS(32,1),MS(33,1)];
    
    RxAsis   =[MS(34,1),MS(35,1),MS(36,1)];
    
    LxAsis   =[MS(37,1),MS(38,1),MS(39,1)];
    
    RxThigh  =[MS(40,1),MS(41,1),MS(42,1)];
    
    LxThigh  =[MS(43,1),MS(44,1),MS(45,1)];
   
    RxLatCon =[MS(46,1),MS(47,1),MS(48,1)];
    
    LxLatCon =[MS(49,1),MS(50,1),MS(51,1)];
   
    RxFH     =[MS(52,1),MS(53,1),MS(54,1)];
    
    LxFH     =[MS(55,1),MS(56,1),MS(57,1)];
    
    RxShank  =[MS(58,1),MS(59,1),MS(60,1)];
    
    LxShank  =[MS(61,1),MS(62,1),MS(63,1)];
    
    RxLatMal =[MS(64,1),MS(65,1),MS(66,1)];
    
    LxLatMal =[MS(67,1),MS(68,1),MS(69,1)];
    
    RxHeel   =[MS(70,1),MS(71,1),MS(72,1)];
    
    LxHeel   =[MS(73,1),MS(74,1),MS(75,1)];
    
    RxToe1   =[MS(76,1),MS(77,1),MS(78,1)];
    
    LxToe1   =[MS(79,1),MS(80,1),MS(81,1)];
    
    RxMeta5  =[MS(82,1),MS(83,1),MS(84,1)];
    
    LxMeta5  =[MS(85,1),MS(86,1),MS(87,1)];
    
%============================================================

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
i=4
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



RxPeroneL=norm(RxFH-RxLatMal);
RxPeroneL = round(RxPeroneL,3);
RxPerone=[RxFH.' RxLatMal.']; 
RxPeroneM=mean(RxPerone.');
StrRxPerone=['\leftarrow RxPerone:',num2str(RxPeroneL),'[m]'];

LxPeroneL=norm(LxFH-LxLatMal);
LxPeroneL = round(LxPeroneL,3);
LxPerone=[LxFH.' LxLatMal.']; 
LxPeroneM=mean(LxPerone.');
StrLxPerone=['LxPerone:',num2str(LxPeroneL),'[m]\rightarrow'];

RxGomitoPolsoL=norm(RxElbow-RxWrist);
RxGomitoPolsoL = round(RxGomitoPolsoL,3);
RxGomitoPolso=[RxElbow.' RxWrist.']; 
RxGomitoPolsoM=mean(RxGomitoPolso.');
StrRxGomitoPolso=['\leftarrow RxGomitoPolso:',num2str(RxGomitoPolsoL),'[m]'];

LxGomitoPolsoL=norm(LxElbow-LxWrist);
LxGomitoPolsoL = round(LxGomitoPolsoL,3);
LxGomitoPolso=[LxElbow.' LxWrist.']; 
LxGomitoPolsoM=mean(LxGomitoPolso.');
StrLxGomitoPolso=['LxGomitoPolso:',num2str(LxGomitoPolsoL),'[m]\rightarrow'];

RxSpallaGomitoL=norm(RxShould-RxElbow);
RxSpallaGomitoL = round(RxSpallaGomitoL,3);
RxSpallaGomito=[RxShould.' RxElbow.']; 
RxSpallaGomitoM=mean(RxSpallaGomito.');
StrRxSpallaGomito=['\leftarrow RxSpallaGomito:',num2str(RxSpallaGomitoL),'[m]'];

LxSpallaGomitoL=norm(LxShould-LxElbow);
LxSpallaGomitoL = round(LxSpallaGomitoL,3);
LxSpallaGomito=[LxShould.' LxElbow.']; 
LxSpallaGomitoM=mean(LxSpallaGomito.');
StrLxSpallaGomito=['LxSpallaGomito:',num2str(LxSpallaGomitoL),'[m]\rightarrow'];
    x=(1:3:87);
    y=(2:3:87);
    z=(3:3:87);
   
    

 l=length(TibialisAnteriorEmg)   
    
f1=figure('Position', [10 10 500 2500]);

  for i=1:b 
    subplot(6,2,[1,3])
    plot(M(z,i),M(y,i),'o','Color','b','MarkerFaceColor','r');hold on 
    title('FRONTAL PLANE')
    axis equal;
    axis off 
    hold off
    
    
    subplot(6,2,[2,4])
    plot(M(x,i),M(y,i),'o','Color','r','MarkerFaceColor','b'); hold on
    axis equal;
    axis([-inf inf -inf inf])
    axis off
    title('SAGITTAL PLANE')
    hold off
    
 Perc=(i*100)/b;
 StrPerc=num2str(uint8(Perc));
 k = round((Perc/100)*l);
 
 subplot(6,2,5)
 plot(TibialisAnteriorEmg);hold on
 xline(k,'-',{'% GAIT CYCLE:',StrPerc},'Color','r','LineWidth',2);
 title('TibialisAnteriorEmg');
 hold off
 axis tight;
 subplot(6,2,6)
 plot(SoleusEmg);hold on
 xline(k,'-','Color','r','LineWidth',2);
 title('SoleusEmg');
 hold off
 axis tight;
 subplot(6,2,7)
 plot(GastrocnemiusMedialisEmg);hold on
 xline(k,'-','Color','r','LineWidth',2);
 title('GastrocnemiusMedialisEmg')
 hold off
 axis tight;
 subplot(6,2,8)
 plot(PeroneusLongusEmg);hold on
 xline(k,'-','Color','r','LineWidth',2);
 title('PeroneusLongusEmg')
 hold off
 axis tight;
 subplot(6,2,9)
 plot(RectusFemorisEmg);hold on
 xline(k,'-','Color','r','LineWidth',2);
 title('RectusFemorisEmg')
 hold off
 axis tight;
 subplot(6,2,10)
 plot(VastusMedialisEmg);hold on
 xline(k,'-','Color','r','LineWidth',2);
 title('VastusMedialisEmg')
 hold off
 axis tight;
 subplot(6,2,11)
 plot(BicepsFemorisEmg);hold on
 xline(k,'-','Color','r','LineWidth',2);
 title('BicepsFemorisEmg')
 hold off
 axis tight;
 subplot(6,2,12)
 plot(GluteusMaximusEmg);hold on
 xline(k,'-','Color','r','LineWidth',2);
 title('GluteusMaximusEmg')
 hold off
 axis tight;
 %{
 if Perc==20
  saveas(gcf,'Subject6(12).svg')
 end
 if Perc==60
  saveas(gcf,'Subject6(60).svg')
 end
 %}
 Movie(i) = getframe(gcf) ;
    drawnow
  end
  
     % create the video writer with 1 fps
  writerObj = VideoWriter('EMG_REDLINE.avi');
  writerObj.FrameRate = 20;
  % set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(Movie)
    % convert the image to a frame
    frame = Movie(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);
  
f2=figure();
f2.WindowState = 'maximized';
    plot3(MS(z,1), MS(x,1), MS(y,1),'o','Color','k','MarkerFaceColor','r'); hold on
    plot3(RxPerone(3,:),RxPerone(1,:),RxPerone(2,:),'Color','k','LineWidth',2); hold on
    plot3(LxPerone(3,:),LxPerone(1,:),LxPerone(2,:),'Color','k','LineWidth',2); hold on
    plot3(RxGomitoPolso(3,:),RxGomitoPolso(1,:),RxGomitoPolso(2,:),'Color','k','LineWidth',2); hold on
    plot3(LxGomitoPolso(3,:),LxGomitoPolso(1,:),LxGomitoPolso(2,:),'Color','k','LineWidth',2); hold on
    plot3(RxSpallaGomito(3,:),RxSpallaGomito(1,:),RxSpallaGomito(2,:),'Color','k','LineWidth',2); hold on
    plot3(LxSpallaGomito(3,:),LxSpallaGomito(1,:),LxSpallaGomito(2,:),'Color','k','LineWidth',2); hold on
    text(RxPeroneM(3),RxPeroneM(1),RxPeroneM(2),StrRxPerone);
    text(LxPeroneM(3),LxPeroneM(1),LxPeroneM(2),StrLxPerone,'HorizontalAlignment','right')
    text(RxGomitoPolsoM(3),RxGomitoPolsoM(1),RxGomitoPolsoM(2),StrRxGomitoPolso);
    text(LxGomitoPolsoM(3),LxGomitoPolsoM(1),LxGomitoPolsoM(2),StrLxGomitoPolso,'HorizontalAlignment','right');
    text(RxSpallaGomitoM(3),RxSpallaGomitoM(1),RxSpallaGomitoM(2),StrRxSpallaGomito);
    text(LxSpallaGomitoM(3),LxSpallaGomitoM(1),LxSpallaGomitoM(2),StrLxSpallaGomito,'HorizontalAlignment','right');
    hold off
     saveas(gcf,'Subject6standing.svg')
    axis equal;
    title('STANDING DATA')