extends CollisionShape2D


func setup_extents(extents):
	shape = RectangleShape2D.new()
	shape.extents = extents
