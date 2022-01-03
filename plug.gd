extends "res://addons/gd-plug/plug.gd"

func _plugging():
    # Declare your plugins in here with plug(src, args)
    # By default, only "addons/" directory will be installed
    plug("rakugoteam/Emojis-For-Godot")
    plug("rakugoteam/Godot-Material-Icons")
    plug("rakugoteam/AdvancedText")
    plug("kameloov/Radial-progress-bar")

    # installing this plugin doesn't work so I have to do it manually 
    # plug("vanskodje-godotengine/godot-plugin-calendar-button")