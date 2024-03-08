"
A presenter to display the difference between two classes' methods. 
The alignment is performed using the Needleman-Wunsch algorithm implemented in `ALNeedlemanWunsch`.

See class side for examples.

"
Class {
	#name : 'SpClassDiffPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'sourceClass',
		'targetClass',
		'aligner',
		'sourceClassListPresenter',
		'sourceMethodPresenter',
		'targetMethodPresenter',
		'targetClassListPresenter'
	],
	#category : 'ClassDiff-Spec',
	#package : 'ClassDiff',
	#tag : 'Spec'
}

{ #category : 'commands' }
SpClassDiffPresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [

	aCmCommandsGroup beDisplayedAsGroup.
	aCmCommandsGroup register: (self navigationCommandsGroupWith: presenter)
]

{ #category : 'commands' }
SpClassDiffPresenter class >> navigationCommandsGroupWith: aPresenter [
	| group |
	
	group := (CmCommandGroup named: 'ClassDiffCommands') asSpecGroup
		description: '';
		yourself.

	{ 
		SpBrowseClassCommand.		
		SpBrowseImplementorsCommand.
		SpBrowseSendersCommand.
		SpBrowseMethodReferencesCommand.	
	 } 
	do: [ :commandClass | group register: (commandClass forSpecContext: aPresenter) ].
	^ group
]

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

{ #category : 'initialization' }
SpClassDiffPresenter >> connectPresenters [ 

	sourceClassListPresenter 
		transmitTo: sourceMethodPresenter
		transform: [ : selector | selector 
			ifNotNil: [ self updateSelectionFromSource: selector ]
			ifNil: [ String empty ] ].
		
	targetClassListPresenter
		transmitTo: targetMethodPresenter 
		transform: [ : selector | selector 
			ifNotNil: [ self updateSelectionFromTarget: selector ] 
			ifNil: [ String empty ] ]
		
]

{ #category : 'layout' }
SpClassDiffPresenter >> defaultLayout [ 

	^ SpBoxLayout newLeftToRight
		spacing: 3;
		add: (SpBoxLayout newTopToBottom
			spacing: 3;		
			add: sourceClassListPresenter;
			add: sourceMethodPresenter;
			yourself);
		add: (SpBoxLayout newTopToBottom
			spacing: 3;		
			add: targetClassListPresenter;
			add: targetMethodPresenter;
			yourself);
		yourself
]

{ #category : 'commands' }
SpClassDiffPresenter >> doBrowseClass [

	self systemNavigation browse: sourceClass
]

{ #category : 'private - actions' }
SpClassDiffPresenter >> doBrowseImplementors [

	self systemNavigation browseAllImplementorsOf: self ensureSelectedItem.
]

{ #category : 'commands' }
SpClassDiffPresenter >> doBrowseMethodReferences [

	self systemNavigation browseAllSendersOrUsersOf: self ensureSelectedItem.
]

{ #category : 'private - actions' }
SpClassDiffPresenter >> doBrowseSenders [

	self systemNavigation browseAllSendersOf: self ensureSelectedItem
]

{ #category : 'controlling' }
SpClassDiffPresenter >> ensureSelectedItem [
	"Answer a <Symbol> representing the currently selected method. If the selection in any side is a gap character, then use the other side to get the selector"
	
	^ self sourceClassListPresenter selectedItem ~= self aligner gapCharacter
		ifFalse: [ self sourceClassListPresenter selectedItem ]
		ifTrue: [ self targetClassListPresenter selectedItem ]
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
SpClassDiffPresenter >> initializeListPresenters [

	sourceClassListPresenter := self newList
		beSingleSelection;
		contextMenu: [ (self rootCommandsGroup / 'ClassDiffCommands') beRoot asMenuPresenter ];
		yourself.
	targetClassListPresenter := self newList
		beSingleSelection;
		whenSelectedItemChangedDo: [ : item | item ifNotNil: [ self updateSelectionFromTarget: item ] ];
		contextMenu: [ (self rootCommandsGroup / 'ClassDiffCommands') beRoot asMenuPresenter ];		
		yourself.
]

{ #category : 'initialization' }
SpClassDiffPresenter >> initializeMethodPresenters [

	sourceMethodPresenter := self newCode
					lineNumbers: StPharoSettings codeShowLineNumbers;
					text: '';
					yourself.	
	targetMethodPresenter := self newCode
					lineNumbers: StPharoSettings codeShowLineNumbers;
					text: '';
					yourself.	

]

{ #category : 'initialization' }
SpClassDiffPresenter >> initializePresenters [ 

	self initializeListPresenters.
	self initializeMethodPresenters.
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
	self sourceClassListPresenter headerTitle: sourceClass name.
]

{ #category : 'accessing' }
SpClassDiffPresenter >> sourceClassListPresenter [

	^ sourceClassListPresenter
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClass [

	^ targetClass
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClass: anObject [

	targetClass := anObject.
	self targetClassListPresenter headerTitle: targetClass name
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClassListPresenter [

	^ targetClassListPresenter
]

{ #category : 'initialization' }
SpClassDiffPresenter >> updateAlignment [
	"Align or re-align the source and target classes and update the presenters"

	(self sourceClass isNil or: [ self targetClass isNil ])
		ifTrue: [ ^ self ].
	self aligner 
		align: self sourceClass selectors sort
		with: self targetClass selectors sort.
	self sourceClassListPresenter items: self aligner firstSequence.
	self targetClassListPresenter items: self aligner secondSequence.
	self withWindowDo: [ :w | w title: self updatedTitle ].
]

{ #category : 'accessing' }
SpClassDiffPresenter >> updateSelectionFromSource: selector [ 

	| aMethod |

	selector = self aligner gapCharacter
		ifTrue: [ ^ String empty ].

	targetClassListPresenter selectItem: selector.

	aMethod := self sourceClass >> selector.
	sourceMethodPresenter beForMethod: aMethod.
	^ aMethod sourceCode
]

{ #category : 'accessing' }
SpClassDiffPresenter >> updateSelectionFromTarget: selector [ 

	| aMethod |

	selector = self aligner gapCharacter
		ifTrue: [ ^ String empty ].

	sourceClassListPresenter selectItem: selector.

	aMethod := self targetClass >> selector.
	targetMethodPresenter beForMethod: aMethod.
	^ aMethod sourceCode
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
