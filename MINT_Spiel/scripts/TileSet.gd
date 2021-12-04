tool
extends TileSet

const GRAS = 0
const DIRT = 1
const GLIBBER = 12
const SPIKES = 13

var binds = [GRAS, DIRT, GLIBBER, SPIKES]

func _is_tile_bound(id, neighbour_id):
	return id in binds and neighbour_id in binds
