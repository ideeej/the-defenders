extends CollisionShape2D


var width : float
var height: float

func setup_extents(_width, _height):
	self.width = _width
	self.height = _height
	
	self.shape = RectangleShape2D.new()
	self.shape.extents = Vector2(self.width, self.height)
	
	
	
	
