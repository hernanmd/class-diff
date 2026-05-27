Class {
	#name : 'ClassDiffSpApplication',
	#superclass : 'SpApplication',
	#category : 'ClassDiff-Spec',
	#package : 'ClassDiff',
	#tag : 'Spec'
}

{ #category : 'instance creation' }
ClassDiffSpApplication class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'ClassDiff')
		parent: #Tools;
		action: [ ClassDiffSpApplication startApplication ];
		icon: (self iconNamed: self taskbarIconName);
		help: 'Open the Class Diff application'
]

{ #category : 'instance creation' }
ClassDiffSpApplication class >> open [

	^ self new start
]

{ #category : 'instance creation' }
ClassDiffSpApplication class >> startApplication [

	<script>
	ClassDiffSpApplication new start
]

{ #category : 'running' }
ClassDiffSpApplication >> start [

	(self newPresenter: SpClassDiffSelectionPresenter) open
]
