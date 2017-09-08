--[[The library for custom games to use.

--Example data.lon 
{
	name = "Cheer Readers", --Your game name!
	
	nodes = {
		[1] = {
			icon = "icon.png", --Helpful icon for editors
			color = "#FFFFFF", --Helpful color for editors
			
			button = 1 --Button number. Positive is pressed, negative is released.
			weight = 1 --Score of the node when pressed.
			
			cues = {-1,-0.5}, --Adds cues at the specified beat relative to this node.
		}
	}
}



Callbacks: (handled by the game manager)

game.load() --Like Love2d load
game.reset()

game.update(dt) --Like Love2d update
game.draw() --Like Love2d draw

game.press(button) --Callback for a button press. Inverted numbers mean button release.

game.count(count, totalcount) --This activates on every 16th of a beat. Used for bopping and the like.

game.cue(index, node) --Activates on passing a cue for a node. Index is basically the id for the cue, specified in data.lon

game.hit(button, node, accuracy) - Callback for a correct on-time button press.
game.miss(button, node, accuracy) - Callback for when you miss a node entirely.

game.tag(marker) --May be a number for game-specific tags or a string for manager tags (such as tempo change or game change).

game.songfinish(percent) - Callback for when the song finishes. Return a message for playing.

Constants:

for use with game.count or game.cue
COUNT_BEAT = 0
COUNT_OFFBEAT, COUNT_BACKBEAT = 7


Helper functions:
RGE.newSound(name, bpm) --Returns a new sound object. Optionally, you can specify a tempo and it will change the pitch based on the songs current tempo.

]]

--[[
How a game works.

Each game has specified nodes with a set weight.
Then a beatmap is loaded and the weights of all the nodes in the beatmap are added together. Your in-game score is then each node that you press in-time to give you a percentage!
]]