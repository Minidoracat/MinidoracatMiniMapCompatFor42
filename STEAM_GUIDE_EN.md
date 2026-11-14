<!-- 指南網址：https://steamcommunity.com/sharedfiles/filedetails/?id=3817848926 -->
<!-- Steam guide source (English): the full reference for this mod; the Workshop description only summarizes, requests stay in the original thread. Format and sync: pz-family-docs/release.md「完整說明：Steam 指南」 -->
<!-- 標題：📖 MiniMap - MOD Compatibility Guide: Supported Mods, Multiplayer & FAQ -->
<!-- 摘要：Illustrated guide to the Minidoracat MiniMap MOD Compatibility pack: which third-party mods it supports, what dogs, wolves and horses actually do on the map, NPC colors for Bandits and Project A-Life, map markers for Dynamic Outposts outposts and Random Airdrops airdrops, multiplayer notes, FAQ, original authors and asset boundary, and how support requests are evaluated. -->
=== 🚀 Quick start
[b]繁體中文版：[/b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3817848780]小地圖 - MOD 相容包 完整說明[/url]

The mod on Steam Workshop:
https://steamcommunity.com/sharedfiles/filedetails/?id=3765182411
[olist]
[*] [b]Subscribe and enable[/b]: [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3763913359]Minidoracat MiniMap[/url] (main mod), this pack, and the third-party mod you want supported. In multiplayer, the server must enable all three.
[*] [b]Turn on animal icons[/b]: in the main mod's animal icon settings (they are off by default).
[*] [b]Toggle each one[/b]: "Dogs (loaded nearby)", "Horses (loaded nearby)" and "Wolves (loaded nearby)" appear in the species filter.
[*] [b]NPC colors[/b]: turn on the main mod's "Show zombie dots on the mini-map" (off by default), and NPCs from Bandits and Project A-Life are drawn in their own color among the zombie dots.
[*] [b]Outposts and airdrops[/b]: nothing to set up; with Dynamic Outposts or Random Airdrops HF enabled they show on the mini-map.
[/olist]
[list]
[*] [b]Game version[/b]: follows the main mod (currently Build 42.21.0 or later).
[*] [b]Modes[/b]: works in both singleplayer and multiplayer (Random Airdrops HF itself is singleplayer only).
[/list]
=== 🧰 Currently supported
[table]
[tr][th]Third-party mod[/th][th]Mod ID[/th][th]What it does on the map[/th][th]Icons or color[/th][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3740052292]Companion Dogs [ALPHA][/url][/td][td]CompanionDogs[/td][td]Adds dog and wolf to the species filter[/td][td]Dogs: vanilla paw-print symbol, this pack's colored dog icon; wolves: this pack's wolf-head symbol and colored wolf icon[/td][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod [B42.14+/MP SOON][/url][/td][td]Horse[/td][td]Adds horse to the species filter[/td][td]This pack's horse-head symbol and colored horse icon[/td][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3268487204][B42] Bandits NPC[/url][/td][td]Bandits2[/td][td]Colors its NPCs among the zombie dots[/td][td]Sky blue by default[/td][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3803984183]Project A-Life [ALIFE NPCS][/url][/td][td]ProjectALifeNPCs[/td][td]Colors its NPCs among the zombie dots[/td][td]Green by default (sky blue when it is the only one enabled)[/td][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3791152383]Dynamic Outposts[/url][/td][td]claimableoutposts_dynamic_hordes[/td][td]Outposts and infested points you can see are drawn on the mini-map[/td][td]Supply-type icons on a cream, green or red disc; red-ringed skull for infested points[/td][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3789197845]Random Airdrops HF[/url][/td][td]RandomAirdropsHF[/td][td]Airdrop drop points on the mini-map and the world map (singleplayer only)[/td][td]This pack's yellow-ringed airdrop icon[/td][/tr]
[/table]
[h3]When a supported mod is not installed[/h3]
[list]
[*] [b]Quietly does nothing[/b]: if one of these mods is not enabled, that part adds no options and no errors.
[*] [b]Just one of them[/b]: fine too.
[/list]
[h3]Original authors & asset boundary[/h3]
[list]
[*] [b]Original authors[/b]: Companion Dogs, [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod[/url], Bandits, Project A-Life, Dynamic Outposts and Random Airdrops HF belong to their original authors.
[*] [b]Requires the original mods[/b]: this pack does not copy or repackage their code, models, textures, or sounds.
[*] [b]Original assets[/b]: the colored dog, horse and wolf icons, the horse-head and wolf-head symbols, and the airdrop and infested-point icons were made for this compatibility pack; outpost icons reuse the main mod's resource point icons. NPC colors use no images.
[/list]
=== 🧰 Companion Dogs
{{img:01-symbol-en.jpg}}
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3740052292]Companion Dogs [ALPHA][/url] (Mod ID: [b]CompanionDogs[/b])
[list]
[*] [b]Species filter[/b]: when enabled, "Dogs (loaded nearby)" appears in the main mod's animal species filter.
[*] [b]Icons[/b]: with the main mod's animal icons on, nearby loaded animals in the [b]dog[/b] group follow your icon style: the symbol style uses the vanilla paw print, the colored style uses this pack's original colored dog icon.
[*] [b]What this pack adds[/b]: the main mod already shows unknown animal groups with a paw print; this pack adds the verified "Dogs" name and a dedicated filter toggle.
[*] [b]Markers untouched[/b]: Companion Dogs' own active/passive companion markers keep working.
[*] [b]No extra layer by default[/b]: animal icons in the main mod are off by default, so no extra generic dog icon is drawn.
[*] [b]Only want Companion Dogs' markers?[/b] Untick "Dogs" in the main mod's animal icon species filter.
[*] [b]Never hides the whole group[/b]: the [b]dog[/b] group can include both companion and stray dogs, so you decide in the filter.
[*] [b]Wolves[/b]: Companion Dogs 0.9.0 and later has wolves that attack players (with the sandbox option "Aggressive animals" on, wolf packs appear in forests). Nearby loaded animals in the [b]wolf[/b] group appear under a separate "Wolves (loaded nearby)" filter entry, using this pack's original wolf-head symbol (symbol style) or colored wolf icon (colored style); untick "Wolves" to hide them. With an older Companion Dogs that has no wolves, the "Wolves" entry still appears but shows nothing.
[/list]
=== 🧰 Horse Mod
{{img:02-item-en.jpg}}
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod [B42.14+/MP SOON][/url] (Mod ID: [b]Horse[/b])
[list]
[*] [b]Species filter[/b]: when enabled, "Horses (loaded nearby)" appears in the species filter.
[*] [b]Icons[/b]: nearby loaded animals in the [b]horse[/b] group use this pack's original horse-head symbol (symbol style) or colored horse icon (colored style).
[*] [b]Nearby only[/b]: only horses already loaded near you are shown; there is no map-wide tracking.
[*] [b]Display only[/b]: does not change horse spawning, AI, equipment, or riding.
[/list]
=== 🧰 Bandits & Project A-Life
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3268487204][B42] Bandits NPC[/url] (Mod ID: [b]Bandits2[/b]), [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3803984183]Project A-Life [ALIFE NPCS][/url] (Mod ID: [b]ProjectALifeNPCs[/b])
[list]
[*] [b]Before[/b]: NPCs from these two mods are zombies inside the game, so the main mod's zombie dots already drew them as orange dots, the same as zombies.
[*] [b]What this pack adds[/b]: it tells the main mod how to recognize NPCs from these two mods. Recognized NPCs use that mod's color and are drawn on top of the zombie dots, on both the mini-map and the world map.
[*] [b]Settings to turn on[/b]: the main mod's "Show zombie dots on the mini-map" (off by default). The "Zombies" category of Map Display Settings has "Color NPCs separately" (on by default) and one "dot color" row per NPC mod; its note lists the NPC mods that are recognized right now.
[*] [b]Same reach[/b]: range, limit and scan interval are the same as for zombie dots, so you do not see any farther.
[*] [b]Needs a newer main mod[/b]: the main mod has to be a version with NPC colors; with an older one NPCs keep the zombie color, and dog and horse support works as before.
[*] [b]Not included[/b]: Bandits camps, map-wide roaming groups, friend/foe colors. This pack does not read either mod's private data or call their code.
[/list]
=== 🧰 Dynamic Outposts
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3791152383]Dynamic Outposts[/url] (Mod ID: [b]claimableoutposts_dynamic_hordes[/b])
[list]
[*] [b]Before[/b]: outposts and infested areas were only drawn on the world map, not on the mini-map.
[*] [b]What this pack adds[/b]: following the mod's own rules, the outposts you can see are drawn on the mini-map: the ones you discovered by getting close, all of them when the server reveals them all, and claimed outposts you have access to.
[*] [b]Icons[/b]: supply-type icons borrowed from the main mod's resource points, on the same colors as its world map: cream for normal, green for claimed, red for occupied by bandits. Active infested points are drawn as a red-ringed skull.
[*] [b]Mini-map only[/b]: the world map keeps Dynamic Outposts' own icons. When its option "Show outpost map icons" is off, the mini-map draws none either.
[*] [b]Size[/b]: follows the main mod's "Marker size (home, favorites, nav, search)" setting.
[/list]
=== 🧰 Random Airdrops HF
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3789197845]Random Airdrops HF[/url] (Mod ID: [b]RandomAirdropsHF[/b])
[list]
[*] [b]Before[/b]: the radio only names the place; you had to mark the drop point on the map yourself.
[*] [b]What this pack adds[/b]: once the plane drops the airdrop, its drop point is drawn as a yellow-ringed airdrop icon labelled "Airdrop" on both the mini-map and the world map. When the mod removes the airdrop, the marker goes too.
[*] [b]Singleplayer only[/b]: Random Airdrops HF itself does not support multiplayer, so this pack draws nothing in multiplayer.
[*] [b]After loading a save[/b]: airdrops dropped before you loaded are not drawn, because the drop point is only captured when it drops. By default the mod clears old airdrops on load anyway.
[/list]
[h3]How these two are supported[/h3]
[list]
[*] [b]Reading their internal data[/b]: neither mod offers an interface for other mods, so this pack reads their internal data directly; for Random Airdrops it also records where the plane drops, and the mod's own actions run unchanged.
[*] [b]When they update[/b]: this pack checks their Steam versions automatically every day. If something no longer matches, this pack draws nothing and leaves one line in the game log instead of causing errors, and we fix it as needed.
[/list]
=== ⚠️ Multiplayer notes
[list]
[*] [b]Servers enable all three[/b]: the main mod, the third-party mod, and this pack.
[*] [b]Servers can turn NPC colors off[/b]: when the sandbox option "Allow NPC dot colors" (on by default) is off, every player sees NPCs in the zombie color.
[*] [b]Dynamic Outposts[/b]: works in multiplayer, using the outpost data the server sends you.
[*] [b]Random Airdrops HF[/b]: the mod itself does not support multiplayer, so there are no airdrop markers in multiplayer.
[*] [b]Horse Mod in multiplayer[/b]: the pack itself works in multiplayer, but Horse Mod is currently labelled [b]MP SOON[/b] on the Workshop, and its description states that riding is not yet supported in MP.
[*] [b]Upstream limits stay[/b]: this compatibility feature does not change or bypass those upstream limitations.
[/list]
=== ❓ FAQ
[h3]I installed the pack but see no dogs, horses or wolves on the map?[/h3]
[list]
[*] Make sure the main mod's animal icons are on (they are off by default).
[*] Make sure "Dogs"/"Horses"/"Wolves" are ticked in the species filter.
[*] Wolves need Companion Dogs 0.9.0 or later, and only appear in forests with the sandbox option "Aggressive animals" on.
[*] Only animals loaded near you are shown.
[/list]
[h3]There is no "Dogs", "Horses" or "Wolves" entry in the filter?[/h3]
[list]
[*] The matching third-party mod is not enabled.
[*] In multiplayer, the server has to enable it.
[/list]
[h3]NPCs from Bandits or Project A-Life are not colored?[/h3]
[list]
[*] Make sure the main mod's "Show zombie dots on the mini-map" is on (off by default).
[*] Open the "Zombies" category of Map Display Settings: if its note does not list that mod, this pack or that mod is not enabled, or the main mod is too old.
[*] Make sure "Color NPCs separately" is ticked; in multiplayer the server may also have turned off "Allow NPC dot colors".
[/list]
[h3]I only want Companion Dogs' own markers?[/h3]
[list]
[*] Untick "Dogs" in the main mod's animal icon species filter.
[*] Companion Dogs' markers are unaffected.
[/list]
[h3]Dynamic Outposts outposts don't show on the mini-map?[/h3]
[list]
[*] Only outposts you can see are drawn: if the world map doesn't show it, neither does the mini-map, so discover it first by getting close.
[*] Make sure Dynamic Outposts' option "Show outpost map icons" is on.
[*] If the game log has lines starting with [MinidoracatMiniMapCompat], Dynamic Outposts may have changed in an update; please report it.
[/list]
[h3]No airdrop marker?[/h3]
[list]
[*] It only works in singleplayer, and appears once the plane has dropped the airdrop.
[*] Airdrops dropped before you loaded the save are not drawn.
[/list]
=== 💬 Want another mod supported?
To request support for another mod, post in the original thread using its format: [url=https://steamcommunity.com/workshop/filedetails/discussion/3765182411/586187095760055711/]Compatibility Guide & Requests[/url]
[h3]How requests are evaluated[/h3]
[list]
[*] [b]Vanilla data first[/b]: prefer safely identifiable vanilla object data that the game already syncs.
[*] [b]No copied assets[/b]: never copy or repackage third-party code, models, textures, or sounds.
[*] [b]Read only[/b]: we only read the mod's data, never change it, and never bypass its permissions or multiplayer sync.
[*] [b]Supported even without a public interface[/b]: this pack may read the mod's internal data and checks its Steam version automatically every day; if something no longer matches, it draws nothing until fixed.
[*] [b]Priority[/b]: more requests for the same mod raise its research priority, but support is not guaranteed.
[/list]
=== 💬 Feedback
[list]
[*] [b][url=https://github.com/Minidoracat/MinidoracatMiniMapCompatFor42/issues]GitHub Issues[/url][/b]: for bug reports, please include
[list]
[*] your enabled mod list
[*] singleplayer or multiplayer
[*] steps to reproduce
[/list]
[*] [b][url=https://discord.gg/Gur2V67]Discord[/url][/b]: chat
[*] [b]Related[/b]:
[list]
[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3763913359]Minidoracat MiniMap[/url]
[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3809297109]Full collection[/url]
[/list]
[/list]
