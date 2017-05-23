# Natural Language Processing Library for Pharo Smalltalk

Copyright 2005 to 2017 by Mark Watson

License: MIT

Note: the most frequent updates to this Pharo Smalltalk package will appear on the [github repo for this project](https://github.com/mark-watson/nlp_smalltalk). I will also try to keep the source on [SqueakSource.com](http://www.squeaksource.com) up to date.

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

## Sentence Segmentation

One time initialization:

    NLPsentences loadData

    NLPsentences sentences: 'Today Mr. Jones went to town. He bought gas.'
    
      --> an OrderedCollection(an OrderedCollection('Today' 'Mr.' 'Jones' 'went' 'to' 'town' '.') an OrderedCollection('He' 'bought' 'gas' '.'))
      
## Summarization

No additional data needs to be loaded for summarization, but all other data should be loaded as-per the above directions. Here is a short example:

    NLPsummarizer summarize: 'The administration and House Republicans have asked a federal appeals court for a 90-day extension in a case that involves federal payments to reduce deductibles and copayments for people with modest incomes who buy their own policies. The fate of $7 billion in "cost-sharing subsidies" remains under a cloud as insurers finalize their premium requests for next year. Experts say premiums could jump about 20 percent without the funding. In requesting the extension, lawyers for the Trump administration and the House said the parties are continuing to work on measures, including potential legislative action, to resolve the issue. Requests for extensions are usually granted routinely.'
    
    --> #('The administration and House Republicans have asked a federal appeals court for a 90-day extension in a case that involves federal payments to reduce deductibles and copayments for people with modest incomes who buy their own policies .' 'The fate of $ 7 billion in "cost-sharing subsidies" remains under a cloud as insurers finalize their premium requests for next year .' 'In requesting the extension , lawyers for the Trump administration and the House said the parties are continuing to work on measures , including potential legislative action , to resolve the issue .')
    
## Limitations

- Does not currently handle special characters like: —
- Categorization and summarization should also use "bag of ngrams" in addition to "bag of words" (BOW)
