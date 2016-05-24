%%%% Given an a and a mask of the region of interest (whatever.label), 
%%%% this script return just the parcellations that are INSIDE the mask. 
%%%% Each parcellation will be saved as a .label file.
%%%% mirs_label2annot needed to transform those labels into an annot file.
%%%% INPUTS:
%%%%       - subjectName: Subject that contains the label file. E.g
%%%%       fsaverage.
%%%%       - maskLabelName: Name of the label (w/out the ".label").
%%%%       - parcellationAnnot: Annotation file name. E.g 123test.annot
%%%%
%%%% NOTE> (1) Set the SUBJECTS_DIR BEFORE OPENING matlab.
%%%%       (2) cd to path where the annot is, before running function.
%%%%       (3) Labels MUST be inside the subject (e.g inside fsverage/labels/) !
%%%%       (4) Vertices values change depending on subjects surface. Thus,
%%%%       both label and annotation files MUST be done on the same subject
%%%%       surface.



function [prova ] = microparcellation_masked(subjectName,maskLabelName, parcellationAnnotname)

% Load Label (vertex, MNI coordinates, Values)
label = read_label(subjectName,maskLabelName);
% Load Annot file(annotVertex = vertex#, vertexValues = value for each
% vertex)
[annotVertex, vertexValues, annotSpec] = read_annotation(parcellationAnnotname);
hemi = 'lh';


%Check min area of parcellations
clustersvalue = unique(vertexValues);
parcareas = zeros(1,length(clustersvalue));
for idx1 = 1:length(clustersvalue)
    % #of vertices w/ the same value. Used as area.
    parcareas(idx1) = sum(vertexValues == clustersvalue(idx1));

end
minarea = min(parcareas)*0.7;


%First filter. Mask w/ vertex values. Summ 1 in label b/c vertex start w/ 0 and
%Matlab indices w/ 1
nParcvertex = label(:,1);
nParcvalues = vertexValues(label(:,1) + 1);


%Second filter. Just parcellations w/ area = max area inside the mask,
%survive
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
