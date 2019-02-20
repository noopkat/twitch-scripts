on is_running(appName)
	tell application "System Events" to (name of processes) contains appName
end is_running


set iTunesRunning to is_running("iTunes")
set noMusic to "no music is playing"
set song to noMusic

if iTunesRunning then
	set song to run script "tell application \"iTunes\" to if player state is playing then \"now playing: \" & name of current track & \" by \" & artist of current track"
	try
		song
		return song
	on error
		return noMusic
	end try
else
	return noMusic
end if
