initialize
loadData
	"Load tokens that normally contain periods"

	| aSet count reverseDictionary forwardDictionary |
	count := 0.
	reverseDictionary := Dictionary new.
	forwardDictionary := Dictionary new.
	aSet := NLPsentences fileToSet: './nlp_smalltalk/tokensWithPeriods.txt'.
	Smalltalk at: #NLPtokensWithPeriods put: aSet.
	^ 'tokens with periods data loaded'