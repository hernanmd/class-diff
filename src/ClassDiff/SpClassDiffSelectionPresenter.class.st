"
A class diference presenter which enables to select both target and source classes interactively.
"
Class {
	#name : 'SpClassDiffSelectionPresenter',
	#superclass : 'SpClassDiffPresenter',
	#instVars : [
		'sourceClassSelectorPresenter',
		'targetClassSelectorPresenter'
	],
	#category : 'ClassDiff',
	#package : 'ClassDiff'
}

{ #category : 'instance creation' }
SpClassDiffSelectionPresenter class >> open [
	<script>

	^ self new open
]

{ #category : 'instance creation' }
SpClassDiffSelectionPresenter class >> openExample [
	<script>

	^ self new 
		sourceClass: OrderedCollection;
		targetClass: LinkedList;
		open
]

{ #category : 'layout' }
SpClassDiffSelectionPresenter >> defaultLayout [ 

	^ SpBoxLayout newLeftToRight 
		spacing: 3;	
		add: (SpBoxLayout newTopToBottom
			spacing: 3;		
			add: sourceClassSelectorPresenter expand: false;
			add: sourceClassListPresenter;
			add: sourceMethodPresenter;
			yourself);
		add: (SpBoxLayout newTopToBottom
			spacing: 3;		
			add: targetClassSelectorPresenter expand: false;
			add: targetClassPresenter;
			add: targetMethodPresenter;			
			yourself);
		yourself
]

{ #category : 'initialization' }
SpClassDiffSelectionPresenter >> initializePresenters [

	super initializePresenters.
	self initializeSelectorPresenters.


]

{ #category : 'initialization' }
SpClassDiffSelectionPresenter >> initializeSelectorPresenters [

	sourceClassSelectorPresenter := (self instantiate: SpSelectEntity) 
		selectDialog: [ SpListPresenter new
				items: Smalltalk globals allClasses;
				yourself ];
		displaySymbol: #name;
		placeholder: 'Source class';
		possibleEntities: [ Smalltalk globals allClasses ];
		whenEntityChanged:	[ : entity | 
			self sourceClass: entity.
			self updateAlignment. ]
		yourself.

	targetClassSelectorPresenter := (self instantiate: SpSelectEntity) 
		selectDialog: [ SpListPresenter new
				items: Smalltalk globals allClasses;
				yourself ];
		displaySymbol: #name;
		placeholder: 'Target class';
		possibleEntities: [ Smalltalk globals allClasses ];
		whenEntityChanged:	[ : entity | 
			self targetClass: entity.
			self updateAlignment. ]		
		yourself.
]
