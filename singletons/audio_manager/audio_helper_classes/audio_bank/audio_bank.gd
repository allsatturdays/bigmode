class_name AudioBank
extends Node
## A container used to store & group music tracks in your scene.


@export var label: String
@export var bus: String

## The underlying process mode for all tracks played from this bank.
@export var mode: Node.ProcessMode

## The collection of tracks associated with this bank.
@export var tracks: Dictionary
