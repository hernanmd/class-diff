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
		add: (SpBoxLayout newTopToBottom
			add: sourceClassSelectorPresenter expand: false;
			add: sourceClassPresenter;
			yourself);
		add: (SpBoxLayout newTopToBottom
			add: targetClassSelectorPresenter expand: false;
			add: targetClassPresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
SpClassDiffSelectionPresenter >> initializePresenters [

	super initializePresenters.
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
