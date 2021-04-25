"
A class to classify English text into categories.

Copyright 2005-2017 Mark Watson. All rights reserved. Licensed for use under the MIT license with attribution required.

See:  https://github.com/mark-watson/nlp_smalltalk

"
Class {
	#name : #NLPsummarizer,
	#superclass : #Object,
	#category : #KBSnlp
}

{ #category : #summary }
NLPsummarizer class >> summarize: text [
	"extractive summarizer"

	| sentences sentenceScores tokens scoredCategories hash x bestIndices |
	scoredCategories := NLPcategories classify: text.
	sentences := NLPtagger sentences: text.
	sentenceScores := Array new: sentences size.
	1 to: sentences size do: [ :i | 
		sentenceScores at: i put: 0.
		tokens := sentences at: i.
		Transcript
			show: (sentences at: i);
			cr.
		scoredCategories
			do: [ :sc | 
				hash := (Smalltalk at: #NlpCategoryHash) at: (sc at: 2).
				tokens
					do: [ :token | 
						(hash includesKey: token)
							ifTrue: [ x := hash at: token.
								sentenceScores at: i put: (sentenceScores at: i) + (sc at: 1) ] ] ] ].
	bestIndices := sentenceScores
		collectWithIndex: [ :score :i | 
			{score.
			i} ].
	Transcript
		show: 'sentence scoring: ';
		show: bestIndices;
		cr.
	bestIndices := bestIndices select: [ :p | (p at: 1) > 2 ].
	^ bestIndices collect: [ :p | Character space join: (sentences at: (p at: 2)) ]
]
