"
NLP tagger converted to Squeak.
A class that implements an NLP tagger.

Copyright 2005-2017 Mark Watson. All rights reserved. Licensed for use under the MIT license with attribution required.

See:  https://github.com/mark-watson/nlp_smalltalk

"
Class {
	#name : #NLPtagger,
	#superclass : #Object,
	#classVars : [
		'NLPlexicon'
	],
	#category : #KBSnlp
}

{ #category : #tagging }
NLPtagger class >> initializeLexicon [
	"Read data/lexicon.txt and build in memory lexicon"

	| read count strm aDir aLine word taglist token lex |
	lex := Dictionary new.
	aDir := FileSystem disk workingDirectory.
	read := (aDir / './pharo-local/iceberg/mark-watson/nlp_smalltalk/lexicon.txt') readStream.
	count := 0.
	[ read atEnd ]
		whileFalse: [ count := count + 1.
			aLine := read upTo: Character lf.	"Mac: use lf, Windows: use cr ???"
			strm := ReadStream on: aLine.
			word := strm upTo: Character space.
			taglist := OrderedCollection new.
			[ strm atEnd ]
				whileFalse: [ token := strm upTo: Character space.
					taglist add: token ].
			"Transcript show: word; cr."
			"Transcript show: taglist printString; cr."
			lex at: word put: taglist ].
	read close.
	Smalltalk at: #NLPlexicon put: lex
]

{ #category : #tagging }
NLPtagger class >> pptag: wordString [ 
	"returns a string of word/tag ..."

	| words tags write size count |
	words := NLPtagger tokenize: wordString.
	tags := NLPtagger tag: words.
	write := TextStream on: String new.
	size := words size.
	count := 1.
	[count <= size]
		whileTrue: [
			write nextPutAll: (words at: count).
			write nextPutAll: '/'.
			write nextPutAll: (tags at: count).
			write nextPutAll: ' '.
			count := count + 1].
	^write contents string
]

{ #category : #segmentation }
NLPtagger class >> sentences: data [
	"Handle either a string or array of tokens.
	 Limitations:
	  1. This code does not currently handle special characters like —
	  2. Periods in numbers: only check previous character, not the
	     next so a sentence ending with e.g., 2. will not be handled correctly.      
	"

	| tokens lastToken currentSentence allSentences token |
	tokens := (data isMemberOf: ByteString)
		ifTrue: (NLPtagger tokenize: data)
		ifFalse: data.
	currentSentence := OrderedCollection new.
	allSentences := OrderedCollection new.
	lastToken := ''.
	Transcript
		show: tokens;
		cr.
	tokens
		do: [ :token1 | 
			((Smalltalk at: #NLPtokensWithPeriods) includes: token1)
			  ifTrue: [ token := (Smalltalk at: #NLPtokensWithPeriods) get: token1 ]
			  ifFalse: [ token := token1 ].

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

{ #category : #tagging }
NLPtagger class >> tag: words [
	"tag an ordered collection of words, returning an ordered collection of corresponding tags"

	| lex tags tag count i word lastWord lastTag |
	tags := OrderedCollection new.
	lex := Smalltalk at: #NLPlexicon.
	words do: 
			[:aWord | 
			tag := lex at: aWord ifAbsent: [nil].
			tag isNil ifFalse: [tag := tag at: 1] ifTrue: [tag := 'NN'].	" the default tag "
			tags add: tag].
	" Apply transformation rules: "
	lastWord := ''.
	lastTag := ''.
	i := 0.
	count := words size.
	[i < count] whileTrue: 
			[i := i + 1.
			word := words at: i.
			tag := tags at: i.	" reuse tag variable "
			" First, handle all rules for i &gt; 1 "
			i > 1 
				ifTrue: 
					[" rule 1: DT, {VBD | VBP} --> DT, NN "

					lastTag = 'DT' & (tag = 'VBD' | (tag = 'VBP') | (tag = 'VB')) 
						ifTrue: [tags at: i put: 'NN'].
					tag size > 1 
						ifTrue: 
							[" rule 6: convert a noun to a verb if the preceeding work is 'would' "
							(tag at: 1) = $N & ((tag at: 2) = $N) & (lastWord asLowercase = 'would') 
								ifTrue: [tags at: i put: 'VB']]].
			" Now, handle the remaining rules that are valid for i = 1: "
			" rule 2: convert a noun to a number (CD) if '.' appears in the word"
			(word findString: '.') > 0 
				ifTrue: [(tag at: 1) = $N ifTrue: [tags at: i put: 'CD']].	" not working - tokenizer tosses '.' characters "
			" rule 3: convert a noun to a past participle if words[i] ends with 'ed' "
			(tag at: 1) = $N & (word endsWith: 'ed') ifTrue: [tags at: i put: 'VBN'].
			" rule 4: convert any type to adverb if it ends in 'ly' "
			(word endsWith: 'ly') ifTrue: [tags at: i put: 'RB'].
			" rule 5: convert a common noun (NN or NNS) to a adjective if it ends with 'al' "
			(tag at: 1) = $N & (word endsWith: 'al') ifTrue: [tags at: i put: 'JJ'].
			" rule 7: if a word has been categorized as a common noun and it ends with 's;, "
			"          then set its type to plural common noun (NNS) "
			tag = 'NN' & (word endsWith: 's') ifTrue: [tags at: i put: 'NNS'].
			" rule 8: convert a common noun to a present prticiple verb (i.e., a gerand) "
			(tag at: 1) = $N & (word endsWith: 'ing') ifTrue: [tags at: i put: 'VBG'].
			lastWord := word.
			lastTag := tag].
	^tags
]

{ #category : #tokenization }
NLPtagger class >> tokenize: wordsInAString [
	"tokenizes a string"

	^ wordsInAString
		findTokens:
			' ;:.,<>[]{}!
@#$%^&*()?'
		keep: ';:.,<>[]{}!$?'	" keep CR in this string!! "
]
