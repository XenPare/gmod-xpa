# Commands
### Menus
```
xpa info
xpa menu
xpa bans
xpa restrictions
```
### Access
```
xpa ban <steamid/name/uid>
xpa unban <steamid>
xpa kick <steamid/name/uid>
```
### Communication
```
xpa gag <steamid/name/uid>
xpa ungag <steamid/name/uid>
xpa mute <steamid/name/uid>
xpa unmute <steamid/name/uid>
```
### Moving
```
xpa teleport <steamid/name/uid>
xpa goto <steamid/name/uid>
xpa return <steamid/name/uid>
```
### Player
```
xpa hp <steamid/name/uid> <number>
xpa gethp <steamid/name/uid>
xpa ar <steamid/name/uid> <number>
xpa getar <steamid/name/uid>
xpa weapon <steamid/name/uid> <classname>
xpa fs <steamid/name/uid>
xpa noclip
xpa cloak
```
### Punishment
```
xpa jail <steamid/name/uid> <time>
xpa unjail <steamid/name/uid>
xpa ignite <steamid/name/uid> <time>
xpa unignite <steamid/name/uid>
xpa slay <steamid/name/uid>
xpa freeze <steamid/name/uid>
xpa unfreeze <steamid/name/uid>
```
### Server
```
xpa rcon <args>
xpa map <map>
xpa maplist
xpa teamlist
```
### Voting 
##### sandbox/groundcontrol/terrortown/classicjb
```
xpa votekick <steamid/name/uid>
xpa votemap <mapname>
```
### DarkRP
##### darkrp
```
xpa hg <steamid/name/uid> <number>
xpa setjob <steamid/name/uid> <team index>
xpa arrest <steamid/name/uid> <time>
xpa unarrest <steamid/name/uid>
xpa pban <steamid/name/uid>
xpa unpban <steamid/name/uid>
```

# Library
```lua
XPA.IncludeCompounded(path) > Shared
XPA.AddResourceDir(path) > Server
```
```lua
XPA.FindPlayer(steamid/name/uid) > Shared
XPA.FindBiggest(table num) > Shared
```
```lua
XPA.isEmpty(vector, ignore) > Shared
XPA.findEmptyPos(pos, ignore, distance, step, area) > Shared
```
```lua
XPA.nickSortedPlayers() > Shared
XPA.ParseArgs(str) > Shared
XPA.ConvertTime(num, limit) > Shared
XPA.TimeToStr(time) > Shared
```
```lua
XPA.IsValidSteamID(id) > Shared
XPA.IsValidSteamID64(id) > Shared
```
```lua
XPA.MsgC(str) > Server
XPA.ChatLog(str) > Server
XPA.AChatLog(str) > Server
XPA.ChatLogCompounded(astr, ustr) > Server
XPA.SendMsg(pl, msg) > Server
```
