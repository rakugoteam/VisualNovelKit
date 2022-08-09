extends "res://addons/gd-plug/plug.gd"

func _plugging():
    # Declare your plugins in here with plug(src, args)
    # By default, only "addons/" directory will be installed
    plug("rakugoteam/Emojis-For-Godot", {"include": ["addons", ".import/"]})
    plug("rakugoteam/Godot-Material-Icons", {"include": ["addons", ".import/"]})
    plug("rakugoteam/Rakugo", {"include": ["addons/rakugo", ".import/"]})
    plug("rakugoteam/BaseKit", {
        "include": ["addons/kit", "addons/gd-plug"],
        "exclude": ["addons/kit/plugin.cfg"],
        "install_root": "addons/vnkit"
    })
    
    ## comment-out if of you don't want to update kit itself
    # plug("rakugoteam/VisualNovelKit")
