<!-- 指南網址：https://steamcommunity.com/sharedfiles/filedetails/?id=3817848780 -->
<!-- Steam 指南稿源（繁中）：MOD 的完整說明以本指南為準，簡介只放摘要；許願留在原說明串。格式與同步方式見 pz-family-docs/release.md「完整說明：Steam 指南」 -->
<!-- 標題：📖 小地圖 - MOD 相容包 完整說明：支援的 MOD、多人注意與常見問題 -->
<!-- 摘要：Minidoracat 小地圖 MOD 相容包的圖文說明：支援哪些第三方 MOD、狗與馬在地圖上的實際行為、多人注意事項、常見問題、原作者與素材邊界，以及支援新 MOD 的評估原則。 -->
=== 🚀 快速上手
[b]English version:[/b] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3817848926]MiniMap - MOD Compatibility Guide[/url]

MOD 本體（Steam Workshop）：
https://steamcommunity.com/sharedfiles/filedetails/?id=3765182411
[olist]
[*] [b]訂閱並啟用[/b]：[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3763913359]Minidoracat MiniMap[/url]（主 MOD）、本相容包，以及要支援的第三方 MOD。多人時伺服器三者都要啟用。
[*] [b]開啟動物圖標[/b]：在主 MOD 的動物圖標設定中開啟（預設是關閉的）。
[*] [b]個別開關[/b]：物種篩選會出現「狗（附近已載入）」「馬（附近已載入）」。
[/olist]
[list]
[*] [b]遊戲版本[/b]：跟隨主 MOD（目前需 Build 42.21.0 以上）。
[*] [b]模式[/b]：單機與多人都能用。
[/list]
=== 🧰 目前支援
[table]
[tr][th]第三方 MOD[/th][th]Mod ID[/th][th]加入篩選的群組[/th][th]圖標[/th][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3740052292]Companion Dogs [ALPHA][/url][/td][td]CompanionDogs[/td][td]dog[/td][td]原版爪印符號、本包彩色狗圖[/td][/tr]
[tr][td][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod [B42.14+/MP SOON][/url][/td][td]Horse[/td][td]horse[/td][td]本包馬頭符號、彩色馬圖[/td][/tr]
[/table]
[h3]沒裝對應 MOD 時[/h3]
[list]
[*] [b]安靜不作用[/b]：沒啟用 Companion Dogs 或 Horse Mod 時，對應的部分不新增選項，也不產生錯誤。
[*] [b]只裝一個[/b]：也沒問題。
[/list]
[h3]原作者與素材邊界[/h3]
[list]
[*] [b]原作者[/b]：Companion Dogs 與 [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod[/url] 分屬各自的原作者（團隊）。
[*] [b]必須搭配原始 MOD[/b]：本包不複製或重包第三方 MOD 的程式、模型、貼圖或音效。
[*] [b]自製素材[/b]：狗與馬的彩圖、馬頭符號都是本相容包自行製作的。
[/list]
=== 🧰 Companion Dogs
{{img:01-symbol-zh.jpg}}
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3740052292]Companion Dogs [ALPHA][/url]（Mod ID：[b]CompanionDogs[/b]）
[list]
[*] [b]物種篩選[/b]：啟用後，「狗（附近已載入）」會出現在主 MOD 的動物物種篩選。
[*] [b]圖標[/b]：開啟主 MOD 的動物圖標後，附近已載入、屬於 [b]dog[/b] 群組的狗依你選的圖標風格顯示：符號風格用原版爪印，彩圖風格用本包自製的彩色狗圖。
[*] [b]本包加上的[/b]：主 MOD 原本就會用爪印顯示不認得的動物群組；本包加上確認過的「狗」名稱和獨立的篩選開關。
[*] [b]不接管 marker[/b]：Companion Dogs 自己的 active／passive companion marker 照常運作。
[*] [b]預設不多畫一層[/b]：主 MOD 的動物圖標預設關閉，所以預設不會多畫泛用狗圖標。
[*] [b]只想保留 Companion Dogs 的 marker[/b]：在主 MOD「動物圖標」物種篩選取消「狗」。
[*] [b]不隱藏整個群組[/b]：[b]dog[/b] 群組可能同時包含同伴狗與流浪狗，要不要顯示由你在篩選中決定。
[/list]
=== 🧰 Horse Mod
{{img:02-item-zh.jpg}}
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777]Horse Mod [B42.14+/MP SOON][/url]（Mod ID：[b]Horse[/b]）
[list]
[*] [b]物種篩選[/b]：啟用後，「馬（附近已載入）」會出現在物種篩選。
[*] [b]圖標[/b]：附近已載入、屬於 [b]horse[/b] 群組的馬，符號風格用本包自製的馬頭符號，彩圖風格用本包自製的彩色馬圖。
[*] [b]只顯示附近[/b]：只顯示你這邊已載入的附近馬匹，不提供全地圖追蹤。
[*] [b]只負責顯示[/b]：不修改馬的生成、AI、裝備或騎乘。
[/list]
=== ⚠️ 多人注意
[list]
[*] [b]伺服器要啟用三者[/b]：主 MOD、第三方 MOD 與本相容包。
[*] [b]Horse Mod 的多人限制[/b]：相容包本身可用於多人，但 Horse Mod 目前在 Workshop 標示 [b]MP SOON[/b]，其說明也寫明騎乘尚未支援多人。
[*] [b]不繞過上游限制[/b]：本相容功能不會改變或繞過 Horse Mod 的多人限制。
[/list]
=== ❓ 常見問題
[h3]裝了相容包，地圖上卻沒看到狗或馬？[/h3]
[list]
[*] 先確認主 MOD 的動物圖標有開啟（預設關閉）。
[*] 確認物種篩選中「狗」「馬」沒有被取消。
[*] 只會顯示你附近已載入的動物。
[/list]
[h3]篩選裡沒有「狗」或「馬」選項？[/h3]
[list]
[*] 對應的第三方 MOD 沒有啟用。
[*] 多人時要由伺服器啟用。
[/list]
[h3]只想用 Companion Dogs 自己的 marker？[/h3]
[list]
[*] 在主 MOD「動物圖標」物種篩選取消「狗」。
[*] Companion Dogs 的 marker 不受影響。
[/list]
=== 💬 想支援其他 MOD
想支援其他 MOD，請到原串照格式許願：[url=https://steamcommunity.com/workshop/filedetails/discussion/3765182411/586187095760055679/]相容包說明＆支援許願[/url]
[h3]評估原則[/h3]
[list]
[*] [b]原版資料優先[/b]：優先使用遊戲已同步、可安全辨識的原版物件資料。
[*] [b]不複製素材[/b]：不複製或重包第三方 MOD 的程式、模型、貼圖、音效。
[*] [b]不繞過上游設計[/b]：不繞過上游 MOD 的權限、私有狀態或多人同步設計。
[*] [b]等作者合作[/b]：需要上游作者提供公開 API 或授權時，會先等待作者合作，不猜測實作。
[*] [b]優先度[/b]：同一 MOD 的需求越多，研究優先度越高，但不保證一定可行。
[/list]
=== 💬 回報方式
[list]
[*] [b][url=https://github.com/Minidoracat/MinidoracatMiniMapCompatFor42/issues]GitHub Issues[/url][/b]：Bug 回報請附上
[list]
[*] 啟用的 MOD 清單
[*] 單機或多人
[*] 重現步驟
[/list]
[*] [b][url=https://discord.gg/Gur2V67]Discord 社群[/url][/b]：交流
[*] [b]相關 MOD[/b]：
[list]
[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3763913359]Minidoracat MiniMap[/url]
[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3809297109]全系列收藏[/url]
[/list]
[/list]
