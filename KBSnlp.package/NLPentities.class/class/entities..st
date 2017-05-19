entityDetection
entities: aString
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