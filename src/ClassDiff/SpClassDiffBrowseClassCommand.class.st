Class {
	#name : 'SpClassDiffBrowseClassCommand',
	#superclass : 'CmCommand',
	#category : 'ClassDiff-Commands',
	#package : 'ClassDiff',
	#tag : 'Commands'
}

{ #category : 'converting' }
SpClassDiffBrowseClassCommand >> asSpecCommand [ ^ super asSpecCommand name: 'Browse class'; iconName: #browser; shortcutKey: $b meta; yourself
]

{ #category : 'accessing' }
SpClassDiffBrowseClassCommand >> description [ ^ 'Browse the selected class'
]

{ #category : 'executing' }
SpClassDiffBrowseClassCommand >> execute [ self context doBrowseClass
]

{ #category : 'accessing' }
SpClassDiffBrowseClassCommand >> name [ ^ 'Browse class'
]
