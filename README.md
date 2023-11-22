# HexDrawAssist
An AutoHotKey script designed to make Hex Casting more accessible.

Requires AutoHotKey v2.

Once you have AHK v2 installed, just run the script file (`HexDrawAssist.ahk`) and it'll do its thing.

To use the script, you press X while your cursor is right next to a dot on the hex grid. The script will simulate your right mouse button being held down, until you press X again or move your cursor off of the Minecraft window. While your cursor is on the Minecraft window, you can also press TAB + W to close the script entirely. If the script ever detects that a Minecraft window does not exist, it will automatically close.

The script also has manual anglesig entry, if that's more your style.

Manual anglesig entry works as follows:

Imagine the hex grid rotated so that the dot formerly to the upper right of any other dot (initial dot) is now directly above that dot.
That upper dot is W, and then going clockwise around the initial dot there are E, D, S, A, and Q. This is based on Hexcasting's existing anglesig keyboard analogy.

To start manual anglesig entry, press Z after pressing X. Then, choose a direction to start with.
These directions correspond to the aforementioned dots around the initial dot.
From there, enter whatever anglesig you like (while S does exist internally, here it's just backspace). Just note that I don't currently have a way to detect when an illegal stroke is being made, so
    if you accidentally make one you should hit S or Backspace immediately, as entering more non-backspace angles can cause it to break.
Press X again to finish your pattern.

For whatever reason, the script does not work well at all if you are using fullscreen mode, so I recommend setting your Minecraft to windowed mode, ideally as large a window as possible.

Note that the script detects hex grid dots based solely on your cursor being near the correct color, so if something in your world is the exact right color it may get false positives sometimes. Similarly, it detects the Minecraft window based on its `javaw.exe` process name, so other Java-based apps may confuse it. Sadly, I do not know a better way to detect whether a given window is Minecraft, as many modpacks change the window name.

Many of the details I mentioned are configurable in the upper section of the script file, just open it in any text editor.
