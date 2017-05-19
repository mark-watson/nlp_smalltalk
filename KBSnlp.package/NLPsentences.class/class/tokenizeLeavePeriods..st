utiities
tokenizeLeavePeriods: wordsInAString
	"tokenizes a string"

	^ wordsInAString
		findTokens:
			' ;:,<>[]{}!
@#$%^&*()?'
		keep: ';:.,<>[]{}!$?'	" keep CR in this string!! "