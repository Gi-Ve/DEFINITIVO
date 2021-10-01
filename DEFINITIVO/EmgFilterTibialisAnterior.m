function [FilteredEmg] = EmgFilterTibialisAnterior(Emg,EMGFreq)

FilteredEmg=Emg;

l=length(FilteredEmg);

FilteredEmg = cat(2,FilteredEmg,FilteredEmg);
FilteredEmg = cat(2,FilteredEmg,Emg);
fs = EMGFreq;

HPorder=4; 
HPcut=50; 

[B1,A1]=butter(HPorder, HPcut /(fs/2),'high');

FilteredEmg = filtfilt(B1,A1,FilteredEmg);
FilteredEmg = smoothdata(FilteredEmg,'lowess');
FilteredEmg = abs(FilteredEmg);
LPorder=2; 
LPcut=4; 
[B2,A2]=butter(LPorder, LPcut /(fs/2),'low');
%FilteredEmg = filtfilt(B2,A2,FilteredEmg);
%FilteredEmg = rescale(FilteredEmg)

maximaSeparation = 30;
[FilteredEmg,~] = envelope(FilteredEmg,maximaSeparation,'peak');
FilteredEmg = smoothdata(FilteredEmg,'movmean','SmoothingFactor',0.25);
FilteredEmg = smoothdata(FilteredEmg,'movmean','SmoothingFactor',0.25);

FilteredEmg = FilteredEmg(l:l*2);

l=length(FilteredEmg);
y=l/51;
x1=(1:1:l);
x2=(1:y:l);

FilteredEmg=interp1(x1,FilteredEmg,x2);
