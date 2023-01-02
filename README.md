# Transformice #utility 2.0

The source code for the second major version of Transformice module [#utility](http://atelier801.com/topic?f=6&t=451941).

**This code will not run properly except for members of the [Module Team](http://atelier801.com/topic?f=5&t=691642).**

If you wish to play this module in-game, you can use the semi-official module `#shamousey` by going to `/room #shamousey0[your username]` or in your tribe house with the command `/module #shamousey`

## Segments

Utility 2.0's infrastructure was designed so that "segments" can be dynamically loaded in and out, allowing for parts of other modules and tools to be loaded when needed, yet not take runtime when unnecessary.

In #utility, this lets the player use whatever they want to have fun with at any given time without restraint, potentially even coming up with their own game modes using the available features.

This concept also allows for segments to be launched at the beginning of the module's runtime, creating a module with its own unique gameplay but maintaining a single code base. Some examples of other modules that can be created using segments:
- **#pictionary** - Using the `draw` segment to allow drawing with colorjoints on the map.
- **#prophunt** - Using the `images` segment to allow a player to become an image, the `hide` segment to hide their player from the map, and the `prophunt` segment to set their image to nearby props on the map.
- **#retro** - The map rotation and map XML helpers allow for dynamically loading in background images for maps, which opens up the possibility for recreating maps using the game's old graphics. Additional segments can enable individual event maps' functionality, such as `movecheese` to move the cheese's position on the map every time someone gets it, `nogravmove` to move in 0 gravity, and `images` to get a fake broomstick, which when put together can create the Halloween 2010 event map.

## Building

There is a simple NodeJS build script (in the form of `combine.js`) included in this repository that automatically combines all of the necessary files in the right order, ready to be executed in-game quickly.

To change the list of files and directories to combine when building, or access other build options, you can use `build.js`.

### Getting started with builds

1. Install NodeJS and NPM - https://nodejs.org/

2. From the repository's directory, run the command `npm install` to download dependencies (needed for the watch command)

### Building the script

To do a simple build, run the command `npm run build`

Alternatively, you can watch the `src` directory to automatically build every time a file inside it is changed by running the command `npm run watch`
