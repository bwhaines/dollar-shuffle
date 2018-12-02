extends Node

# Get file IO functions
const FileIO = preload("res://scripts/file_io.gd")

# Constant file paths
const opts_filepath = "user://options.json"

# GUI objects
onready var back_btn = get_node("back_btn")
onready var diff_sel = get_node("opts_menu_container/difficulty_selector")
onready var darkm_check = get_node("opts_menu_container/darkmode_check")
onready var reset_btn = get_node("opts_menu_container/reset")

# Menu text arrays
var diff_array = ["Easy", "Medium", "Hard"]

# Saved options
var pers_opts;

func _ready():
	# Get saved options (if they exist)
	if File.new().file_exists(opts_filepath):
		pers_opts = FileIO.read_json_file(opts_filepath)
	else:
		set_defaults()
	# Connect back button to close function
	back_btn.connect("pressed", self, "close_menu")
	# Setup option UIs
	setup_diff_picker()
	darkm_check.set_pressed(pers_opts["darkmode"])
	# Connect options UIs to respective functions
	diff_sel.connect("item_selected", self, "on_diff_selected")
	darkm_check.connect("pressed", self, "on_darkm_selected")
	reset_btn.connect("pressed", self, "set_defaults")

func close_menu():
	# Save options
	FileIO.write_json_file(opts_filepath, pers_opts)
	# Return to main menu
	get_tree().change_scene("res://scenes/main_menu.tscn")

func setup_diff_picker():
	# Add each difficulty to the dropdown
	for item in diff_array:
		diff_sel.add_item(item)
	# Select saved option
	diff_sel.select(pers_opts["difficulty"])

func on_diff_selected(item):
	# Save selected difficulty to pers_opts
	pers_opts["difficulty"] = item

func on_darkm_selected():
	# Save selected boolean to pers_opts
	pers_opts["darkmode"] = darkm_check.is_pressed()

func set_defaults():
	# Write default values to options file
	pers_opts = { "difficulty":0, "darkmode":false }
	FileIO.write_json_file(opts_filepath, pers_opts)
	# Change UI elements to defaults
	diff_sel.select(pers_opts["difficulty"])
	darkm_check.pressed = pers_opts["darkmode"]
