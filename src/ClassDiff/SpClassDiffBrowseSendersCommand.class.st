"
Command to browse all senders of the selected selector. Part of the ClassDiff context menu.
"
Class {
	#name : 'SpClassDiffBrowseSendersCommand',
	#superclass : 'CmCommand',
	#category : 'ClassDiff-Commands',
	#package : 'ClassDiff',
	#tag : 'Commands'
}

{ #category : 'accessing' }
SpClassDiffBrowseSendersCommand >> description [ ^ 'Browse all senders of the selected selector'
]

{ #category : 'executing' }
SpClassDiffBrowseSendersCommand >> execute [ self context doBrowseSenders
]

{ #category : 'accessing' }
SpClassDiffBrowseSendersCommand >> name [ ^ 'Browse senders'
]
