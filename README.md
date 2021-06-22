# Commands
### Menus
```
xpa info
xpa menu
xpa finder
```
### Access
```
xpa ban <steamid/name/uid>
xpa unban <steamid/name/uid>
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
xpa rcon <...>
xpa map <mapname>
xpa maplist
xpa teamlist
```
### Voting 
##### sandbox/groundcontrol/terrortown/classicjb/fbl
```
xpa votekick <steamid/name/uid>
xpa votemap <STRING mapname>
```
### DarkRP
##### darkrp
```
xpa hg <steamid/name/uid> <number>
xpa setjob <steamid/name/uid> <team>
xpa arrest <steamid/name/uid> <time>
xpa unarrest <steamid/name/uid>
xpa pban <steamid/name/uid>
xpa unpban <steamid/name/uid>
```

# Library
```lua
SHARED ENTITY:SetSimpleTimer(INTEGER delay, FUNCTION func)
SHARED ENTITY:SetTimer(STRING identifier, INTEGER delay, INTEGER repetitions, FUNCTION func)
SHARED ENTITY:RemoveTimer(STRING identifier)
SHARED ENTITY:TimerExists(STRING identifier) /// > BOOLEAN
```
```lua
SHARED XPA.IncludeCompounded(STRING path)
SERVER XPA.AddResourceDir(STRING path)
```
```lua
SHARED XPA.FindPlayer(STRING steamid / STRING name / INTEGER uid) /// > ENTITY 
SHARED XPA.FindBiggest(TABLE numbers) /// > INTEGER
SHARED XPA.FindSmallest(TABLE numbers) /// > INTEGER
```
```lua
SHARED XPA.isEmpty(VECTOR pos, VECTOR ignore) /// > BOOLEAN
SHARED XPA.findEmptyPos(VECTOR pos, TABLE ignore, INTEGER distance, INTEGER step, VECTOR area) /// > VECTOR
```
```lua
SHARED XPA.nickSortedPlayers() /// > TABLE
SHARED XPA.ParseArgs(STRING str) /// > TABLE
SHARED XPA.ConvertTime(INTEGER time, INTEGER limit) /// > STRING
SHARED XPA.TimeToStr(INTEGER time) /// > STRING
```
```lua
SHARED XPA.IsValidSteamID(STRING id) /// > BOOLEAN
SHARED XPA.IsValidSteamID64(STRING id) /// > BOOLEAN
```
```lua
SERVER XPA.MsgC(STRING msg)
SERVER XPA.ChatLog(STRING msg)
SERVER XPA.AChatLog(STRING msg)
SERVER XPA.ChatLogCompounded(STRING adminmsg, STRING usermsg)
SERVER XPA.SendMsg(ENTITY pl, STRING msg)
```
```lua
SERVER XPA.Ban(STRING id, INTEGER time, STRING reason)
SERVER XPA.Unban(STRING id)
SERVER XPA.IsBanned(STRING id) /// > BOOLEAN
```