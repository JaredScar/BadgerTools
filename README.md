# BadgerTools
## This script is discontinued, please use the revamped version listed below
https://github.com/TheWolfBadger/BadgerTools-Revamped

**Version 1.0**

This script took a lot of time and I was considering only keeping it for my server, but I decided to let everyone get a chance to use it. Because of that, I would really appreciate a favorite and/or a appreciative comment. Thank you.

Welcome to BadgerTools! The administration tool for server owners that you've all been looking for! One of the most useful features being /spectate in which you can cycle spectating through players on the server and also hear everything said whilst spectating and being able to speak the user you are spectating! I hope you all enjoy! :)

**IMPORTANT**

You must set up IllusiveTea’s discord_perms script for this to work properly. --> [Discord roles for permissions (im creative, i know)](https://forum.fivem.net/t/discord-roles-for-permissions-im-creative-i-know/233805)

You also must have my DiscordTagIDs script properly installed --> https://forum.fivem.net/t/discordtagids-i-know-i-know-i-only-make-discord-based-scripts/582513

MAKE SURE YOU DISABLE vMenu VOICE CHAT OTHERWISE YOU WILL RUN INTO PROBLEMS

_Example:_
```
####################################
#     VOICE CHAT OPTIONS MENU      #
####################################
# To disable vMenu's voice chat options, simply remove this section completely and vMenu won't touch voice chat at all.
#add_ace builtin.everyone "vMenu.VoiceChat.Menu" allow
#add_ace builtin.everyone "vMenu.VoiceChat.All" allow
add_ace builtin.everyone "vMenu.VoiceChat.Enable" deny
#add_ace builtin.everyone "vMenu.VoiceChat.ShowSpeaker" allow
add_ace builtin.everyone "vMenu.VoiceChat.ShowSpeaker" deny

# Staff voice channel is restricted to moderators/admins by default.
#add_ace group.moderator "vMenu.VoiceChat.StaffChannel" allow
#add_ace group.trialModerator "vMenu.VoiceChat.StaffChannel" allow
#add_ace group.admin "vMenu.VoiceChat.StaffChannel" allow
#add_ace group.owner "vMenu.VoiceChat.StaffChannel" allow
```

**What is BadgerTools?**

_BadgerTools is a nifty script that took me a long while to perfect... It's still not perfect and I will continue to optimize it, but it's a very stable state for now. So, basically what BadgerTools is is staff administration tools. Currently it only features a /spectate and /spectate <id> as well as it's own custom voice chat (15 meters voice chat for everyone, customizeable in the future) that replaces vMenu's voice chat. You can cycle through players on the server once in /spectate mode as well by using the left and right arrow keys on your keyboard as well. Simply type /spectate to get out of spectate mode. Whilst you are spectating a player, you can hear all the players they can hear within a 15m radius from them too. You can also speak to the user you are spectating and only they can hear you. What is special about BadgerTools voice chat? Well, you can add tags to currently speaking voice chat. BadgerTools also gets rid of voice chat color tags from a user unless they have a certain rank. It also gets rid of users who are not staff's red colors in their name._

**Screenshots**

**_Spectating_**

https://i.gyazo.com/012f16d990daaefc33b1c4024eb98690.gif

**_Voice Chat_**

As seen in the clip below, rusty-sir has colors in his username, however BadgerTools does not allow his colors to go through to the voice chat since he is not a donator.

https://i.gyazo.com/83dc4b3f6ea2e2ec42139c7c51d43847.gif

**Permission to use BadgerTools commands (just /spectate for now):**

```
BadgerTools.Commands
```

**Configuration for tags**

All you have to worry about for configuration purposes is this section:
```
roleList = {
{0, ""}, -- 1
{577661583497363456, "~g~Donator | "}, -- 3
{577631197987995678, "~r~T-Mod | "}, -- 4
{506211787214159872, "~r~Mod | "}, -- 5
{506212543749029900, "~r~Admin | "}, -- 6
{577966729981067305, "~p~Management | "}, -- 7
{506212786481922058, "~o~Owner | "}, -- 8
}
```
**Configuration for allowing colors in voice chat**

For allowing colors in voice chat name, you use the permission:
```
BadgerTools.Colors
```
For allowing red in voice chat name, you use the permission:
```
BadgerTools.Red
```

**Download**
[BadgerTools](https://github.com/TheWolfBadger/BadgerTools)



**My Other Work**

[DiscordChatRoles](https://forum.fivem.net/t/discordchatroles-release/566338)

[DiscordAcePerms](https://forum.fivem.net/t/discordaceperms-release/573044)

[SandyVehiclesRestrict](https://forum.fivem.net/t/release-sandy-vehicles-restrict/564929)

[DiscordTagIDs](https://forum.fivem.net/t/discordtagids-i-know-i-know-i-only-make-discord-based-scripts/582513)

[DiscordVehiclesRestrict](https://forum.fivem.net/t/discordvehiclesrestrict/599594)

[DiscordPedPerms](https://forum.fivem.net/t/release-discordpedperms/642866)

[BadgerAnims](https://forum.fivem.net/t/release-badgeranims/650517)

[DiscordWeaponPerms](https://forum.fivem.net/t/release-discordweaponperms/664774)
