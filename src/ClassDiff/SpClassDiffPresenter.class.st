"
A Spec 2 presenter that displays a side-by-side diff of two classes method selectors using Needleman-Wunsch alignment. Selectors present in both classes are aligned; selectors present in only one class are shown with a gap character in the other sides list.
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
		'targetClassListPresenter',
		'isSyncingScroll'
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

{ #category : 'private - commands' }
SpClassDiffPresenter >> classCommandsGroup [

	| group |
	group := CmCommandGroup forSpec
		         name: 'ClassDiffCommands';
		         description: 'Commands for the ClassDiff browser'.
	group register: (SpClassDiffBrowseClassCommand forSpecContext: self).
	group register:
		(SpClassDiffBrowseImplementorsCommand forSpecContext: self).
	group register:
		(SpClassDiffBrowseSendersCommand forSpecContext: self).
	group register:
		(SpClassDiffBrowseReferencesCommand forSpecContext: self).
	^ group
]

{ #category : 'initialization' }
SpClassDiffPresenter >> connectPresenters [

	super connectPresenters.
	sourceClassListPresenter
		transmitTo: sourceMethodPresenter
		transform: [ :selector |
				selector
					ifNotNil: [ self updateSelectionFromSource: selector ]
					ifNil: [ String empty ] ].
	targetClassListPresenter
		transmitTo: targetMethodPresenter
		transform: [ :selector |
				selector
					ifNotNil: [ self updateSelectionFromTarget: selector ]
					ifNil: [ String empty ] ].
	sourceClassListPresenter whenBuiltDo: [ :ann |
		self hookScrollSyncOnSource ].
	targetClassListPresenter whenBuiltDo: [ :ann |
		self hookScrollSyncOnTarget ]
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

{ #category : 'actions' }
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

{ #category : 'accessing' }
SpClassDiffPresenter >> ensureSelectedItem [

	^ self sourceClassListPresenter selectedItem
	  = self aligner gapCharacter
		  ifTrue: [ self targetClassListPresenter selectedItem ]
		  ifFalse: [ self sourceClassListPresenter selectedItem ]
]

{ #category : 'private - scrolling' }
SpClassDiffPresenter >> hookScrollSyncOnSource [

	| table |
	table := self sourceTableMorph.
	table ifNil: [ ^ self ].
	table announcer
		when: FTScrollingChanged
		send: #syncScrollFromSource
		to: self.
	self
		wrapVerticalScrollBarOn: table
		syncBlock: [ self syncScrollFromSource ]
]

{ #category : 'private - scrolling' }
SpClassDiffPresenter >> hookScrollSyncOnTarget [

	| table |
	table := self targetTableMorph.
	table ifNil: [ ^ self ].
	table announcer
		when: FTScrollingChanged
		send: #syncScrollFromTarget
		to: self.
	self
		wrapVerticalScrollBarOn: table
		syncBlock: [ self syncScrollFromTarget ]
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
	isSyncingScroll := false.
	super initialize.
	aligner := ALNeedlemanWunsch new
]

{ #category : 'initialization' }
SpClassDiffPresenter >> initializeContextMenus [

	| commandsGroup |
	commandsGroup := self classCommandsGroup.
	sourceClassListPresenter contextMenu: [
		commandsGroup beRoot asMenuPresenter ].
	targetClassListPresenter contextMenu: [
		commandsGroup beRoot asMenuPresenter ]
]

{ #category : 'initialization' }
SpClassDiffPresenter >> initializeListPresenters [

	sourceClassListPresenter := self newList
		                            beSingleSelection;
		                            contextMenu: [ self classCommandsGroup beRoot asMenuPresenter ];
		                            yourself.
	targetClassListPresenter := self newList
		                            beSingleSelection;
		                            contextMenu: [ self classCommandsGroup beRoot asMenuPresenter ];
		                            yourself
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
	self initializeContextMenus
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
SpClassDiffPresenter >> sourceClass: aClass [

	sourceClass := aClass.
	sourceClass 
		ifNotNil: [ sourceClassListPresenter headerTitle: sourceClass name ].
	self updateAlignment
]

{ #category : 'accessing' }
SpClassDiffPresenter >> sourceClassListPresenter [

	^ sourceClassListPresenter
]

{ #category : 'private - scrolling' }
SpClassDiffPresenter >> sourceTableMorph [

	^ sourceClassListPresenter withAdapterDo: [ :a |
			  a widget allMorphs
				  detect: [ :m | m class name = #SpFTTableMorph ]
				  ifNone: [ nil ] ]
]

{ #category : 'private - scrolling' }
SpClassDiffPresenter >> syncScrollFromSource [

	isSyncingScroll ifTrue: [ ^ self ].
	self sourceTableMorph ifNotNil: [ :src |
			self targetTableMorph ifNotNil: [ :tgt |
					isSyncingScroll := true.
					[ tgt moveShowIndexTo: src showIndex ] ensure: [
						isSyncingScroll := false ] ] ]
]

{ #category : 'private - scrolling' }
SpClassDiffPresenter >> syncScrollFromTarget [

	isSyncingScroll ifTrue: [ ^ self ].
	self targetTableMorph ifNotNil: [ :tgt |
			self sourceTableMorph ifNotNil: [ :src |
					isSyncingScroll := true.
					[ src moveShowIndexTo: tgt showIndex ] ensure: [
						isSyncingScroll := false ] ] ]
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClass [

	^ targetClass
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClass: aClass [

	targetClass := aClass.
	targetClass ifNotNil: [
		targetClassListPresenter headerTitle: targetClass name ].
	self updateAlignment
]

{ #category : 'accessing' }
SpClassDiffPresenter >> targetClassListPresenter [

	^ targetClassListPresenter
]

{ #category : 'private - scrolling' }
SpClassDiffPresenter >> targetTableMorph [

	^ targetClassListPresenter withAdapterDo: [ :a |
			  a widget allMorphs
				  detect: [ :m | m class name = #SpFTTableMorph ]
				  ifNone: [ nil ] ]
]

{ #category : 'updating' }
SpClassDiffPresenter >> updateAlignment [
	"Align or re-align the source and target classes and update the presenters"

	(self sourceClass isNil or: [ self targetClass isNil ]) ifTrue: [
		^ self ].
	self aligner
		align: self sourceClass selectors sort
		with: self targetClass selectors sort.
	self sourceClassListPresenter items: self aligner firstSequence.
	self targetClassListPresenter items: self aligner secondSequence.
	self withWindowDo: [ :w | w title: self updatedTitle ]
]

{ #category : 'updating' }
SpClassDiffPresenter >> updateSelectionFromSource: selector [

	| aMethod |
	selector = self aligner gapCharacter ifTrue: [ ^ String empty ].
	(self sourceClass isNil or: [
		 (self sourceClass canUnderstand: selector) not ]) ifTrue: [
			sourceMethodPresenter text: String empty.
			^ String empty ].
	targetClassListPresenter selectItem: selector.
	aMethod := self sourceClass >> selector.
	sourceMethodPresenter beForMethod: aMethod.
	^ aMethod sourceCode
]

{ #category : 'updating' }
SpClassDiffPresenter >> updateSelectionFromTarget: selector [

	| aMethod |
	selector = self aligner gapCharacter ifTrue: [ ^ String empty ].
	(self targetClass isNil or: [
		 (self targetClass canUnderstand: selector) not ]) ifTrue: [
			targetMethodPresenter text: String empty.
			^ String empty ].
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

{ #category : 'private - scrolling' }
SpClassDiffPresenter >> wrapVerticalScrollBarOn: table [

	| interceptor |
	interceptor := SpClassDiffScrollBarInterceptor new
		               table: table
		               originalModel: table
		               scrollSyncSelector: #syncScrollFromSource.
	table verticalScrollBar
		model: interceptor;
		setValueSelector: #verticalScrollBarValue:
]

{ #category : 'private - scrolling' }
SpClassDiffPresenter >> wrapVerticalScrollBarOn: table syncBlock: aBlock [

	| interceptor |
	interceptor := SpClassDiffScrollBarInterceptor new
		               table: table
		               originalModel: table
		               scrollSyncBlock: aBlock.
	table verticalScrollBar
		model: interceptor;
		setValueSelector: #verticalScrollBarValue:
]
