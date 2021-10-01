function [FilteredEmg] = EmgFilterRectusFemoris(RectusFemorisEmg,VastusMedialisEmg,EMGFreq)

VastusMedialisEmg=rescale(VastusMedialisEmg,-1,1);
RectusFemorisEmg=rescale(RectusFemorisEmg,-1,1);


b1=EmgFilter(VastusMedialisEmg,EMGFreq);
b2=EmgFilter(RectusFemorisEmg,EMGFreq);


FilteredEmg=b2-b1;


end

