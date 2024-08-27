extends Node

var music_volume: float = 0.3
var sensibility_modifier: float = 1.0
var cookies_found: int = 0
var shadows_on: bool = false
var default_outlines_width: float = 6.0
var fullscreen: bool = false
var half_res: bool = false
var in_game: bool = false # true = in game, false = in menu

@warning_ignore("unused_signal")
signal shadows_changed(new_state: bool)
signal scalling_changed
