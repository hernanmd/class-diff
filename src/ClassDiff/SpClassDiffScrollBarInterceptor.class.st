"
Proxy object that intercepts verticalScrollBarValue: calls from a ScrollBarMorph to its model (an FTTableMorph). Announces FTScrollingChanged so the ClassDiff presenter can synchronize scroll positions between source and target lists.
"
Class {
	#name : 'SpClassDiffScrollBarInterceptor',
	#superclass : 'Object',
	#instVars : [
		'table',
		'originalModel',
		'scrollSyncBlock'
	],
	#category : 'ClassDiff-Helpers',
	#package : 'ClassDiff',
	#tag : 'Helpers'
}

{ #category : 'handling' }
SpClassDiffScrollBarInterceptor >> doesNotUnderstand: aMessage [ ^ aMessage sendTo: originalModel
]

{ #category : 'initialization' }
SpClassDiffScrollBarInterceptor >> table: aTable originalModel: aModel scrollSyncBlock: aBlock [ table := aTable. originalModel := aModel. scrollSyncBlock := aBlock
]

{ #category : 'scrolling' }
SpClassDiffScrollBarInterceptor >> verticalScrollBarValue: aNumber [ | oldIndex | oldIndex := table showIndex. originalModel verticalScrollBarValue: aNumber. oldIndex = table showIndex ifTrue: [ ^ self ]. table announcer announce: (FTScrollingChanged from: oldIndex to: table showIndex). scrollSyncBlock value
]
