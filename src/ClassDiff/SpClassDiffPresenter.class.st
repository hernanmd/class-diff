"
A presenter to display the difference between two classes' methods. 
The alignment is performed using the Needleman-Wunsch algorithm implemented in `ALNeedlemanWunsch`.

See class side for examples.

"
Class {
	#name : 'SpClassDiffPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'sourceClassPresenter',
		'targetClassPresenter',
		'sourceClass',
		'targetClass',
		'aligner'
	],
	#category : 'ClassDiff',
	#package : 'ClassDiff'
}

{ #category : 'instance creation' }
SpClassDiffPresenter class >> openExample [
	<script>

	^ self new 
		sourceClass: OrderedCollection;
		targetClass: LinkedList;
		open
]

{ #category : 'accessing' }
SpClassDiffPresenter >> aligner [

	^ aligner
		
]

{ #category : 'accessing' }
SpClassDiffPresenter >> aligner: anObject [

	aligner := anObject
]

{ #category : 'layout' }
SpClassDiffPresenter >> defaultLayout [ 

	^ SpBoxLayout newLeftToRight 
		add: sourceClassPresenter;
		add: targetClassPresenter;
		yourself
]

{ #category : 'initialization' }
SpClassDiffPresenter >> initialExtentForWindow [

	^ (900 @ 600) scaledByDisplayScaleFactor
]

{ #category : 'initialization' }
SpClassDiffPresenter >> initialTitle [

	^ 'Class Difference'

]

{ #category : 'initialization' }
SpClassDiffPresenter >> initialize [

	super initialize.
	aligner := ALNeedlemanWunsch new.
]

{ #category : 'initialization' }
SpClassDiffPresenter >> initializePresenters [ 

	sourceClassPresenter := self newList
		beSingleSelection;
		yourself.
	targetClassPresenter := self newList
		beSingleSelection;
		yourself.
]

{ #category : 'initialization' }
SpClassDiffPresenter >> initializeWindow: aSpWindowPresenter [

	super initializeWindow: aSpWindowPresenter.

	self setTitleTo: aSpWindowPresenter.
	self setWindowIconTo: aSpWindowPresenter.
	self setInitialExtentTo: aSpWindowPresenter.

	aSpWindowPresenter aboutText: 'Class Difference Presenter, version 1.0'
]

{ #category : 'showing' }
SpClassDiffPresenter >> open [

	self updateAlignment.
	super open; centered.

]

{ #category : 'initialization' }
SpClassDiffPresenter >> setInitialExtentTo: aSpWindowPresenter [

	aSpWindowPresenter initialExtent: self initialExtentForWindow
]

{ #category : 'initialization' }
SpClassDiffPresenter >> setTitleTo: aSpWindowPresenter [

	aSpWindowPresenter title: self updatedTitle

]

{ #category : 'initialization' }
SpClassDiffPresenter >> setWindowIconTo: aSpWindowPresenter [

	aSpWindowPresenter	windowIcon: (self iconNamed: #diff).
]

{ #category : 'accessing' }
SpClassDiffPresenter >> sourceClass [

	^ sourceClass
]

{ #category : 'accessing' }
SpClassDiffPresenter >> sourceClass: anObject [

	sourceClass := anObject.
	self sourceClassPresenter headerTitle: sourceClass name.
]

{ #category : 'accessing' }
SpClassDiffPresenter >> sourceClassPresenter [

	^ sourceClassPresenter
]

{ #category : 'accessing' }
SpClassDiffPresenter >> sourceClassPresenter: anObject [

	sourceClassPresenter := anObject
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClass [

	^ targetClass
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClass: anObject [

	targetClass := anObject.
	self targetClassPresenter headerTitle: targetClass name
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClassPresenter [

	^ targetClassPresenter
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClassPresenter: anObject [

	targetClassPresenter := anObject
]

{ #category : 'initialization' }
SpClassDiffPresenter >> updateAlignment [
	"Align or re-align the source and target classes and update the presenters"

	(self sourceClass isNil or: [ self targetClass isNil ])
		ifTrue: [ ^ self ].
	self aligner 
		align: self sourceClass selectors sort
		with: self targetClass selectors sort.
	self sourceClassPresenter items: self aligner firstSequence.
	self targetClassPresenter items: self aligner secondSequence.
	self withWindowDo: [ :w | w title: self updatedTitle ].
]

{ #category : 'initialization' }
SpClassDiffPresenter >> updatedTitle [
	"Update the receiver's title to include additional statistic information such as the percentage of identity between the two classes"

	^ String streamContents: [ : stream |
		stream << self initialTitle.
		(self sourceClass isNil or: [ self targetClass isNil ])
			ifFalse: [ 
				stream
					<< ' [identity %: ';
					<< self aligner identity asString;
					<< ']' ] ]
]
