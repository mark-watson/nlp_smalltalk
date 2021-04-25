"
Copyright 2005-2017 Mark Watson. All rights reserved. Licensed for use under the MIT license with attribution required.

See:  https://github.com/mark-watson/nlp_smalltalk

"
Class {
	#name : #ManifestKBSnlp,
	#superclass : #PackageManifest,
	#category : #KBSnlp
}

{ #category : #'code-critics' }
ManifestKBSnlp class >> ruleRBOnlyReadOrWrittenTemporaryRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'NLPsummarizer class' #summarize: #true)) #'2017-05-14T21:23:23.063039-07:00') )
]

{ #category : #'code-critics' }
ManifestKBSnlp class >> ruleRBToDoCollectRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'NLPsummarizer class' #summarize: #true)) #'2017-05-14T21:25:54.536453-07:00') )
]
