"
A NLPentities is a class to find people's names, company names, place names, etc. in text.

Copyright 2005-2017 Mark Watson. All rights reserved. Licensed for use under the MIT license with attribution required.

See:  https://github.com/mark-watson/nlp_smalltalk

"
Class {
	#name : #NLPentities,
	#superclass : #Object,
	#category : #KBSnlp
}

{ #category : #entityDetection }
NLPentities class >> entities: aString [
	"return a Dictionary of entities (keys type, values Sets"

	| temp result |
	result := Dictionary new.
	temp := NLPentities entityHelper: (Smalltalk at: #NLPcompanyNames) text: aString.
	temp size > 0
		ifTrue: [ result at: 'companies' put: temp ].
	temp := NLPentities entityHelper: (Smalltalk at: #NLPproductNames) text: aString.
	temp size > 0
		ifTrue: [ result at: 'products' put: temp ].
	temp := NLPentities entityHelper: (Smalltalk at: #NLPplaceNames) text: aString.
	temp size > 0
		ifTrue: [ result at: 'places' put: temp ].
	temp := NLPentities humanNameHelper: aString.
	temp size > 0
		ifTrue: [ result at: 'places' put: temp ].
	^ result
]

{ #category : #entityDetection }
NLPentities class >> entityHelper: entitySet text: aString [
	"this is a helper method for everything **but** person names"

	| tokens num ngram2 ngram3 results |
	results := Set new.
	tokens := NLPtagger tokenize: aString , ' xxxxx yyyyy zzzzz'.
	num := tokens size - 3.	" account for the 3 fake tokens at the end "
	1 to: num do: [ :i | 
		ngram2 := (tokens at: i) , ' ' , (tokens at: i + 1).
		ngram3 := ngram2 , ' ' , (tokens at: i + 2).	"Transcript show: ngram2; cr."
		(entitySet includes: ngram3)
			ifTrue: [ results add: ngram3 ]
			ifFalse: [ 
				(entitySet includes: ngram2)
					ifTrue: [ results add: ngram2 ]
					ifFalse: [ 
						(entitySet includes: (tokens at: i))
							ifTrue: [ results add: (tokens at: i) ] ] ] ].
	^ results
]

{ #category : #entityDetection }
NLPentities class >> fileToDictionary: filePath [

	"Read data/lexicon.txt and build in memory lexicon"

      | aDir read2 read count  aLine  strm  set |

      Transcript show: 'Processing file ' , filePath; cr.

	set := Set new.
	aDir := FileSystem disk workingDirectory.
	"read := (MultiByteFileStream fileNamed: filePath) readOnly."
	read := (aDir / filePath) readStream.
	"read := (ZnCharacterReadStream on: read2 encoding: #utf8)."
	
	count := 0.
	[read atEnd]
		whileFalse: [count := count + 1.
			aLine := read upTo: Character lf.	"Mac: use lf, Windows: use cr ???"
			"look for a space character: "
			((aLine indexOf: $:) > 0)
			  ifTrue: [ 
				 strm := ReadStream on: aLine.
			       aLine := strm upTo: $:].
			set add: aLine].
	read close.
	^set

]

{ #category : #entityDetection }
NLPentities class >> humanNameHelper: aString [
	"this is a helper method for everything **but** person names"

	| tokens num results |
	results := Set new.
	tokens := NLPtagger tokenize: aString , ' xxxxx yyyyy zzzzz'.
	num := tokens size - 3.	" account for the 3 fake tokens at the end "
	1 to: num do: [ :i | 
		((Smalltalk at: #NLPfirstNames) includes: (tokens at: i))
			ifTrue: [ 
				(((Smalltalk at: #NLPfirstNames) includes: (tokens at: i + 1))
					and: ((Smalltalk at: #NLPlastNames) includes: (tokens at: i + 2)))
					ifTrue: [ 
						results add: (tokens at: i) , ' ' , (tokens at: i + 1) , ' ' , (tokens at: i + 2).
						i := i + 2 ]
					ifFalse: [ 
						((Smalltalk at: #NLPlastNames) includes: (tokens at: i + 1))
							ifTrue: [ 
								results add: (tokens at: i) , ' ' , (tokens at: i + 1).
								i := i + 1 ] ] ] ].
	^ results
]

{ #category : #entityDetection }
NLPentities class >> initializeEntities [
	"load entity name data"

	" Note: place name lines of the form: Cairo:country_capital   Fixed in fileToDictionary "
   | repo path |
	repo := IceRepository registeredRepositoryIncludingPackage: (self class) package. 
   path := (repo location) asString .

	Smalltalk
		at: #NLPcompanyNames
		put: (NLPentities fileToDictionary: path , '/company_names.txt').
	Smalltalk
		at: #NLPfirstNames
		put: (NLPentities fileToDictionary: path , './firstnames.txt').
	Smalltalk
		at: #NLPlastNames
		put: (NLPentities fileToDictionary: path , './lastnames.txt').
	Smalltalk
		at: #NLPhonorifics
		put: (NLPentities fileToDictionary: path , '/honorifics.txt').
	Smalltalk
		at: #NLPprefixNames
		put: (NLPentities fileToDictionary: '/prefixnames.txt').
	Smalltalk
		at: #NLPplaceNames
		put: (NLPentities fileToDictionary: '/placenames.txt').
	Smalltalk
		at: #NLPproductNames
		put: (NLPentities fileToDictionary: path , '/product_names.txt').
		
	" also read in data we will need for sentence segmentation: "
	Smalltalk
		at: #NLPtokensWithPeriods
		put: (NLPentities fileToDictionary: path , '/tokensWithPeriods.txt').
]
