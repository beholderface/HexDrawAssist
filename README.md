# HexDrawAssist
An AutoHotKey script designed to make Hex Casting more accessible.

Requires AutoHotKey v2.

Once you have AHK v2 installed, just run the script file (`HexDrawAssist.ahk`) and it'll do its thing.

To use the script, you press X while your cursor is right next to a dot on the hex grid. The script will simulate your right mouse button being held down, until you press X again or move your cursor off of the Minecraft window. While your cursor is on the Minecraft window, you can also press TAB + W to close the script entirely. If the script ever detects that a Minecraft window does not exist, it will automatically close.

For whatever reason, the script does not work well at all if you are using fullscreen mode, so I recommend setting your Minecraft to windowed mode, ideally as large a window as possible.

Note that the script detects hex grid dots based solely on your cursor being near the correct color, so if something in your world is the exact right color it may get false positives sometimes. Similarly, it detects the Minecraft window based on its `javaw.exe` process name, so other Java-based apps may confuse it. Sadly, I do not know a better way to detect whether a given window is Minecraft, as many modpacks change the window name.

Many of the details I mentioned are configurable in the upper section of the script file, just open it in any text editor.
