Class {
	#name : 'BaselineOfClassDiff',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfClassDiff',
	#package : 'BaselineOfClassDiff'
}

{ #category : 'baselines' }
BaselineOfClassDiff >> aligner: spec [

	spec
		baseline: 'NeedlemanWunsch';
		with: [ spec repository: 'github://hernanmd/needleman-wunsch/src' ]

]

{ #category : 'baselines' }
BaselineOfClassDiff >> baseline: spec [
  <baseline>
	spec
		for: #(common)
		do: [ 
			self aligner: spec.
	
			spec 
				package: 'ClassDiff'        with: [ spec requires: #(NeedlemanWunsch) ];
				package: 'ClassDiff-Tests'	with: [ spec requires: #(ClassDiff) ].
			spec 
				group: 'Core' 						with: #('ClassDiff');
				group: 'Tests' 						with: #('ClassDiff' 'ClassDiff-Tests');
				group: 'default' 					with: #('Core' 'Tests') ]
]
