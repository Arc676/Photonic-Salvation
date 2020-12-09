# Copyright (C) 2020 Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation (version 3)

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

extends Control

onready var tree = get_tree()
onready var pauseMenu = $"."

func _process(_delta):
	if Input.is_action_just_released("ui_cancel"):
		tree.paused = !tree.paused
		pauseMenu.visible = tree.paused
		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE if tree.paused else
			Input.MOUSE_MODE_CAPTURED
		)

func backToMain():
	Scores.saveScores()
	tree.paused = false
	tree.change_scene("res://Scenes/Main Menu.tscn")
