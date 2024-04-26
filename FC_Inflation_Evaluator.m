%%% Purpose: Quantify and visualize trend in brain-wide average functional connectivity (FC)
%%% magnitude over time to assess the presence of "FC Inflation" in an fMRI
%%% dataset

clearvars; close all; clc
      
%load CSV files containing the preprocessed/denoised BOLD timeseries of each ROI for each subject
%(each CSV contains all ROI timeseries for a given subject; columns are ROIs, rows are TRs)

P = '/path/to/ROItimeseries/CSVfiles';
S = dir(fullfile(P,'*.csv'));

P2 = '/path/to/ROItimeseries/CSVfiles';
S2 = dir(fullfile(P2,'*.csv'));


for i = 1:numel(S) %for each subject:

i=i  %list subject ID currently processing

%load timeseries into Matlab 

    F = fullfile(P,S(i).name);
    S(i).data = readtable(F,'NumHeaderLines', 1);    %use if CSV columns contain header names
    %S(i).data = readtable(F,'NumHeaderLines', 0);   %use if CSV columns do not contain header names
    S(i).data = table2array(S(i).data); 
    S(i).data = double(S(i).data);
    %S(i).data = S(i).data(any(S(i).data,2),:);      %remove motion-censored TRs (i.e. rows of all zeros)

    [T,N] = size(S(i).data);

    z1 = zscore(S(i).data);                          % z-score the data


%load timeseries into Matlab 

    F2 = fullfile(P2,S2(i).name);
    S2(i).data = readtable(F2,'NumHeaderLines', 1);   %use if CSV columns contain header names
    %S2(i).data = readtable(F2,'NumHeaderLines', 0);  %use if CSV columns do not contain header names
    S2(i).data = table2array(S2(i).data); 
    S2(i).data = double(S2(i).data);
    %S2(i).data = S2(i).data(any(S2(i).data,2),:);    %remove motion-censored TRs (i.e. rows of all zeros)

   [T2,N2] = size(S2(i).data);

   z2 = zscore(S2(i).data);                           % z-score the data


%compute framewise (i.e., TR-wise) co-fluctation magnitudes for each ROI-ROI edge/"connection"

h=1
for x = 1:N                                  
    for j = 1:N2
       S3(i).data(:,h) = z1(:,x).*z2(:,j);  %store the co-fluctation/edge timeseries of each subject in S3(i).data
       h=h+1;
    end
end

end

%remove "self-connections"
for b=1:numel(S3)
k=N2-1;
p=N2;
for n=1:N2
  S3(b).data(:,n*k+p)=[];
  k=k-1;
  p=p-1;
end
end


%compute the group-average, brain-wide average trend in functional
%connectivity strength over the course of the scan

r=0
for b=1:numel(S) %for each subject:

    r=r+1
    j=1;

    for i=1:N2^2-N2
    c=1;

       while j<length(S3(b).data(:,1))-60     %for 60TR chunks
       %while j<length(S3(b).data(:,1))-30    %for 30TR chunks
       %while j<length(S3(b).data(:,1))-15    %for 15TR chunks

       every60TRs(i,c,r)=mean(unique(S3(b).data(j:j+59,i)));   %average connectivity value across all unique ROI-ROI connections during 60TR chunks
       %every30TRs(i,c,r)=mean(unique(S3(b).data(j:j+29,i)));    %average connectivity value across all unique ROI-ROI connections during 30TR chunks
       %every15TRs(i,c,r)=mean(unique(S3(b).data(j:j+14,i)));    %average connectivity value across all unique ROI-ROI connections during 15TR chunks

       j=j+60;  %for 60TR chunks 
       %j=j+30; %for 30TR chunks
       %j=j+15; %for 15TR chunks
       c=c+1;
       end

     j=1;
    end
end

GroupAvg_every60TRs=mean(every60TRs,3); %for 60TR chunks
%GroupAvg_every30TRs=mean(every30TRs,3); %for 30TR chunks
%GroupAvg_every15TRs=mean(every15TRs,3); %for 15TR chunks

GroupAvg_BrainwideAvg_FC_overTime_60TRs = mean(GroupAvg_every60TRs); %group-average, brain-wide average trend in FC strength over time

plot(GroupAvg_BrainwideAvg_FC_overTime_60TRs) %visualize the group-level trend in brain-wide FC strength over time


%compute subject-level trends in brainwide FC change over time

for i=1:numel(S)
    Subject_BrainwideAvg_FC_overTime_60TRchunks(i,:)=mean(every60TRs(:,:,i),1);
end


