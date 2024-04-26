#!/bin/tcsh -xef

set subjList = (subj1 subj2 subj3)

set seedList = (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100)

cd /path/to/HCP1200

foreach subj ($subjList)

     cd $subj/fixextended/$subj/MNINonLinear/Results

foreach seed ($seedList)

3dmaskave -quiet -overwrite -mask /data/ckorponay/MNI/Schafer100_7network_2mm_{$seed}_mask.nii rfMRI_REST2_LR/rfMRI_REST2_LR_hp2000_clean.nii.gz"[20..1199]" > /data/ckorponay/Schafer_100_fixextended_T2/{$subj}_Schafer_{$seed}_Clean_TimeSeries_REST2_LR_fixextended.1D

end

 1dcat -csvout -overwrite /data/ckorponay/Schafer_100_fixextended_T2/{$subj}_Schafer_*_Clean_TimeSeries_REST2_LR_fixextended.1D > /data/ckorponay/Schafer_100_fixextended_T2/{$subj}_Schafer100_Clean_TimeSeries_REST2_LR_fixextended.csv

cd /path/to/HCP1200

end
