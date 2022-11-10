# Clever Solitaire

## Topics

This game contains many examples that show you how to use Godot's built-in features to build a game. Here is an overview of topics covered and where to find code relevant to each of them.

### Camera

The camera is used to transition between the different scenes such as the game itself or the game over scene.
It also centers everything in the middle of the screen when the window's aspect ratio does not match the reference window size.

### UI

- default_theme set in project settings

A lot of the game is implemented using custom controls. They are very similar to `Node2D` nodes, but have a `size` property that makes it easy to adapt them to different sizes. One example for this is the `RewardMarker` node which is used to great effect to show rewards associated with slots on the field, the current score, and the score on the game over screen.



### Animations

The `Camera` node is animated by an `AnimationPlayer` that animates its `offset` and `zoom` properties.

The animation uses Bezier curve tracks for precise control over way the animation feels. You can see the curves by switching to the bezier curve editor in the animation editor.

#### Tweens

Tweens are used in two situations:

- We don't know the start or end values of an animation in advance. For an example of this, see the `shrink_to_played_size` method in `Card.gd`. It animates the card's rotation to a random value.
- It's a super simple animation that is more convenient to create with a short line of code. See the `visualize_interaction_state` method in `Card.gd` for an example. It sets the card's scale and rotation to constant values but uses a tween to smoothly transition to those values.

#### Smooth movement

When cards move around on the board, their movement is smooth. This is not implemented using a tween but a custom movement step in the `_process` method.
This is to have precise control over the speed and smoothing curve of the movement, and to avoid creating a new tween object every frame when users drag a card.

### Static Types

The whole codebase uses type annotations to improve autocomplete and catch bugs.

Since there are no nullable types at the time of writing, types that *have* to be null at some point are typed as `Variant`.
This can also be implicit, e.g. `Array[Variant]` being written as just `Array`.

Methods returning nothing are not explicitly annotated using `-> void` to reduce visual clutter, since the overwhelming majority of them returns nothing.

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

The code mostly follows [Official GDScript Style Guide](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_styleguide.html) and the [GDQuest GDScript Style Guide](https://www.gdquest.com/docs/guidelines/best-practices/godot-gdscript/).

## Considerations

- How to handle propagation and capturing of click events?
- How to represent a single card value?

## Tasks left for the reader

- Implement a landscape layout. Use godot's UI features to make the controls automatically resize and reflow depending on different window aspect ratios.