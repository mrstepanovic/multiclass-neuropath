# multiclass-neuropath

## About
Healthy elderly cortex appears quite different from tissue affected by frontotemporal dementia (FTD) and Alzheimer's Disease (AD). But how can these visually-striking large-scale patterns of brain atrophy be classified quantitatively into pathological diagnoses?

This project aims to use machine learning towards this end. More specificially, it trains a supervised multiclass support vector machine (SVM) using the one-v-rest approach, implemented with the scikit-learn library in Python 3.5.

## Steps
1. Reconstruct left and right hemisphere cortical surfaces with freesurfer's recon-all: http://bit.ly/1sz6dW3
2. Transform to common atlas space (i.e. "fsaverage") and compute standard score for each vertex, computed between hemispheres (globally)
3. Parcellate each hemisphere using (A) functional atlas topography (Desikan, 2006) or (B) isometric hexagon tesselation ("soccer ball"; mris_make_face_parcellation fsaverage/surf/lh.sphere.reg $FREESURFER_HOME/lib/bem/ic2.tri ./?h.microparc.annot) -- the preferred method is still TBD
4. Each parcel represents a feature in training set X, parameterized by theta. Features undergo regularization with a lambda value TBD. Training set targets are represented in target vector y as such { 1:'healthy', 2:'FTD', 3:'AD' }
5. ...
