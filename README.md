# Transformice #utility 2.0

The source code for the second major version of Transformice module [#utility](http://atelier801.com/topic?f=6&t=451941).

**This code will not run properly except for members of the [Module Team](http://atelier801.com/topic?f=5&t=691642).**

## Segments

It was designed to be a large project where "segments" can be dynamically loaded in and out, allowing for parts of other modules and tools to be loaded when needed, yet not take runtime when unnecessary.

In #utility, this lets the player use whatever they want to have fun with at any given time without restraint, potentially even coming up with their own game modes using the available features.

This concept also allows for segments to be launched at the beginning of the module's runtime, creating a module with its own unique gameplay but maintaining a single code base. Some examples of other modules that can be created using segments:
- **#pictionary** - Using the `draw` segment to allow drawing with colorjoints on the map.
- **#prophunt** - Using the `images` segment to allow a player to become an image, the `hide` segment to hide their player from the map, and the `prophunt` segment to set their image to nearby props on the map.
- **#retro** - The map rotation and map XML helpers allow for dynamically loading in background images for maps, which opens up the possibility for recreating maps using the game's old graphics. Additional segments can enable individual event maps' functionality, such as `movecheese` to move the cheese's position on the map every time someone gets it, `nogravmove` to move in 0 gravity, and `images` to get a fake broomstick, which when put together can create the Halloween 2010 event map.
