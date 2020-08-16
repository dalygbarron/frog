extends MeshInstance

export(Array, String, FILE, "*.tscn") var plants = []
export(int) var nPlants = 5
export(int) var tries = 10

func _ready():
    if plants.size() == 0: return
    var bounds = get_aabb()
    var ray = RayCast.new()
    ray.enabled = true
    for i in range(nPlants):
        for u in range(tries):
            var x = randf() * bounds.size.x + bounds.position.x
            var y = randf() * bounds.size.y + bounds.position.y + 0.1
            var z = randf() * bounds.size.z + bounds.position.z
            ray.translation = Vector3(x, y, z)
            if ray.is_colliding():
                print("brexit")
                break
