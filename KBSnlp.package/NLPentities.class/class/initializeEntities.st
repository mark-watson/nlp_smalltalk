entityDetection
initializeEntities
	"load entity name data"

	" Note: place name lines of the form: Cairo:country_capital   Fixed in fileToDictionary "

	Smalltalk
		at: #NLPcompanyNames
		put: (NLPentities fileToDictionary: './nlp_smalltalk/company_names.txt').
	Smalltalk
		at: #NLPfirstNames
		put: (NLPentities fileToDictionary: './nlp_smalltalk/firstnames.txt').
	Smalltalk
		at: #NLPlastNames
		put: (NLPentities fileToDictionary: './nlp_smalltalk/lastnames.txt').
	Smalltalk
		at: #NLPhonorifics
		put: (NLPentities fileToDictionary: './nlp_smalltalk/honorifics.txt').
	Smalltalk
		at: #NLPprefixNames
		put: (NLPentities fileToDictionary: './nlp_smalltalk/prefixnames.txt').
	Smalltalk
		at: #NLPplaceNames
		put: (NLPentities fileToDictionary: './nlp_smalltalk/placenames.txt').
	Smalltalk
		at: #NLPproductNames
		put: (NLPentities fileToDictionary: './nlp_smalltalk/product_names.txt').
		
	" also read in data we will need for sentence segmentation: "
	Smalltalk
		at: #NLPtokensWithPeriods
		put: (NLPentities fileToDictionary: './nlp_smalltalk/tokens_with_periods.txt').