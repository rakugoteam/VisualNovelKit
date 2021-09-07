extends AreaButton2D


func _ready():
	connect("pressed", self,"_on_pressed") 

func _on_pressed():
	$Dialogue.start()
