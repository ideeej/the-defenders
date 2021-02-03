extends CollisionShape2D


var width : float
var height: float

func setup_extents(width, height):
	self.width = width
	self.height = height
	
	self.shape = RectangleShape2D.new()
	self.shape.extents = Vector2(self.width, self.height)
	
	
