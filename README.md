![preview](https://i.imgur.com/frnUkkF.png)
![preview](https://i.imgur.com/lmZKqA0.png)
# Supported databases
* [MySQLOO](https://github.com/FredyH/MySQLOO/releases/)
* Firebase
* SQLite
# Commands
<details>
<summary>Click me!</summary>
xpa info<br>
xpa menu<br>
xpa finder<br>
<br>
xpa ban [steamid/name/uid]<br>
xpa unban [steamid/name/uid]<br>
xpa kick [steamid/name/uid]<br>
<br>
xpa gag [steamid/name/uid]<br>
xpa ungag [steamid/name/uid]<br>
xpa mute [steamid/name/uid]<br>
xpa unmute [steamid/name/uid]<br>
<br>
xpa teleport [steamid/name/uid]<br>
xpa goto [steamid/name/uid]<br>
xpa return [steamid/name/uid]<br>
<br>
xpa hp [steamid/name/uid> [number]<br>
xpa gethp [steamid/name/uid]<br>
xpa ar [steamid/name/uid] [number]<br>
xpa getar [steamid/name/uid]<br>
xpa weapon [steamid/name/uid] <classname><br>
xpa fs [steamid/name/uid]<br>
xpa noclip<br>
xpa cloak<br>
<br>
xpa jail [steamid/name/uid] [time]<br>
xpa unjail [steamid/name/uid]<br>
xpa ignite [steamid/name/uid] [time]<br>
xpa unignite [steamid/name/uid]<br>
xpa slay [steamid/name/uid]<br>
xpa freeze [steamid/name/uid]<br>
xpa unfreeze [steamid/name/uid]<br>
<br>
xpa setrank [steamid/name/uid] [rank]<br>
xpa rcon [...]<br>
xpa map [mapname]<br>
xpa maplist<br>
xpa teamlist<br>
<br>
xpa votekick [steamid/name/uid]<br>
xpa votemap [mapname]<br>
<br>
xpa hg [steamid/name/uid] [number]<br>
xpa setjob [steamid/name/uid] [team]<br>
xpa arrest [steamid/name/uid] [time]<br>
xpa unarrest [steamid/name/uid]<br>
xpa pban [steamid/name/uid]<br>
xpa unpban [steamid/name/uid]<br>
</details>

# Library
<details>
<summary>Click me!</summary>
SHARED ENTITY:SetSimpleTimer(INTEGER delay, FUNCTION func)<br>
SHARED ENTITY:SetTimer(STRING identifier, INTEGER delay, INTEGER repetitions, FUNCTION func)<br>
SHARED ENTITY:RemoveTimer(STRING identifier)<br>
SHARED ENTITY:TimerExists(STRING identifier) /// > BOOLEAN<br>
<br>
SHARED XPA.IncludeCompounded(STRING path)<br>
SERVER XPA.AddResourceDir(STRING path)<br>
<br>
SHARED XPA.FindPlayer(STRING steamid / STRING name / INTEGER uid) /// > ENTITY<br>
SHARED XPA.FindBiggest(TABLE numbers) /// > INTEGER<br>
SHARED XPA.FindSmallest(TABLE numbers) /// > INTEGER<br>
<br>
SHARED XPA.IsEmpty(VECTOR pos, VECTOR ignore) /// > BOOLEAN<br>
SHARED XPA.FindEmptyPos(VECTOR pos, TABLE ignore, INTEGER distance, INTEGER step, VECTOR area) /// > VECTOR<br>
<br>
SHARED XPA.NameSortedPlayers() /// > TABLE<br>
SHARED XPA.TeamSortedPlayers() /// > TABLE<br>
SHARED XPA.ParseArgs(STRING str) /// > TABLE<br>
SHARED XPA.ConvertTime(INTEGER time, INTEGER limit) /// > STRING<br>
SHARED XPA.TimeToStr(INTEGER time) /// > STRING<br>
<br>
SHARED XPA.IsValidSteamID(STRING id) /// > BOOLEAN<br>
SHARED XPA.IsValidSteamID64(STRING id) /// > BOOLEAN<br>
<br>
SERVER XPA.MsgC(STRING msg)<br>
SERVER XPA.ChatLog(STRING msg)<br>
SERVER XPA.AChatLog(STRING msg)<br>
SERVER XPA.ChatLogCompounded(STRING adminmsg, STRING usermsg)<br>
SERVER XPA.SendMsg(ENTITY pl, STRING msg)<br>
<br>
SERVER XPA.Ban(STRING id, INTEGER time, STRING reason)<br>
SERVER XPA.Unban(STRING id)<br>
SERVER XPA.IsBanned(STRING id) /// > BOOLEAN<br>
</details>
