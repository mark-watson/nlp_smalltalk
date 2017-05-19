classify
classify: text
	"classify text in a string"

	| tokens categories scores num hash numTokens results cutoff |
	tokens :=  NLPtagger tokenize: (text , 'XXXXXX').
	categories := (Smalltalk at: #NlpCategoryHash) keys.
	num := categories size.
	numTokens := tokens size - 1.
	scores := Array new: num.
	1 to: num do: [ :i |
		scores at: i put: 0.
		hash := (Smalltalk at: #NlpCategoryHash) at: (categories at: i).
		1 to: numTokens do: [ :j |
			(hash includesKey: (tokens at: j))
			  ifTrue: [scores at: i put: ((scores at: i) + (hash at: (tokens at: j)))] ].
		hash := (Smalltalk at: #NlpCategory2gramHash) at: (categories at: i).
		1 to: numTokens do: [ :j |
			(hash includesKey: ((tokens at: j) , ' ' , (tokens at: j + 1)))
			  ifTrue: [scores at: i put: ((scores at: i)+ ((hash at: (tokens at: j) , ' ' , (tokens at: j + 1)) * 8))]]].
	results := SortedCollection sortBlock: [:c1 :c2 | (c1 at:1) > (c2 at:1)]. 
	1 to: num do: [ :i | |a| a := (Array new: 2). a at: 1 put: (scores at:i); at: 2 put: (categories at: i). results add: a ].
	cutoff := ((results at: 1) at: 1) / 2.
	results := results select: [ :x | (x at: 1) > cutoff ].
	^results.
	