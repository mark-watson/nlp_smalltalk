entityDetection
entityHelper: entitySet text: aString
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