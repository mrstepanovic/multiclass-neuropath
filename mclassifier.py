# multiclass one-vs-rest sklearn classifier
# pulled from stackoverflow -- barebone skeleton and will prob need lots of work

import numpy as np
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.svm import LinearSVC
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.multiclass import OneVsRestClassifier

# import training set feature matrix, X
X_train = np.array([]) # add data

# import training set target vector, y
y_train = np.array([]) # add data

# import test subject
X_test = np.array([]) # add data

classifier = Pipeline([
    ('vectorizer', CountVectorizer(min_n=1,max_n=2)),
    ('tfidf', TfidfTransformer()),
    ('clf', OneVsRestClassifier(LinearSVC()))])

classifier.fit(X_train, y_train)
predicted = classifier.predict(X_test)
for item, labels in zip(X_test, predicted):
    print '%s => %s' % (item, ', '.join(target_names[x] for x in labels))