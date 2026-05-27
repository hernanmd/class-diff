Class {
	#name : 'SpClassDiffBrowseImplementorsCommand',
	#superclass : 'CmCommand',
	#category : 'ClassDiff-Commands',
	#package : 'ClassDiff',
	#tag : 'Commands'
}

{ #category : 'accessing' }
SpClassDiffBrowseImplementorsCommand >> description [ ^ 'Browse all implementors of the selected selector'
]

{ #category : 'executing' }
SpClassDiffBrowseImplementorsCommand >> execute [ self context doBrowseImplementors
]

{ #category : 'accessing' }
SpClassDiffBrowseImplementorsCommand >> name [ ^ 'Browse implementors'
]
