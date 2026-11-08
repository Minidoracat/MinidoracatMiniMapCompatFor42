#!/usr/bin/env python3
"""查 upstream.json 登記的第三方 Workshop MOD 是否在核對過之後又更新了。

    python scripts/check_upstream.py                         # 查時間戳；有更新 exit 3
    python scripts/check_upstream.py --source DIR            # 另比對 DIR/<wid>/ 的檔案與契約字串
    python scripts/check_upstream.py --force "WID WID"       # 當作有更新跑完整流程（測試用）
    python scripts/check_upstream.py --report out.json       # 給 GitHub Action 的結構化輸出（含 issue 標題與內文）
    python scripts/check_upstream.py --ack WID|all --source DIR   # 核對完：記下時間戳、全檔 hash 清單、契約字串位置

DIR 是 workshop content 根（其下為 <wid>/…），例：<steamcmd 安裝目錄>/steamapps/workshop/content/108600；
不給時找本機 Steam 訂閱目錄。

repo 公開，而且不複製第三方程式碼：只存「相對路徑→SHA-256」清單（upstream/<wid>.files.json）
與 upstream.json 裡登記的契約字串，不存檔案快照、不產生 diff。報告只有路徑、數量與契約字串在不在。
"""
import argparse
import hashlib
import json
import os
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
UPSTREAM = ROOT / "upstream.json"
STATE = ROOT / "upstream"
API = "https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/"
DEFAULT_SOURCES = [
    os.environ.get("PZ_WORKSHOP_DIR", ""),
    "D:/SteamLibrary/steamapps/workshop/content/108600",
    "C:/Program Files (x86)/Steam/steamapps/workshop/content/108600",
]
LIST_MAX = 200  # issue 內文每類檔案最多列幾筆
EXIT_CHANGED = 3


def fetch_details(wids):
    form = {"itemcount": str(len(wids))}
    for i, wid in enumerate(wids):
        form[f"publishedfileids[{i}]"] = str(wid)
    req = urllib.request.Request(API, data=urllib.parse.urlencode(form).encode(), method="POST")
    with urllib.request.urlopen(req, timeout=30) as resp:
        payload = json.load(resp)
    return {str(d["publishedfileid"]): d for d in payload["response"]["publishedfiledetails"]}


def fmt(ts):
    return time.strftime("%Y-%m-%d %H:%M", time.gmtime(ts)) + " UTC" if ts else "（未核對）"


def find_source(explicit):
    for cand in ([explicit] if explicit else DEFAULT_SOURCES):
        if cand and Path(cand).is_dir():
            return Path(cand)
    return None


def hash_tree(root: Path):
    return {p.relative_to(root).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in sorted(root.rglob("*")) if p.is_file()}


def find_contracts(u, root: Path):
    """每條契約字串現在出現在哪些檔（相對 root）。只回路徑，不回內容。"""
    needles = [(c, c["text"].encode("utf-8")) for c in u.get("contracts", [])]
    found = {c["text"]: [] for c, _ in needles}
    for p in sorted(root.rglob("*")):
        if not p.is_file():
            continue
        data = p.read_bytes()
        for c, b in needles:
            if b in data:
                found[c["text"]].append(p.relative_to(root).as_posix())
    return found


def compare(u, src_dir):
    wid = str(u["wid"])
    cur_root = src_dir / wid if src_dir else None
    if not cur_root or not cur_root.is_dir():
        return {"status": "no_source"}, None
    found = find_contracts(u, cur_root)
    contracts = [{"text": c["text"], "why": c.get("why", ""), "acked_files": c.get("files", []),
                  "found_in": found[c["text"]]} for c in u.get("contracts", [])]
    baseline_file = STATE / f"{wid}.files.json"
    if not baseline_file.exists():
        return {"status": "no_baseline", "hint": f"先跑 --ack {wid} 建立基線"}, contracts
    old = json.loads(baseline_file.read_text(encoding="utf-8"))
    new = hash_tree(cur_root)
    added = sorted(set(new) - set(old))
    removed = sorted(set(old) - set(new))
    modified = sorted(k for k in set(old) & set(new) if old[k] != new[k])
    watch = {}
    for rel in u.get("watch_files", []):
        watch[rel] = ("新增" if rel in added else "移除" if rel in removed or rel not in new
                      else "修改" if rel in modified else "沒變")
    return {"status": "ok", "added": added, "removed": removed, "modified": modified, "watch": watch}, contracts


def file_lines(paths):
    out = [f"- `{p}`" for p in paths[:LIST_MAX]]
    if len(paths) > LIST_MAX:
        out.append(f"- …另 {len(paths) - LIST_MAX} 筆（完整清單見 artifact）")
    return out


def render(c, run_url):
    """產生 issue 標題、內文與去重標記。內文只有路徑、數量、契約字串，沒有上游檔案內容。"""
    wid = c["wid"]
    key = f"[upstream] {wid}"
    url = f"https://steamcommunity.com/sharedfiles/filedetails/?id={wid}"
    if c["status"] == "unavailable":
        marker = f"<!-- upstream-ts:{wid}:result{c['steam_result']} -->"
        title = f"{key} {c['name']} 可能已下架（Steam result={c['steam_result']}）"
        body = [url, "", f"Steam 查不到這個 MOD（result={c['steam_result']}）。本包用到的地方：{c['used_by']}",
                "", "伺服器與玩家之後抓不到它，本包對應的相容會自動不啟用；確認下架屬實後，決定要不要從 upstream.json 移除這筆。"]
        return title, "\n".join(body + ["", marker]), marker

    marker = f"<!-- upstream-ts:{wid}:{c['steam_time_updated']} -->"
    cmp_, contracts = c["compare"], c.get("contracts")
    missing = [x for x in contracts or [] if not x["found_in"]]
    title = f"{key} {c['name']} 更新於 {fmt(c['steam_time_updated'])}"
    if missing:
        title += " ⚠ 契約字串不見"
    elif cmp_["status"] != "ok":
        title += "（未比對檔案）"
    body = [url, "", f"本包用到的地方：{c['used_by']}", "", "## 1. 時間戳",
            f"- 核對過的版本：{fmt(c.get('acked_time_updated'))}（{c.get('acked_title') or '—'}）",
            f"- Steam 現在：{fmt(c['steam_time_updated'])}（{c.get('steam_title') or '—'}）"]
    if c.get("forced"):
        body.append("- 這次是手動 `force` 觸發（測試用），不代表 Steam 真的有新版本。")
    body += ["", "## 2. 檔案清單差異"]
    if cmp_["status"] != "ok":
        body.append(f"⚠ 無法比對（{cmp_['status']}{'：' + cmp_['hint'] if cmp_.get('hint') else ''}）——SteamCMD 匿名下載失敗或沒有基線，請手動核對。")
    elif not (cmp_["added"] or cmp_["removed"] or cmp_["modified"]):
        body.append("**檔案零差異**，可直接 ack。")
    else:
        body.append(f"+{len(cmp_['added'])} 新增　−{len(cmp_['removed'])} 移除　~{len(cmp_['modified'])} 修改")
        for k, label in (("added", "新增"), ("removed", "移除"), ("modified", "修改")):
            if cmp_[k]:
                body += ["", f"{label}：", *file_lines(cmp_[k])]
    if cmp_["status"] == "ok":
        body += ["", "## 3. 關鍵檔（watch_files）"]
        body += [f"- {'⚠ ' if s != '沒變' else ''}`{rel}`：{s}" for rel, s in cmp_["watch"].items()] or ["（沒有登記）"]
    body += ["", "## 4. 契約字串（本包依賴的字串）"]
    if contracts is None:
        body.append("⚠ 沒有下載到檔案，無法檢查。")
    for x in contracts or []:
        if x["found_in"]:
            moved = "" if not x["acked_files"] or sorted(x["found_in"]) == sorted(x["acked_files"]) else f"（核對時在 {', '.join(f'`{f}`' for f in x['acked_files'])}）"
            body.append(f"- ✅ 還在：`{x['text']}` → {', '.join(f'`{f}`' for f in x['found_in'])}{moved}　— {x['why']}")
        else:
            body.append(f"- ⚠ **不見了**：`{x['text']}`（核對時在 {', '.join(f'`{f}`' for f in x['acked_files'])}）　— {x['why']}")
    if missing:
        body += ["", f"⚠ {len(missing)} 條契約字串不見，本包對應的功能很可能已經失效。"]
    body += ["", "## 重核要點", c.get("recheck") or "（未填）", "",
             "## 怎麼 ack",
             "不急著處理就讓這則 issue 開著，之後的新版本只會在這裡留言；**關閉前要先 ack**，否則下次排程會再開一則。",
             "1. 本機匿名下載最新版：`steamcmd +force_install_dir <DIR> +login anonymous "
             f"+workshop_download_item 108600 {wid} +quit`",
             "2. 對照上面的變動看本包的相容碼要不要改；契約字串改了位置或拼法，先改 `upstream.json` 這筆的 `contracts`。",
             f"3. `python scripts/check_upstream.py --ack {wid} --source <DIR>/steamapps/workshop/content/108600`",
             f"4. commit `upstream.json` 與 `upstream/{wid}.files.json`，再關閉本 issue。"]
    if run_url:
        body += ["", f"完整報告：{run_url}（artifact `upstream-report`）"]
    return title, "\n".join(body + ["", marker]), marker


def ack(u, src_dir, now, title):
    wid = str(u["wid"])
    cur_root = src_dir / wid if src_dir else None
    if not cur_root or not cur_root.is_dir():
        print(f"  {wid}: 找不到 {cur_root}，不 ack")
        return False
    found = find_contracts(u, cur_root)
    lost = [t for t, fs in found.items() if not fs]
    lost_watch = [rel for rel in u.get("watch_files", []) if not (cur_root / rel).is_file()]
    if lost or lost_watch:
        for t in lost:
            print(f"  {wid}: 契約字串找不到：{t}")
        for rel in lost_watch:
            print(f"  {wid}: watch_files 找不到：{rel}")
        print(f"  {wid}: 先改 upstream.json 這筆的 contracts／watch_files，再 ack")
        return False
    for c in u.get("contracts", []):
        c["files"] = found[c["text"]]
    u["acked_time_updated"] = now
    u["acked_title"] = title
    STATE.mkdir(exist_ok=True)
    files = hash_tree(cur_root)
    (STATE / f"{wid}.files.json").write_text(json.dumps(files, indent=1) + "\n", encoding="utf-8", newline="\n")
    print(f"  {wid}: 時間戳 {fmt(now)}、{len(files)} 檔 hash、{len(found)} 條契約字串")
    return True


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    ap = argparse.ArgumentParser()
    ap.add_argument("--ack", metavar="WID|all")
    ap.add_argument("--report", metavar="FILE")
    ap.add_argument("--source", metavar="DIR", help="workshop content 根目錄（其下為 <wid>/）")
    ap.add_argument("--force", default="", metavar="WIDS", help="空白分隔；當作有更新跑完整流程")
    args = ap.parse_args()

    data = json.loads(UPSTREAM.read_text(encoding="utf-8"))
    ups = data["upstreams"]
    details = fetch_details([u["wid"] for u in ups])
    src_dir = find_source(args.source)

    if args.ack:
        ok = True
        for u in ups:
            if args.ack not in ("all", str(u["wid"])):
                continue
            d = details.get(str(u["wid"]))
            if not d or d.get("result") != 1:
                print(f"  {u['wid']}: Steam 回 result={d.get('result') if d else None}，不 ack")
                ok = False
                continue
            ok = ack(u, src_dir, int(d["time_updated"]), d.get("title")) and ok
        UPSTREAM.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
        return 0 if ok else 1

    forced = set(args.force.split())
    unknown = forced - {str(u["wid"]) for u in ups}
    if unknown:
        sys.exit(f"--force 有沒登記的 wid：{' '.join(sorted(unknown))}")
    run_url = ""
    if os.environ.get("GITHUB_RUN_ID"):
        run_url = f"{os.environ['GITHUB_SERVER_URL']}/{os.environ['GITHUB_REPOSITORY']}/actions/runs/{os.environ['GITHUB_RUN_ID']}"

    changed = []
    for u in ups:
        wid = str(u["wid"])
        d = details.get(wid)
        if not d or d.get("result") != 1:
            c = {**u, "status": "unavailable", "steam_result": d.get("result") if d else None}
        else:
            now = int(d["time_updated"])
            if now <= int(u.get("acked_time_updated", 0)) and wid not in forced:
                continue
            cmp_, contracts = compare(u, src_dir)
            c = {**u, "status": "updated", "forced": now <= int(u.get("acked_time_updated", 0)),
                 "steam_time_updated": now, "steam_title": d.get("title"), "compare": cmp_, "contracts": contracts}
        c["issue_title"], c["issue_body"], c["marker"] = render(c, run_url)
        changed.append(c)

    if args.report:
        Path(args.report).write_text(json.dumps(changed, ensure_ascii=False, indent=2), encoding="utf-8")
    if not changed:
        print(f"OK — {len(ups)} 個上游都沒有新更新")
        return 0
    for c in changed:
        print(f"===== {c['issue_title']}\n{c['issue_body']}\n")
    return EXIT_CHANGED


if __name__ == "__main__":
    sys.exit(main())
