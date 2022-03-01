extends ProgressBar


func _ready():
	Rakugo.connect('loading', self, 'on_loading')
	self.set_max(1)

func on_loading(progress:float):
	if progress < 1:
		show()
		self.set_value(progress)
	else:
		hide()
