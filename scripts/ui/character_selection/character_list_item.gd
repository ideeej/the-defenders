extends Button

var resource : Resource

func setup(_resource):
	icon = _resource.thumbnail
	text = _resource.name
	hint_tooltip = _resource.description
	
	self.resource = _resource
	
