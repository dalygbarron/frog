class_name Fish
extends Node

export(String) var display_name
export(Texture) var texture: Texture
export(String, MULTILINE) var description
export(float) var weight_average: float = 1.0
export(float) var weight_deviation: float = 0.2
export(float) var hit_time: float = 2.0
export(float) var timidity: float = 0.5
export(float) var fillet_size: float = 0.25
var _random = RandomNumberGenerator.new()

func create_instance():
    var weight: float = _random.randfn(weight_average, weight_deviation)
    var gender = FishInstance.Gender.MALE if randi() % 2 == 0 else \
        FishInstance.Gender.FEMALE
    return FishInstance.new(self, weight, gender)

class FishInstance:
    enum Gender {
        FEMALE,
        MALE
    }

    var type: Fish
    var weight: float
    var _gender

    func _init(type: Fish, weight: float, gender):
        self.type = type
        self.weight = weight
        _gender = gender

    func hit_threshold():
        return ceil(weight / 0.06)

    func get_gender() -> String:
        return "male" if _gender == Gender.MALE else "female"

    func get_display_name() -> String:
        return "%.2fkg %s %s" % [weight, get_gender(), type.display_name]

    func get_fillet_count() -> int:
        return ceil(weight / type.fillet_size) as int

    func to_holdable() -> FishHoldable:
        return FishHoldable.new(self)

class FishHoldable extends Holdable:
    var fish_instance: FishInstance

    func _init(fish_instance: FishInstance):
        self.fish_instance = fish_instance

    func get_display_name() -> String:
        return fish_instance.get_display_name()

    func get_technical_name() -> String:
        return fish_instance.type.name

    func get_tag():
        return Holdable.Tag.ESKY

    func get_icon() -> Texture:
        return fish_instance.type.texture

    func get_description() -> String:
        return fish_instance.type.description

    func get_active() -> bool:
        return true

    func get_verb() -> String:
        return "Butcher"
