extends "res://addons/gd-plug/plug.gd"

func _plugging():
    # Declare your plugins in here with plug(src, args)
    # By default, only "addons/" directory will be installed
    plug("rakugoteam/Emojis-For-Godot")
    plug("rakugoteam/Godot-Material-Icons")
    plug("rakugoteam/AdvancedText")

    # change to this when Rakugo 1.0 is released
    plug("rakugoteam/Rakugo")
    # for now, use the dev version
    # plug("jeremi360/Rakugo")