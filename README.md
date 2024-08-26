![knakk logo](Branding/wide_logo.png)
<br/>
[<img alt="Get it on Google Play" src="Branding/Play%20Store/en_badge_web_generic.png" height="60px" />](https://play.google.com/store/apps/details?id=org.godotengine.knakk)
[<img alt="Available on itch.io" src="Branding/itch-badge.svg" height="60px" />](https://raffomania.itch.io/knakk)

Perfect your strategy and test your luck in knakk - the relaxed flip-and-write game that challenges you to master the art of card play and strategic slot-filling!

## 👟 Downloading and Running

You can [play in your browser](https://knakk-game.netlify.app/) or **get the released game** [on itch.io](https://raffomania.itch.io/knakk) and [on Google Play](https://play.google.com/store/apps/details?id=org.godotengine.knakk).

To **get the source code**, you have multiple options:

- Clone the repository using git (Recommended): You will need [Git LFS](https://git-lfs.com/) to download large assets. After setting it up, you can clone the repository like any other.
- Download the source archive as a [zip file from GitHub](https://github.com/raffomania/knakk/archive/refs/heads/main.zip).

## 📖 Topics Covered in the Code

This game contains many examples that show you how to use Godot's built-in features to build a game. Here is an overview of topics covered and where to find code relevant to each of them.

### 📊 UI

A lot of the game is implemented using custom controls. They are very similar to `Node2D` nodes, but have a `size` property that makes it easy to adapt them to different sizes. One example for this is the [`RewardMarker`](Reward/RewardMarker.gd) node which is used to great effect to show rewards associated with slots on the field, the current score, and the score on the game over screen.

The [`default_theme.tres`](default_theme.tres) file defines font family, font size and button colors for the whole project. It's set in the project settings and applies to all control nodes by default.

The `Hearts` and `Clubs` areas on the playing field use `HBoxContainer`s to automatically lay out their slots in a row. `Diamonds` and `Spades` are similar to a `GridContainer` but contain a custom layout that is tailored to their triangle-shaped grid. 

### 🎥 Camera

The camera is used to transition between the different scenes such as the game itself or the game over scene.
It also centers everything in the middle of the screen when the window's aspect ratio does not match the reference window size.

### 🎞 Animations

The `Camera` node is animated by an `AnimationPlayer` that animates its `offset` and `zoom` properties.

The animation uses Bezier curve tracks for precise control over way the animation feels. You can see the curves by switching to the bezier curve editor in the animation editor.

#### ↔ Tweens

Tweens are used in two situations:

- We don't know the start or end values of an animation in advance. For an example of this, see the `shrink_to_played_size` method in [`Card.gd`](GameScreen/Card/Card.gd). It animates the card's rotation to a random value.
- It's a super simple animation that is more convenient to create with a short line of code. See the `visualize_interaction_state` method in [`Card.gd`](GameScreen/Card/Card.gd) for an example. It sets the card's scale and rotation to constant values but uses a tween to smoothly transition to those values.

#### 🔧 Manual Frame-by-Frame Animation

When cards move around on the board, their movement is smoothed. This is not implemented using a tween but a custom movement step in the `_process` method.
This is to have precise control over the speed and smoothing curve of the movement, and to avoid creating a new tween object every frame when users drag a card.

### ✅ Static Types

The whole codebase uses type annotations to improve autocomplete and catch bugs.

Since there are no nullable types at the time of writing, types that *have* to be null at some point are typed as `Variant`.
This can also be implicit, e.g. `Array[Variant]` being written as just `Array`.

Methods returning nothing are not explicitly annotated using `-> void` to reduce visual clutter, since the overwhelming majority of them returns nothing.

### 📱 Responsiveness

The game is designed for retina screens and consequently has a large reference window size.
To reduce aliasing artifacts when scaling down images and fonts on smaller resolutions, all assets generate mipmaps on import.
This comes at the expense of additional memory usage, but since this project doesn't use a lot of textures, it should be an acceptable tradeoff.

The viewport stretches using the `canvas_items` method, meaning that the viewport changes its resolution to the window size and nodes are rendered using their actual pixel size on screen.
This also reduces aliasing artifacts on smaller screens.

By setting the aspect ratio to `expand`, we allow the game to fill the window with its white background instead of using black bars.

### 👇 Drag and Drop

The "emulate touch input using mouse" project setting allows the code to always work using touchscreen events and still "just work" with a mouse.

The drag-and-drop mechanic in [`Card.gd`](GameScreen/Card/Card.gd) works by capturing all input events and checking whether they apply to the card node that runs the script:

- For a touch start event, if it is inside the card's bounds, set the card's status to "being dragged"
- For a touch movement (`InputEventScreenDrag`), if the card is being dragged, move it to the new finger position
- For a touch stop event, if the card is being dragged and is above a "drop zone", dispatch an action signal to play the card

I noticed that there can be a slight pause between a touch start event and a subsequent touch movement, causing a dragged card to "jump" between its original position and the position indicated by the user's finger.
To prevent that jump, cards always interpolate between their current and their target position, resulting in a quick smooth motion.

### 🖊 Code Style

The code mostly follows the [Official GDScript Style Guide](https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_styleguide.html) and the [GDQuest GDScript Style Guide](https://www.gdquest.com/docs/guidelines/best-practices/godot-gdscript/).

### 🧐 Debugging

There are a few debugging shortcuts that are only enabled in debug mode:

- **R** Draw a new hand without spending a turn
- **O** End the current round
- **Ctrl+O** End the game instantly
- **B** Add a redraw bonus
- **A** Add a play again bonus
- **D** Toggle debug view

### 🏃 Coroutines

There are a couple good usage examples of coroutines:

- [`Main.gd`](Main.gd) and [`Camera.gd`](Global/Camera.gd) use coroutines to wait for camera transitions to complete before performing subsequent actions
- [`Card.gd`](GameScreen/Card/Card.gd) uses coroutines to wait for tweens to finish
- [`MenuScreen.gd`](MenuScreen/MenuScreen.gd), [`Tutorial.gd`](GameScreen/Tutorial.gd) and [`NewRoundAnimation.gd`](GameScreen/NewRoundAnimation.gd) use coroutines to wait for a specified amount of time before doing something

## 🎯 Not Implemented Yet

- A landscape layout: Use Godot's UI features to make the controls automatically resize and reflow depending on different window aspect ratios.
- A highscore system: Use the filesystem abstraction to save, load and show highscores of previous games.

## Releasing a new version

1. Add an entry to `CHANGELOG.md`.
1. Use `just tag-version $VERSION` to write the new version into the export preset configuration.
1. Verify that the build works by running `just export`.
1. Create a new commit: `git commit -m "Version $VERSION"`.
1. Use `git tag $VERSION` to tag that commit with the new version.
1. Use `git push --tags` to push the changes (including your new tag) to export and release the new version via CI.
1. Upload the `.aab` release to the Google Play Store manually.

## FAQ

### Why Is the Release Keystore Checked into the Repo?

This repository uses [git-crypt](https://github.com/AGWA/git-crypt) to encrypt both the keystore and the `.godot/export_credentials.cfg` file. This way, the file contents remain private. 
**Do not add your release keystore or export_credentials.cfg file to your git repository** without encrypting or adding them to your .gitignore!

### What Is the Status of the Project?

As of April 2023, knakk has reached version 1.0 and is playable and polished. We'll keep adding features, our plans for this are outlined in [the roadmap](https://github.com/users/raffomania/projects/1/views/1).

## License

Where not specified otherwise, this project is licensed under the terms of the [MIT License](MIT.txt).

The card graphics found in the [`GameScreen/Card`](GameScreen/Card) directory were designed by Peter Wood and are licensed under the [CC-BY license](https://creativecommons.org/licenses/by/4.0/).

The font files in the [`Fonts`](Fonts) directory belong to the font family [Dosis](https://fonts.google.com/specimen/Dosis), designed by Pablo Impallari, licensed under the [SIL Open Font License](Fonts/OFL.txt).