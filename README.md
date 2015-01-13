# Natural Language Processing Library for Pharo Smalltalk

Copyright 2005 to 2014 by Mark Watson

License: AGPL 3.0 (Note: I own the copyright of all of the code in this project; contact me if you need a commercial license.)

## Setup

Change directory to of your Pharo Smalltalk installation and perform a git pull on this project:

  git clone https://github.com/mark-watson/nlp_smalltalk.git
  
On a Mac, change directory into the App folder that defines the Pharo application: Contents/Resources. On my system this is:

  cd ~/Pharo3.0.app/Contents/Resources


## Part Of Speech Tagging

Open a File Browser and fileIn the KBSnlp.st source file. Open a Class Browser
and and look at the code in the KBnlp class.

Open a Workspace and one time only evaluate:

    NLPtagger initializeLexicon

Note (5/2/2014): after the text file is processed, the lexicon dictionary is inspected:

    lex inspect.

If the inspector window shows an empty dictionary then the file lexicon.txt was not found.

Try tagging a sentence:

    NLPtagger pptag: 'The dog ran down the street'

## CategorizationI am using NeoJSON to parse the category word count data.One time initialization:    NLPcategories initializeCategoryHashTry it:     NLPcategories classify: 'The economy is bad and taxes are too high.'## Entity RecognitionImplemented for products, companies, places, and people's names.One time initialization:     NLPentities initializeEntitiesExample:    NLPentities entities: 'The Coca Cola factory is in London'        -->  a Dictionary('companies'->a Set('Coca Cola') 'places'->a Set('London') 'products'->a Set('Coca Cola') )    NLPentities humanNameHelper: 'John Alex Smith and Andy Jones went to the store.'        --> a Set('John Alex Smith' 'Andy Jones')