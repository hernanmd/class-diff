"
Command to browse all references (senders and users) of the selected selector. Part of the ClassDiff context menu.
"
Class {
	#name : 'SpClassDiffBrowseReferencesCommand',
	#superclass : 'CmCommand',
	#category : 'ClassDiff-Commands',
	#package : 'ClassDiff',
	#tag : 'Commands'
}

{ #category : 'accessing' }
SpClassDiffBrowseReferencesCommand >> description [ ^ 'Browse all references of the selected selector'
]

{ #category : 'executing' }
SpClassDiffBrowseReferencesCommand >> execute [ self context doBrowseMethodReferences
]

{ #category : 'accessing' }
SpClassDiffBrowseReferencesCommand >> name [ ^ 'Browse references'
]
