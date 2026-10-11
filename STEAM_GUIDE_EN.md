<!-- 指南網址：https://steamcommunity.com/sharedfiles/filedetails/?id=3817848926 -->
<!-- Steam guide source (English): the full reference for this mod; the Workshop description only summarizes, requests stay in the original thread. Format and sync: pz-family-docs/release.md「完整說明：Steam 指南」 -->
<!-- 標題：📖 MiniMap - MOD Compatibility Guide: Supported Mods, Multiplayer & FAQ -->
<!-- 摘要：Illustrated guide to the Minidoracat MiniMap MOD Compatibility pack: which third-party mods it supports, what dogs and horses actually do on the map, multiplayer notes, FAQ, original authors and asset boundary, and how support requests are evaluated. -->
=== 🚀 Quick start
[b]繁體中文版：[/b][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3817848780]小地圖 - MOD 相容包 完整說明[/url]

The mod on Steam Workshop:
https://steamcommunity.com/sharedfiles/filedetails/?id=3765182411
[olist]
[*] [b]Subscribe and enable[/b]: [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3763913359]Minidoracat MiniMap[/url] (main mod), this pack, and the third-party mod you want supported. In multiplayer, the server must enable all three.
[*] [b]Turn on animal icons[/b]: in the main mod's animal icon settings (they are off by default).
[*] [b]Toggle each one[/b]: "Dogs (loaded nearby)" and "Horses (loaded nearby)" appear in the species filter.
[/olist]
[list]
[*] [b]Game version[/b]: follows the main mod (currently Build 42.21.0 or later).
[*] [b]Modes[/b]: works in both singleplayer and multiplayer.
[/list]
=== 🧰 Currently supported
[table]
[tr][th]Third-party mod[/th][th]Mod ID[/th][th]Group added to the filter[/th][th]Icons[/th][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3740052292]Companion Dogs [ALPHA][/url][/td][td]CompanionDogs[/td][td]dog[/td][td]Vanilla paw-print symbol, this pack's colored dog icon[/td][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod [B42.14+/MP SOON][/url][/td][td]Horse[/td][td]horse[/td][td]This pack's horse-head symbol and colored horse icon[/td][/tr]
[/table]
[h3]When a supported mod is not installed[/h3]
[list]
[*] [b]Quietly does nothing[/b]: if Companion Dogs or Horse Mod is not enabled, that part adds no options and no errors.
[*] [b]Just one of them[/b]: fine too.
[/list]
[h3]Original authors & asset boundary[/h3]
[list]
[*] [b]Original authors[/b]: Companion Dogs and [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod[/url] belong to their original authors.
[*] [b]Requires the original mods[/b]: this pack does not copy or repackage their code, models, textures, or sounds.
[*] [b]Original assets[/b]: the colored dog and horse icons and the horse-head symbol were made for this compatibility pack.
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
=== ⚠️ Multiplayer notes
[list]
[*] [b]Servers enable all three[/b]: the main mod, the third-party mod, and this pack.
[*] [b]Horse Mod in multiplayer[/b]: the pack itself works in multiplayer, but Horse Mod is currently labelled [b]MP SOON[/b] on the Workshop, and its description states that riding is not yet supported in MP.
[*] [b]Upstream limits stay[/b]: this compatibility feature does not change or bypass those upstream limitations.
[/list]
=== ❓ FAQ
[h3]I installed the pack but see no dogs or horses on the map?[/h3]
[list]
[*] Make sure the main mod's animal icons are on (they are off by default).
[*] Make sure "Dogs"/"Horses" are ticked in the species filter.
[*] Only animals loaded near you are shown.
[/list]
[h3]There is no "Dogs" or "Horses" entry in the filter?[/h3]
[list]
[*] The matching third-party mod is not enabled.
[*] In multiplayer, the server has to enable it.
[/list]
[h3]I only want Companion Dogs' own markers?[/h3]
[list]
[*] Untick "Dogs" in the main mod's animal icon species filter.
[*] Companion Dogs' markers are unaffected.
[/list]
=== 💬 Want another mod supported?
To request support for another mod, post in the original thread using its format: [url=https://steamcommunity.com/workshop/filedetails/discussion/3765182411/586187095760055711/]Compatibility Guide & Requests[/url]
[h3]How requests are evaluated[/h3]
[list]
[*] [b]Vanilla data first[/b]: prefer safely identifiable vanilla object data that the game already syncs.
[*] [b]No copied assets[/b]: never copy or repackage third-party code, models, textures, or sounds.
[*] [b]No bypassing upstream design[/b]: never bypass an upstream mod's permissions, private state, or multiplayer sync design.
[*] [b]Wait for the author[/b]: if a public API or permission from the upstream author is needed, work waits for the author's cooperation instead of guessing.
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
