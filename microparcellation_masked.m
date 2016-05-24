%% microparcellation_masked.m
%
%% Given a surface and a mask of the region of interest (whatever.label), 
%% this script returns only the parcellations that are INSIDE the mask. 
%% Each parcellation will be saved as a .label file (there will be many).
%% mirs_label2annot needed to transform those labels into an annot file.
%%
%% INPUTS:
%%       'subjectName': contains the label file. e.g 'fsaverage'
%%       'maskLabelName': name of the ROI mask (without '.label' suffix).
%%       'parcellationAnnot': annotation file name, e.g temporal-pole.annot
%%
%% NOTES (1) Set freesurfer $SUBJECTS_DIR before running
%%       (2) cd to 'parcellationAnnot' parent dir before running function
%%       (3) labels MUST be inside subject dir (e.g inside 'fsaverage/label/')
%%       (4) vertex values vary between subjects; label and annotation 
%%	         files MUST represent the same subject
%%
%%	Credit to V. M. Blancafort, 2015

function [ prova ] = microparcellation_masked(subjectName, hemisphere, maskLabelName, parcellationAnnotname)

% Load label (vertices, MNI coordinates, values)
label = read_label(subjectName,maskLabelName);

% Load annot file (annotVertex = vertex #, vertexValues = value for each vertex)
[annotVertex, vertexValues, annotSpec] = read_annotation(parcellationAnnotname);
hemi = hemisphere;

% Check min area of parcellations
clustersvalue = unique(vertexValues);
parc_areas = zeros(1,length(clustersvalue));
for idx1 = 1:length(clustersvalue)
    % number of vertices w/ the same value. Used as area.
    parc_areas(idx1) = sum(vertexValues == clustersvalue(idx1));
end

minarea = min(parc_areas)*0.7;

% First filter. Mask w/ vertex values. Summ 1 in label b/c vertex start w/ 0 and
% Matlab indices w/ 1
nParcvertex = label(:,1);
nParcvalues = vertexValues(label(:,1) + 1);

% Second filter. Just parcellations w/ area = max area inside the mask survive
nclustervalues = unique(nParcvalues);
numLabel = 1;
for idx2=1:length(nclustervalues)
    xx = sum(nParcvalues == nclustervalues(idx2));
    if xx >= minarea
        allLabels{numLabel} = nParcvertex((nParcvalues == nclustervalues(idx2))); 
        numLabel = numLabel + 1;
    end
end

% Write all the labels
for idx3=1:length(allLabels)
    flname = [hemi '_VM_label_mask_div' int2str(idx3)];
    flindx = allLabels{idx3};
    flxyz = zeros(length(flindx),3);
    flvals = zeros(length(flindx),1);
    for idx4=1:length(flindx)
        pos = find(label(:,1) == flindx(idx4));
        flxyz(idx4,1:3) = label(pos,2:4);
        flvals(idx4) = label(pos,5);
    end
    
    kk = write_label(flindx,flxyz,flvals,flname,subjectName);
    
    if kk == 0
        fprintf('Error writting the lables!!');
        return;
    end  
end

prova = 1;
end
