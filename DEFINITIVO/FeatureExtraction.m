
close all
clear all
sol=[];
Features=[];
for x=1:50

n=int2str(x);
matname = ['Subject',n,'.mat'];
load(matname);
data   = s.Data;
ntrial = length(s.Data);
height = s.BH;
weight = s.BM;

%===== GET MOMENTS INDEX
imomH = strmatch('HipFlxMom',(s.MomVarName));
imomHAbb = strmatch('HipAddMom',(s.MomVarName));
imomK = strmatch('KneeFlxMom',(s.MomVarName));
imomA = strmatch('AnkleFlxMom',(s.MomVarName));
%======================================


walk_indexes = [];
for i = 1:ntrial
    if strcmpi(deblank(s.Data(i).Task),'Walking') && strcmpi(deblank(s.Data(i).Foot),'RX')
        walk_indexes = [walk_indexes i];        
    end
end



for i=1:length(walk_indexes)

        %===== GET MOMENTS
        momH=s.Data(walk_indexes(i)).Mom(imomH,:);
        momHAbb=s.Data(walk_indexes(i)).Mom(imomHAbb,:);
        momK=s.Data(walk_indexes(i)).Mom(imomK,:);
        momA=s.Data(walk_indexes(i)).Mom(imomA,:);
        %======================================
        cd '/Users/giovannivesentini/Desktop/DEFINITIVO/DATA'
        sol(:,:,i)=Optimization(momH,momHAbb,momK,momA,weight,height);
        cd '/Users/giovannivesentini/Desktop/DEFINITIVO'
        sol(:,:,i)=sol(:,:,i).*weight;
        %===================FEATURES EXTRACTION=====================
        F=[];
        
        Max=max(sol(:,:,i));
        F=cat(2,F,Max);
        %Min=min(sol(:,:,i));
        %F=cat(2,F,Min);
        Mean=mean(sol(:,:,i));
        F=cat(2,F,Mean);
        Area=trapz(sol(:,:,i));
        F=cat(2,F,Area);
        F=cat(2,F,x);
        
        Features=cat(1,Features,F);
        
end
        T = array2table(Features,'VariableNames',{'Max 1' ,'Max 2' ,'Max 3' ,'Max 4' ,'Max 5' ,'Max 6' ,'Max 7' ,'Max 8' ,'Max 9' ,'Max 10',...
                                           'Max 11','Max 12','Max 13','Max 14','Max 15','Max 16','Max 17','Max 18','Max 19','Max 20',... 
                                           'Mean 1' ,'Mean 2' ,'Mean 3' ,'Mean 4' ,'Mean 5' ,'Mean 6' ,'Mean 7' ,'Mean 8' ,'Mean 9' ,'Mean 10',...
                                           'Mean 11','Mean 12','Mean 13','Mean 14','Mean 15','Mean 16','Mean 17','Mean 18','Mean 19','Mean 20',... 
                                           'Area 1' ,'Area 2' ,'Area 3' ,'Area 4' ,'Area 5' ,'Area 6' ,'Area 7' ,'Area 8' ,'Area 9' ,'Area 10',...
                                           'Area 11','Area 12','Area 13','Area 14','Area 15','Area 16','Area 17','Area 18','Area 19','Area 20',... 
                                           'Subject'});
                                       
disp('----------');
disp(['Name:',matname]);
                                       
                                       

end