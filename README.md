![preview](https://i.imgur.com/frnUkkF.png)
![preview](https://i.imgur.com/lmZKqA0.png)
# Supported databases
* [MySQLOO](https://github.com/FredyH/MySQLOO/releases/)
* Firebase
* SQLite
# Commands
<details>
<summary>Click me!</summary>
* Menus:
<br>
xpa info<br>
xpa menu<br>
xpa finder<br>
<br>
* Communication:
<br>
xpa gag [steamid/name/uid]<br>
xpa ungag [steamid/name/uid]<br>
xpa mute [steamid/name/uid]<br>
xpa unmute [steamid/name/uid]<br>
<br>
* Moving:
<br>
xpa teleport [steamid/name/uid]<br>
xpa goto [steamid/name/uid]<br>
xpa return [steamid/name/uid]<br>
<br>
* Player:
<br>
xpa hp [steamid/name/uid> [number]<br>
xpa gethp [steamid/name/uid]<br>
xpa ar [steamid/name/uid] [number]<br>
xpa getar [steamid/name/uid]<br>
xpa weapon [steamid/name/uid] <classname><br>
xpa fs [steamid/name/uid] (family sharing check)<br>
xpa noclip<br>
xpa cloak<br>
<br>
* Punishment:
<br>
xpa ban [steamid/name/uid]<br>
xpa unban [steamid/name/uid]<br>
xpa kick [steamid/name/uid]<br>
xpa jail [steamid/name/uid] [time]<br>
xpa unjail [steamid/name/uid]<br>
xpa ignite [steamid/name/uid] [time]<br>
xpa unignite [steamid/name/uid]<br>
xpa slay [steamid/name/uid]<br>
xpa freeze [steamid/name/uid]<br>
xpa unfreeze [steamid/name/uid]<br>
<br>
* Server:
<br>
xpa setrank [steamid/name/uid] [rank]<br>
xpa rcon [...]<br>
xpa map [mapname]<br>
xpa maplist (print a server map list)<br>
xpa teamlist (print a server team list)<br>
<br>
* Voting:
<br>
xpa votekick [steamid/name/uid]<br>
xpa votemap [mapname]<br>
<br>
* DarkRP:
<br>
xpa hg [steamid/name/uid] [number]<br>
xpa setjob [steamid/name/uid] [team]<br>
xpa arrest [steamid/name/uid] [time]<br>
xpa unarrest [steamid/name/uid]<br>
xpa pban [steamid/name/uid] (police team ban)<br>
xpa unpban [steamid/name/uid] (police team unban)<br>
</details>

# Library
<details>
<summary>Click me!</summary>
[sh] [no return] Entity:SetSimpleTimer(number delay, function func)<br>
[sh] [no return] Entity:SetTimer(string identifier, number delay, number repetitions, function func)<br>
[sh] [no return] Entity:RemoveTimer(string identifier)<br>
[sh] [boolean] Entity:TimerExists(string identifier)<br>
<br>
[sh] [no return] XPA.IncludeCompounded(string path)<br>
[sh] [no return] XPA.AddResourceDir(string path)<br>
<br>
[sh] [entity] XPA.FindPlayer(string id)<br>
[sh] [number] XPA.FindBiggest(table numbers)<br>
[sh] [number] XPA.FindSmallest(table numbers)<br>
<br>
[sh] [boolean] XPA.IsEmpty(vector pos, vector ignore)<br>
[sh] [vector] XPA.FindEmptyPos(vector pos, table ignore, number distance, number step, vector area)<br>
<br>
[sh] [table] XPA.NameSortedPlayers()<br>
[sh] [table] XPA.TeamSortedPlayers()<br>
[sh] [table] XPA.ParseArgs(string str)<br>
[sh] [string] XPA.ConvertTime(number time, number limit)<br>
[sh] [string] XPA.TimeToStr(number time)<br>
<br>
[sh] [boolean] XPA.IsValidSteamID(string id)<br>
[sh] [boolean] XPA.IsValidSteamID64(string id)<br>
<br>
[sv] [no return] XPA.MsgC(string msg)<br>
[sv] [no return] XPA.ChatLog(string msg)<br>
[sv] [no return] XPA.AChatLog(string msg)<br>
[sv] [no return] XPA.ChatLogCompounded(string adminmsg, string usermsg)<br>
[sv] [no return] XPA.SendMsg(entity pl, string msg)<br>
<br>
[sv] [no return] XPA.Ban(string id, number time, string reason)<br>
[sv] [no return] XPA.Unban(string id)<br>
[sv] [boolean] XPA.IsBanned(string id)<br>
</details>
