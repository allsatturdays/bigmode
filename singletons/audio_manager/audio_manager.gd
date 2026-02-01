extends Node

@onready var bgm_audio: AudioStreamPlayer = $BGMAudioStreamPlayer
@onready var sfx_audio: AudioStreamPlayer = $SFXAudioStreamPlayer
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var music_bank: AudioBank = $MusicBank
@onready var sound_bank: AudioBank = $SoundBank
@onready var audio_config: ConfigurationAudio = $ConfigurationAudio

func play_music(music: AudioEnum.Music, crossfade: float = 0.0, unique: bool = true ) -> void:
	var music_name: String = AudioEnum.music_name(music)
	#	TODO implement crossfade maybe
	get_bgm_audio_stream(music_name)
	bgm_audio.play()
		

func stop_music() -> void:
	bgm_audio.stop()


# TODO: configure sound bank and audio enum
func play_sfx(sfx: AudioEnum.Sfx) -> void:
	var sfx_name: String = AudioEnum.sfx_name(sfx)
	get_sfx_audio_stream(sfx_name)
	sfx_audio.play()


func get_bgm_audio_stream(track: String):
	var stream_path: String = music_bank.tracks[track]
	var stream_resource: Resource = load(stream_path)
	#var stream = stream_resource.instantiate() as AudioStream
	bgm_audio.stream = stream_resource
	
	
func get_sfx_audio_stream(track: String):
	var stream_path: String = sound_bank.tracks[track]
	var stream_resource: Resource = load(stream_path)
	#var stream = stream_resource.instantiate() as AudioStream
	sfx_audio.stream = stream_resource
	
# TODO: implement low pass filter
func turn_on_low_pass_filter():
	pass
