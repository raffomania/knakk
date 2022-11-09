# Clever Solitaire

todo: reorder functions in all scripts for readability

## Topics

### Camera

- Used to center the field on the screen

### UI

- default_theme set in project settings

### Animations

- Camera screen transition

### Tweens

- Card dragging and transitions

### Static Types

- can't use them for nullable variables yet

### Coroutines

### Particles

### Responsiveness

- Generate font mipmaps for various screen sizes
- todo Which settings in display/window to use

### Touch Input

- Set "emulate touch input using mouse" in the project settings to work with the mouse as well
- Use motion smoothing in `Card.gd` to make card dragging feel more natural

### GitHub Actions

### Other tweaks

### Code style

- function ordering
- [Official GDScript Style Guide](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [GDQuest GDScript Style Guide](https://www.gdquest.com/docs/guidelines/best-practices/godot-gdscript/)

## Considerations

- How to handle propagation and capturing of click events?
- How to represent a single card value?