# Natural Language Processing Library for Pharo Smalltalk

Copyright 2005 to 2017 by Mark Watson

License: Apache 2

## Setup

Change directory to of your Pharo Smalltalk installation and perform a git pull on this project:

  git clone https://github.com/mark-watson/nlp_smalltalk.git
  
On a Mac and Linux this should be the directory that contains the image, runtime app, and change list file.

## Part Of Speech Tagging

Open a File Browser and fileIn the KBSnlp.st source file. Open a Class Browser
and and look at the code in the KBnlp class.

Open a Workspace and one time only evaluate:

    NLPtagger initializeLexicon

Try tagging a sentence to make sure the data was read from disk correctly:

    NLPtagger pptag: 'The dog ran down the street'

If this does not work then probably the directory nlp_smalltalk is not in the default directory. The code containing the file path is:

    read := (FileStream fileNamed: './nlp_smalltalk/lexicon.txt') readOnly.

## Categorization

I am using NeoJSON to parse the category word count data so make sure NeoJSON is installed. NeoJSON can be installed using:

    Gofer it
       smalltalkhubUser: 'SvenVanCaekenberghe' project: 'Neo';
       configurationOf: 'NeoJSON';
       loadStable.

One time initialization:

    NLPcategories initializeCategoryHash
    
Try it:

     NLPcategories classify: 'The economy is bad and taxes are too high.'
     
## Entity Recognition

Implemented for products, companies, places, and people's names.

One time initialization:

     NLPentities initializeEntities
     
Example:

    NLPentities entities: 'The Coca Cola factory is in London'
    
            -->  a Dictionary('companies'->a Set('Coca Cola') 'places'->a Set('London') 'products'->a Set('Coca Cola') )
    
    NLPentities humanNameHelper: 'John Alex Smith and Andy Jones went to the store.'
    
                        --> a Set('John Alex Smith' 'Andy Jones')

## Limitations

- Does not currently handle special characters like: —
- Categorization and summarization should also use "bag of ngrams" in addition to "bag of words" (BOW)
