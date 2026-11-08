# 地圖標記用的三張白色貼圖（MinidoracatMiniMapCompat.lua 的 newMarker 上色）：
#   marker_disc.png  圓盤，主 MOD 拿它畫標記的底盤（badge）與外框（ring）
#   infested.png     骷髏，Dynamic Outposts 感染點
#   airdrop.png      降落傘吊著箱子，Random Airdrops HF 空投
# 64×64，形狀只放在 alpha；先畫 8 倍大再縮小，邊緣才平滑。前哨站本身借主 MOD 的資源點圖示，不在這裡。
# 用法：uv run --with pillow scripts/make_marker_icons.py
import os

from PIL import Image, ImageDraw

SIZE, K = 64, 8
BIG = SIZE * K
OUT = os.path.join(os.path.dirname(__file__), "..", "MOD", "MinidoracatMiniMapCompatFor42", "Contents", "mods",
                   "MinidoracatMiniMapCompatFor42", "42", "media", "ui", "MinidoracatMiniMapCompat")


def save(mask, name):
    img = Image.new("RGBA", (BIG, BIG), (255, 255, 255, 0))
    img.putalpha(mask)
    img.resize((SIZE, SIZE), Image.LANCZOS).save(os.path.join(OUT, name), optimize=True)


def disc():
    m = Image.new("L", (BIG, BIG), 0)
    ImageDraw.Draw(m).ellipse((4, 4, BIG - 5, BIG - 5), fill=255)
    return m


def skull():
    m = Image.new("L", (BIG, BIG), 0)
    d = ImageDraw.Draw(m)
    d.ellipse((76, 40, 436, 370), fill=255)                      # 頭蓋
    d.rounded_rectangle((150, 300, 362, 452), radius=40, fill=255)  # 下巴
    d.ellipse((140, 170, 236, 270), fill=0)                       # 眼窩
    d.ellipse((276, 170, 372, 270), fill=0)
    d.polygon([(256, 280), (226, 336), (286, 336)], fill=0)       # 鼻孔
    for x in (206, 256, 306):                                     # 牙縫
        d.rectangle((x - 9, 380, x + 9, 452), fill=0)
    return m


def airdrop():
    m = Image.new("L", (BIG, BIG), 0)
    d = ImageDraw.Draw(m)
    d.pieslice((56, 24, 456, 304), 180, 360, fill=255)            # 傘面
    for cx in (123, 256, 389):                                    # 傘緣的弧
        d.ellipse((cx - 67, 128, cx + 67, 200), fill=0)
    for x0, x1 in ((70, 196), (190, 236), (322, 276), (442, 316)):  # 傘繩
        d.line((x0, 164, x1, 330), fill=255, width=16)
    d.rectangle((176, 322, 336, 482), fill=255)                   # 箱子
    d.rectangle((176, 394, 336, 410), fill=0)                     # 箱子的帶子
    d.rectangle((248, 322, 264, 482), fill=0)
    return m


os.makedirs(OUT, exist_ok=True)
save(disc(), "marker_disc.png")
save(skull(), "infested.png")
save(airdrop(), "airdrop.png")
print("wrote marker_disc.png, infested.png, airdrop.png to", os.path.normpath(OUT))
