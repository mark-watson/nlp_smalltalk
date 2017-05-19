tagging
initializeLexicon
	"Read data/lexicon.txt and build in memory lexicon"

	| read count strm aLine word taglist token lex |
	lex := Dictionary new.
	read := (FileStream fileNamed: './nlp_smalltalk/lexicon.txt') readOnly.
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