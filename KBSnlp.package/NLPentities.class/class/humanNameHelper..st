entityDetection
humanNameHelper: aString
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