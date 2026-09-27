<!-- Steam 討論區貼文稿源（EN）；簡介只放摘要，詳細內容以本串為準 -->
<!-- 討論串網址：https://steamcommunity.com/workshop/filedetails/discussion/3765182411/586187095760055711/ -->
<!-- 標題：📖 Compatibility Guide & Requests -->

[b]繁體中文版：[/b][url=https://steamcommunity.com/workshop/filedetails/discussion/3765182411/586187095760055679/]相容包說明＆支援許願[/url]

[h1]📖 Compatibility Guide & Requests[/h1]
This thread explains which MODs the [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3765182411]MOD Compatibility[/url] pack supports and what it actually does. Want another MOD supported? Post your request right here.

[h2]🚀 Quick start[/h2]
[olist]
[*] Subscribe to and enable [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3763913359]Minidoracat MiniMap for B42[/url] (main MOD), this pack, and the third-party MOD you want supported; in multiplayer, the server must enable all three
[*] Turn on animal icons in the main MOD's animal icon settings (they are off by default)
[*] “Dogs (loaded nearby)” and “Horses (loaded nearby)” appear in the species filter and can be toggled individually
[/olist]
Works on Build 42.19.0+, in both singleplayer and multiplayer.

[h2]🐕🐎 Supported MODs and what they do[/h2]

[h3]Companion Dogs [ALPHA][/h3]
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3740052292]Companion Dogs [ALPHA][/url] (Mod ID: [b]CompanionDogs[/b])
[list]
[*] When enabled, “Dogs (loaded nearby)” appears in the main MOD's animal species filter
[*] With the main MOD's animal icons on, nearby loaded animals in the [b]dog[/b] group follow your icon style: the symbol style uses the vanilla paw print, the colored style uses this pack's original colored dog icon
[*] The main MOD already shows unknown animal groups with a paw print; this pack adds the verified “Dogs” name and a dedicated filter toggle
[*] Companion Dogs' own active/passive companion markers keep working; this pack does not replace them
[*] Animal icons in the main MOD are off by default, so no extra generic dog icon is drawn by default. If you turn them on but only want Companion Dogs' own markers, untick “Dogs” in the main MOD's animal icon species filter
[*] The [b]dog[/b] group can include both companion and stray dogs, so this pack never hides the whole group on its own; you decide in the filter
[/list]

[h3]Horse Mod[/h3]
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod [B42.14+/MP SOON][/url] (Mod ID: [b]Horse[/b])
[list]
[*] When enabled, “Horses (loaded nearby)” appears in the species filter
[*] Nearby loaded animals in the [b]horse[/b] group use this pack's original horse-head symbol (symbol style) or colored horse icon (colored style)
[*] Only horses already loaded near you are shown; there is no map-wide tracking
[*] This pack only displays them on the map; it does not change horse spawning, AI, equipment, or riding
[/list]

[h3]When a supported MOD is not installed[/h3]
If Companion Dogs or Horse Mod is not enabled, that part quietly does nothing: no extra options and no errors. Using just one of them is fine.

[h2]🌐 Multiplayer notes[/h2]
[list]
[*] Servers must enable the main MOD, the third-party MOD, and this pack
[*] The compatibility pack itself works in multiplayer, but Horse Mod is currently labelled [b]MP SOON[/b] on the Workshop, and its description states that riding is not yet supported in MP. This compatibility feature does not change or bypass those upstream limitations
[/list]

[h2]❓ FAQ[/h2]
[b]I installed the pack but see no dogs or horses on the map.[/b]
Make sure the main MOD's animal icons are on (they are off by default) and that “Dogs”/“Horses” are ticked in the species filter. Only animals loaded near you are shown.

[b]There is no “Dogs” or “Horses” entry in the filter.[/b]
The matching third-party MOD is not enabled. In multiplayer, the server has to enable it.

[b]I only want Companion Dogs' own markers.[/b]
Untick “Dogs” in the main MOD's animal icon species filter. Companion Dogs' markers are unaffected.

[h2]🙏 Original authors & asset boundary[/h2]
Companion Dogs and [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod[/url] belong to their original authors. This pack requires the original MODs and does not copy or repackage their code, models, textures, or sounds. The colored dog and horse icons and the horse-head symbol are original assets made for this compatibility pack.

[h2]💡 Want another MOD supported? Request it here[/h2]
[h3]📝 Request format[/h3]
[list]
[*] The third-party MOD's Workshop link (required)
[*] The object type you want displayed (required): e.g. dogs, NPCs, special vehicles
[*] Expected behavior (optional): show all, only tamed/owned, or a separate filter
[*] Known Mod ID / object group (optional)
[/list]

[h3]✅ Currently supported[/h3]
[list]
[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3740052292]Companion Dogs [ALPHA][/url] — adds the [b]dog[/b] group to the animal species filter, with the vanilla paw-print symbol and this pack's colored dog icon
[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod[/url] — adds the [b]horse[/b] group to the animal species filter, with this pack's horse-head symbol and colored horse icon
[/list]

[h3]🔎 How requests are evaluated[/h3]
[list]
[*] Prefer safely identifiable vanilla object data that the game already syncs
[*] Never copy or repackage third-party code, models, textures, or sounds
[*] Never bypass an upstream MOD's permissions, private state, or multiplayer sync design
[*] If a public API or permission from the upstream author is needed, work waits for the author's cooperation instead of guessing
[*] More requests for the same MOD raise its research priority, but support is not guaranteed
[/list]

[h2]💬 Reporting[/h2]
[list]
[*] Requests: comment in this thread using the format above
[*] Bug reports: [url=https://github.com/Minidoracat/MinidoracatMiniMapCompatFor42/issues]GitHub Issues[/url] — please include your enabled MOD list, singleplayer or multiplayer, and steps to reproduce
[*] Chat: [url=https://discord.gg/Gur2V67]Discord[/url]
[/list]
