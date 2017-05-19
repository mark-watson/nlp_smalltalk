segment
sentences: someText
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