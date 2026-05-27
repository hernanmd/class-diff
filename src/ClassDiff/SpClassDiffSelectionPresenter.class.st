"
A Spec 2 presenter that extends SpClassDiffPresenter with class selector dropdowns. Users can choose source and target classes from searchable lists, then see the aligned method diff.
"
Class {
	#name : 'SpClassDiffSelectionPresenter',
	#superclass : 'SpClassDiffPresenter',
	#instVars : [
		'sourceClassSelectorPresenter',
		'targetClassSelectorPresenter'
	],
	#category : 'ClassDiff-Spec',
	#package : 'ClassDiff',
	#tag : 'Spec'
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
			add: targetClassListPresenter;
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
		                                selectDialog: [
				                                SpListPresenter new
					                                items: Smalltalk globals allClasses;
					                                "sorted: [ :a :b | a name < b name ];"
					                                yourself ];
		                                displaySymbol: #name;
		                                placeholder: 'Source class';
		                                possibleEntities: [ Smalltalk globals allClasses sorted: [ :a :b | a name < b name ] ];
		                                whenEntityChanged: [ :entity |
		                                self sourceClass: entity ];
		                                yourself.
	targetClassSelectorPresenter := (self instantiate: SpSelectEntity)
		                                selectDialog: [
				                                SpListPresenter new
					                                items: Smalltalk globals allClasses;
					                                "sorted: [ :a :b | a name < b name ];"
					                                yourself ];
		                                displaySymbol: #name;
		                                placeholder: 'Target class';
		                                possibleEntities: [ Smalltalk globals allClasses sorted: [ :a :b | a name < b name ] ];
		                                whenEntityChanged: [ :entity |
		                                self targetClass: entity ];
		                                yourself
]
