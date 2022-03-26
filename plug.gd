extends "res://addons/gd-plug/plug.gd"

func _plugging():
    # Declare your plugins in here with plug(src, args)
    # By default, only "addons/" directory will be installed
    plug("rakugoteam/project-settings-helpers")
    plug("rakugoteam/Emojis-For-Godot", {"include": ["addons/", ".import/"]})
    plug("rakugoteam/Godot-Material-Icons")
    plug("rakugoteam/AdvancedText")
    plug("rakugoteam/Rakugo")
