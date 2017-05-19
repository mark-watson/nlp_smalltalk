segmentation
sentences: data
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
	tokens
		do: [ :token1 | 
			((Smalltalk at: #NLPtokensWithPeriods)
				includes: token1)
				ifTrue: [ token := (Smalltalk
						at: #NLPtokensWithPeriods)
						get: token1 ]
				ifFalse: [ token := token1 ].
			Transcript
				show: token;
				cr.
			currentSentence add: token.
			((token = '.'
				and: lastToken isAllDigits not)
				or: token = '?')
				ifTrue: [ allSentences addLast: currentSentence.
					currentSentence := OrderedCollection
						new ].
			lastToken := token ].
	currentSentence isNotEmpty
		ifTrue: [ allSentences addLast: currentSentence ].
	^ allSentences