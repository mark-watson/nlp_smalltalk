# Natural Language Processing Library for Pharo Smalltalk

Copyright 2005 to 2014 by Mark Watson

License: AGPL 3.0 (Note: I own the copyright of all of the code in this project; contact me if you need a commercial license.)

## Setup

Change directory to of your Pharo Smalltalk installation and performa git pull on this project:

  git pull https://github.com/mark-watson/nlp_smalltalk.git
  
On a Mac, change directory into the App folder that defines the Pharo application: Contents/Resources. On my system this is:

  cd ~/Pharo3.0.app/Contents/Resources


## Running an example

Open a File Browser and fileIn the KBSnlp.st source file. Open a Class Browser
and and look at the code in the KBnlp class.

Open a Workspace and one time only evaluate:

    NLPtagger initializeLexicon

Note (5/2/2014): after the text file is processed, the lexicon dictionary is inspected:

    lex inspect.

If the inspector window shows an empty dictionary then the file lexicon.txt was not found.

Try tagging a sentence:

    NLPtagger pptag: 'The dog ran down the street'

## To be done

The enclosed code is a simple Smalltalk port (done in 2008) of my Java FastTag part of speech
(POS) tagger that is available on my open source page http://markwatson.com/opensource

When/if I have time I will also port my classifier and named entity recognizer (NER) code.