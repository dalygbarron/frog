# Represents an item that can be held in an inventory or somewhere.

extends Resource
class_name Item

# Types of usage. None means it can't be used directly by the user. Menu means
# it can be used directly from a menu by clicking it, and active means it can
# be equipped by the user and used inside the game world.
enum Usage {
    NONE,
    MENU,
    ACTIVE    
}

# Different tags holdables can be given to differentiate them.
enum Tag {
    MAIN,
    TAPE,
    ESKY
}

# User facing name for the item
export(String) var display_name = "NA"

# Image to show for the item in guis and stuff
export(Texture) var icon: Texture = null

# Which defines how / where the item will be shown
export(Tag) var tag = Tag.MAIN

# Defines how the item can be used
export(Usage) var usage = Usage.NONE
