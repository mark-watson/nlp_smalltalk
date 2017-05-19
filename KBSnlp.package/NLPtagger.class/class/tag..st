tagging
tag: words
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