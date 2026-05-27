Class {
	#name : 'SpClassDiffPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'application'
	],
	#category : 'ClassDiff-Tests',
	#package : 'ClassDiff-Tests'
}

{ #category : 'running' }
SpClassDiffPresenterTest >> setUp [

	super setUp.
	application := SSMApplication new
		               useBackend: #Morphic;
		               yourself
]

{ #category : 'running' }
SpClassDiffPresenterTest >> tearDown [

	application ifNotNil: [ application closeAllWindows ]
]

{ #category : 'tests - creation' }
SpClassDiffPresenterTest >> testPresenterCreation [

	| presenter |
	presenter := application newPresenter: SpClassDiffPresenter.
	self assert: presenter notNil.
	self assert: (presenter isKindOf: SpClassDiffPresenter)
]
