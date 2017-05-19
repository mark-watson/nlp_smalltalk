entityDetection
fileToDictionary: filePath

	"Read data/lexicon.txt and build in memory lexicon"

      | read count  aLine  strm  set |

      Transcript show: 'Processing file ' , filePath; cr.

	set := Set new.
	read := (MultiByteFileStream fileNamed: filePath) readOnly.
	count := 0.
	[read atEnd]
		whileFalse: [count := count + 1.
			aLine := read upTo: Character lf.	"Mac: use lf, Windows: use cr ???"
			"look for a space character: "
			((aLine indexOf: $:) > 0)
			  ifTrue: [ 
				 strm := ReadStream on: aLine.
			       aLine := strm upTo: $:].
			set add: aLine].
	read close.
	^set
