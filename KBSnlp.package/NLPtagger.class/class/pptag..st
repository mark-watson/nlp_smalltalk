tagging
pptag: wordString 
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