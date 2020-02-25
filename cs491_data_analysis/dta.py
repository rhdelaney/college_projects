from numpy import average
from utils import txt2words, w2v_load_model
from time import time
import numpy as np
import gensim
import json

class DeepTextAnalyzer(object):
    def __init__(self, word2vec_model):
        """
        Construct a DeepTextAnalyzer using the input Word2Vec model
        :param word2vec_model: a trained Word2Vec model
        """
        self._model = word2vec_model

    def txt2vectors(self,txt, is_html):
        """
        Convert input text into an iterator that returns the corresponding vector representation of each
        word in the text, if it exists in the Word2Vec model
        :param txt: input text
        :param is_html: if True, then extract the text from the input HTML
        :return: iterator of vectors created from the words in the text using the Word2Vec model.
        """
        words = txt2words(txt)
        words = [w for w in words if w in self._model]
        if len(words) != 0:
            for w in words:
                yield self._model[w]


    def txt2avg_vector(self, txt, is_html):
        """
        Calculate the average vector representation of the input text
        :param txt: input text
        :param is_html: is the text is a HTML
        :return the average vector of the vector representations of the words in the text  
        """
        vectors = self.txt2vectors(txt,is_html=is_html)
        vectors_sum = next(vectors, None)
        if vectors_sum is None:
            return None
        count =1.0
        for v in vectors:
            count += 1
            vectors_sum = np.add(vectors_sum,v)
        
        #calculate the average vector and replace +infy and -inf with numeric values 
        avg_vector = np.nan_to_num(vectors_sum/count)
        return avg_vector

def load_tweets(fname):
    tweets = []
    tw=[]
    for line in open(fname):
        data = json.loads(line)
        tw.append(data)
    for a in tw:
        text, id_str, label = line.rstrip().split(',')
        tweets.append([text, id_str, label])
    return tweets

def generate_arff_header(f):
    f.write('@relation Word2VecRelation\n\n')
    for i in range(300):
        f.write('@attribute feature%s numeric\n' % i)
    f.write('@attribute class { relevant, irrelavent }\n')
    f.write('\n')

def w2v_vector(dta, text, label):
    """
    Given a text, generate Word2Vec vector and append the vector to a file
    :param dta: DeepTextAnalyzer object
    :param text: input text
    :param label: input label
    """
    vector = dta.txt2avg_vector(text, is_html=False)
    if vector is None:
        print 'Could not generate Word2Vec vector for %s' % text
        return
    return [0.0 if v==None else str(v) for v in vector]

def generate_arff_data(f, tweets):
    t0 = time()
    model = w2v_load_model('GoogleNews-vectors-negative300.bin')
    print 'loading model: %s' % (time() - t0)

    dta = DeepTextAnalyzer(model)

    f.write('@data\n')
    for _, label, text in tweets:
        vector = w2v_vector(dta, text, label)
        f.write('%s,%s\n' % (','.join(vector), label))

if __name__ == '__main__':

    # 1. load tweets
    tweets = load_tweets('train.txt')
    # 2. generate ARFF file
    with open('trained.arff', 'w') as f:
        # generate the header
        generate_arff_header(f)

        # generate the data part
        generate_arff_data(f, tweets)

    tweets2 = load_tweets('eval.txt')
    with open('evaled.arff', 'w') as p:
        # generate the header
        generate_arff_header(p)

        # generate the data part
        generate_arff_data(p, tweets2)

