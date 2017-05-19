tokenization
tokenize: wordsInAString
	"tokenizes a string"

	^ wordsInAString
		findTokens:
			' ;:.,<>[]{}!
@#$%^&*()?'
		keep: ';:.,<>[]{}!$?'	" keep CR in this string!! "