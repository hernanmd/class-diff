Class {
	#name : 'SpClassDiffAlignmentTest',
	#superclass : 'TestCase',
	#category : 'ClassDiff-Tests',
	#package : 'ClassDiff-Tests'
}

{ #category : 'tests - alignment' }
SpClassDiffAlignmentTest >> testAlignDisjointSequences [

	| a |
	a := ALNeedlemanWunsch new.
	a align: #( x y z ) with: #( a b c ).
	self assert: a firstSequence size equals: a secondSequence size.
	self assert: a identity < 50
]

{ #category : 'tests - alignment' }
SpClassDiffAlignmentTest >> testAlignEmptySequences [

	| a |
	a := ALNeedlemanWunsch new.
	a align: #(  ) with: #(  ).
	self assert: a firstSequence isEmpty.
	self assert: a secondSequence isEmpty
]

{ #category : 'tests - alignment' }
SpClassDiffAlignmentTest >> testAlignIdenticalSequences [

	| a |
	a := ALNeedlemanWunsch new.
	a align: #( a b c ) with: #( a b c ).
	self assert: a firstSequence equals: #( a b c ) asOrderedCollection.
	self assert: a secondSequence equals: #( a b c ) asOrderedCollection.
	self assert: a identity equals: (100.00 asScaledDecimal: 2)
]

{ #category : 'tests - alignment' }
SpClassDiffAlignmentTest >> testAlignOneEmptySequence [

	| a |
	a := ALNeedlemanWunsch new.
	a align: #( a b c ) with: #(  ).
	self assert: a firstSequence size equals: 3.
	self assert: a secondSequence size equals: 3.
	self assert:
		(a secondSequence allSatisfy: [ :e | e = a gapCharacter ])
]

{ #category : 'tests - alignment' }
SpClassDiffAlignmentTest >> testAlignWithGaps [

	| a |
	a := ALNeedlemanWunsch new.
	a align: #( a b c d ) with: #( a c d e ).
	self assert: a firstSequence equals: #( a b c d '-' ) asOrderedCollection.
	self assert: a secondSequence equals: #( a '-' c d e ) asOrderedCollection.
	self assert: a firstSequence size equals: a secondSequence size
]

{ #category : 'tests - class alignment' }
SpClassDiffAlignmentTest >> testClassAlignmentIdentity [

	| a |
	a := ALNeedlemanWunsch new.
	a align: Collection selectors sort with: Collection selectors sort.
	self assert: a identity equals: (100.00 asScaledDecimal: 2)
]

{ #category : 'tests - class alignment' }
SpClassDiffAlignmentTest >> testClassSelectorsAlignment [

	| a |
	a := ALNeedlemanWunsch new.
	a align: Array selectors sort with: OrderedCollection selectors sort.
	self assert: a firstSequence size equals: a secondSequence size
]

{ #category : 'tests - alignment' }
SpClassDiffAlignmentTest >> testGapCharacter [

	| a |
	a := ALNeedlemanWunsch new.
	self assert: a gapCharacter equals: '-'
]

{ #category : 'tests - alignment' }
SpClassDiffAlignmentTest >> testMatchScoreGap [

	| a |
	a := ALNeedlemanWunsch new.
	self
		assert: (a matchScore: #a with: a gapCharacter)
		equals: a gapPenalty.
	self
		assert: (a matchScore: a gapCharacter with: #a)
		equals: a gapPenalty
]

{ #category : 'tests - alignment' }
SpClassDiffAlignmentTest >> testMatchScoreIdentical [

	| a |
	a := ALNeedlemanWunsch new.
	self assert: (a matchScore: #a with: #a) equals: a matchAward
]

{ #category : 'tests - alignment' }
SpClassDiffAlignmentTest >> testMatchScoreMismatch [

	| a |
	a := ALNeedlemanWunsch new.
	self assert: (a matchScore: #a with: #b) equals: a mismatchPenalty
]
