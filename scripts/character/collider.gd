extends CollisionShape2D


func setup_extents(width, height):
	self.shape = RectangleShape2D.new()
	self.shape.extents = Vector2(width, height)
