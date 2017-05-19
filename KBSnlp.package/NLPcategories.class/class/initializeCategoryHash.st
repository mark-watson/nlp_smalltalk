classify
initializeCategoryHash
	"requires NeoJSON"

     Smalltalk at: #NlpCategoryHash
                    put: (NeoJSONReader fromString: (FileStream fileNamed: './nlp_smalltalk/tags.json') contentsOfEntireFile).
     Smalltalk at: #NlpCategory2gramHash
                    put: (NeoJSONReader fromString: (FileStream fileNamed: './nlp_smalltalk/tags_2gram.json') contentsOfEntireFile)