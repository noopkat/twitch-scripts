------------------------------------
-- CHROME WINDOWS SETUP --
------------------------------------

set chromeWindows to {Â
	{location:"https://streamlabs.com/alert-box/v3/abc123", bounds:{0, 1200, 1740, 1440}}, Â
	{location:"https://streamlabs.com/widgets/event-list/v1/abc123", bounds:{2220, 200, 2520, 400}}, Â
	{location:"https://www.twitch.tv/popout/noopkat/chat?popout=", bounds:{1742, 0, 2200, 1150}}, Â
	{location:"https://octobox.io", bounds:{0, 0, 1738, 1173}} Â
		}

-- open all needed stream windows in chrome
tell application "Google Chrome"
	-- first hide the current window because it's my own personal tabs
	set minimized of window 1 to true
	
	-- loop through all windows and pop them up
	repeat with win in chromeWindows
		make new window
		open location location of win
		set bounds of front window to bounds of win
	end repeat
end tell

----------------------
-- ITERM2 SETUP --
----------------------

-- first hide the current iTerm2 window because it's my own personal tabs
tell application "iTerm" to set miniaturized of window 1 to true

-- tell iterm2 to open up the preconfigured window arrangement for streaming
tell application "System Events"
	tell process "iTerm2"
		click menu item "vim-streaming-full-2" of menu of menu item "Restore Window Arrangement" of menu "Window" of menu bar 1
	end tell
end tell

--------------------------------
-- SOUND OUTPUT SETUP --
--------------------------------

-- switch sound output to custom multi-output device 'Twitch Personal' 
tell application "System Preferences"
	reveal anchor "output" of pane id "com.apple.preference.sound"
	activate
end tell

tell application "System Events"
	tell application process "System Preferences"
		tell tab group 1 of window "Sound"
			select (row 1 of table 1 of scroll area 1 where value of text field 1 is "Twitch Personal")
		end tell
	end tell
end tell
quit application "System Preferences"

-- open itunes and play the 'twitch' playlist
tell application "iTunes"
	activate
	play user playlist "twitch"
end tell

-- position itunes in the bottom right corner
tell application "System Events" to tell process "iTunes"
	set position of window 1 to {2220, 1200}
end tell


--------------------------------
-- STREAM TOOL STARTUP --
--------------------------------

-- start StreamLabels and minimise it
tell application "StreamLabels" to activate

tell application "StreamLabels"
	-- electron apps are not scriptable so we send a keyboard shortcut instead
	tell application "System Events" to keystroke "m" using command down
end tell


---------------------------------------------------
-- NIGHTBOT CUSTOM COMMAND SETTING --
---------------------------------------------------

-- fetch last Nightbot !whatamidoing status
set lastStatus to (do shell script "/Users/noopkat/bin/twitch-scripts/getNightbotStatus.sh")

-- prompt for Nighbot !whatamidoing command status
set nightbotStatus to the text returned of (display dialog "What are you working on today?" default answer lastStatus)

-- send new status to Nightbot
set nightbotResult to do shell script ("/Users/noopkat/bin/twitch-scripts/setNightbotStatus.sh \"" & nightbotStatus & "\"")

display notification nightbotResult with title "Nightbot Status" sound name "Glass"


