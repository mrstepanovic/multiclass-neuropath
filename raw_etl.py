# functions for use with mclassifier.py

def get_example(fname): # extracts example data (parcellation-wise thickness values) as np row vector
	raw_data = np.genfromtxt(fname, autostrip=True)
	return np.transpose(raw_data)[5,:] 

def build_training_set(training_set, example): # appends an example to training set
	np.concatenate((training_set, example), axis=0)