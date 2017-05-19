utiities
fileToSet: filePath
	"Read file, create Set with elements being each line in file"

	| read aLine set |
	Transcript
		show: 'Processing file ' , filePath;
		cr.
	set := Set new.
	read := (MultiByteFileStream fileNamed: filePath) readOnly.
	[ read atEnd ]
		whileFalse: [ aLine := read upTo: Character lf.	"Mac: use lf, Windows: use cr ???"
			set add: aLine ].
	read close.
	^ set