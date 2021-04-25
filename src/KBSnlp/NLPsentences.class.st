"
A class to segment text into sentences.

Copyright 2005-2017 Mark Watson. All rights reserved. Licensed for use under the MIT license with attribution required.

See:  https://github.com/mark-watson/nlp_smalltalk

"
Class {
	#name : #NLPsentences,
	#superclass : #Object,
	#category : #KBSnlp
}

{ #category : #utiities }
NLPsentences class >> fileToSet: filePath [
	"Read file, create Set with elements being each line in file"

	| read aLine set aDir |
	Transcript
		show: 'Processing file ' , filePath;
		cr.
	set := Set new.
	"read := (MultiByteFileStream fileNamed: filePath) readOnly."
	aDir := FileSystem disk workingDirectory.
	read := (aDir / './pharo-local/iceberg/mark-watson/nlp_smalltalk/lexicon.txt') readStream.
	
	[ read atEnd ]
		whileFalse: [ aLine := read upTo: Character lf.	"Mac: use lf, Windows: use cr ???"
			set add: aLine ].
	read close.
	^ set
]

{ #category : #initialize }
NLPsentences class >> loadData [
	"Load tokens that normally contain periods"

	| aSet count reverseDictionary forwardDictionary |
	count := 0.
	reverseDictionary := Dictionary new.
	forwardDictionary := Dictionary new.
	aSet := NLPsentences fileToSet: './pharo-local/iceberg/mark-watson/nlp_smalltalk/tokensWithPeriods.txt'.
	Smalltalk at: #NLPtokensWithPeriods put: aSet.
	^ 'tokens with periods data loaded'
]

{ #category : #segment }
NLPsentences class >> sentences: someText [
	"tokenize a string into individual sentences"

	| tokens aSet lastToken currentSentence allSentences |
	aSet := Smalltalk at: #NLPtokensWithPeriods.
	tokens := OrderedCollection new.
	(NLPsentences tokenizeLeavePeriods: someText)
		do: [ :token | 
			(token includesSubstring: '.') not
				ifTrue: [ tokens add: token ]
				ifFalse: [ (aSet includes: token)
						ifFalse: [ tokens add: (token copyWithRegex: '\.' matchesReplacedWith: '').
							tokens add: '.' ]
						ifTrue: [ tokens add: token ] ] ].
	currentSentence := OrderedCollection new.
	allSentences := OrderedCollection new.
	lastToken := ''.
	Transcript
		show: tokens;
		cr.
	tokens
		do: [ :token | 
			Transcript
				show: token;
				cr.
			currentSentence add: token.
			((token = '.' and: lastToken isAllDigits not) or: token = '?')
				ifTrue: [ allSentences addLast: currentSentence.
					currentSentence := OrderedCollection new ].
			lastToken := token ].
	currentSentence isNotEmpty
		ifTrue: [ allSentences addLast: currentSentence ].
	^ allSentences
]

{ #category : #utiities }
NLPsentences class >> tokenizeLeavePeriods: wordsInAString [
	"tokenizes a string"

	^ wordsInAString
		findTokens:
			' ;:,<>[]{}!
@#$%^&*()?'
		keep: ';:.,<>[]{}!$?'	" keep CR in this string!! "
]
