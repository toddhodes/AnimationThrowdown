# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A collection of bash scripts that automate gameplay tasks for the mobile card game **Animation Throwdown** via the
Kongregate/Synapse Games API (`https://cb-live.synapsegames.com/api.php`). No compiled code — everything is shell
scripts, `jq`, and `xmlstarlet`.

## Prerequisites

Dependencies: `curl`, `XMLStarlet`, `jq` — install via `brew install curl XMLStarlet jq`.

Credentials: create `~/.at_creds` with your account's player ID and password hash:
```
user_id=8679305
password_hash=6BhhkA23C47ED572
```
All scripts read credentials from this file at runtime.

## Common Commands

```bash
make            # full refresh: fetch card data + user units + generate all output files
make cards      # fetch global card definitions -> cards-w-id-and-rarity
make deck       # fetch user's owned units -> units-w-levels + ids-with-cm
make gen_cards  # generate Decks/CARDS from local data files
make gen_cm     # generate Combos/ComboMastery* from local data files
make cm         # cards + deck + gen_cm (skips gen_cards)
make clean      # remove intermediate files (cards-w-id-and-rarity, units-w-levels, ids-with-cm, vars, o-*)
```

For searching your deck and combo mastery together:
```bash
./cardAndCmGrep.sh <pattern>   # greps only Decks/CARDS and Combos/ComboMastery
```

## Data Flow Architecture

### Fetch phase (network calls)

- `get-cards` — calls `getStaticFiles` to get the CDN URL for global card data, then fetches it. Writes `cards-w-id-and-rarity` (format: `<id> <rarity> <name>`, one card per line, rarity 1–5 = C/R/E/L/M).
- `get-deck` — calls `init` API with user credentials. Writes:
  - `units-w-levels` — user's owned cards: `<unit_id>-<level>-<mastery_level>`
  - `ids-with-cm` — combos with CM level: `<combo_id>-<cm_level>`
  - `/tmp/user.json` — raw API response (used by `gen-cm-tokens`)

### Generate phase (pure local computation)

- `gen-cards` — joins `cards-w-id-and-rarity` + `units-w-levels` via shell variable cache in `vars`. Outputs card lines like `E Cute Witch of the North: 5**`; Makefile pipes through `sort | uniq -c` to produce `Decks/CARDS`.
- `gen-cm` — joins `ids-with-cm` + `cards-w-id-and-rarity`. Writes `Combos/ComboMasteryLevels`.
- `gen-cm-tokens` — parses `/tmp/user.json` for mastery token items (item IDs starting with `2` + 6-digit combo ID) and mastery stones (item ID `200008`). Writes `Combos/ComboMasteryTokens`.
- `gen-cm-combined` — joins `ComboMasteryLevels` + `ComboMasteryTokens` using shell `join`. Writes `Combos/ComboMastery` (the human-readable output).

### The `vars` file

`gen-cards` generates `vars` as a sourceable shell file mapping unit IDs to their full card string: `unit_10003="10003 2 Toad Licking"`. Purchase scripts (`buy-1k-epic-stones.sh`, `buy-50kcoin-pack.sh`, `buy-golden-turd.sh`, `buy-watts-converter.sh`) source `vars` to resolve unit IDs in API responses back to card names. **These scripts will exit with an error if `vars` doesn't exist** — run `make` first.

### Output files (`o-*`)

Each API-calling script tees its response to an `o-*` file (e.g., `o-adventure_battle`, `o-auto_battle`, `o-epicstone`, `o-watts`). These serve as a cache of the last API response and are read by some scripts for follow-up `jq` queries.

## Script Categories

**Adventure automation**
- `adventure-iterate.sh <n>` — main loop: each iteration buys 3×30 energy refills then runs ~33-34 fights
- `adventure-buy-refills.sh [qty]` — uses item 1003 (+10 energy), default 30
- `adventure-fight5.sh [count] [auto_battle]` — runs `startMission`; `mission_id` hardcoded near top of script

**Arena automation**
- `arena-iterate.sh <n>` — each iteration buys 15 arena refills then runs 150 fights
- `arena-buy-refills.sh [qty]` — uses item 1024 (+10 arena), default 15
- `arena-fight5.sh <count> [auto_battle]` — runs `startHuntingBattle`
- `arena-sfc-to-rank.sh <min-SFC> [energy] [fights]` — fights until SFC rating exceeds target

**Purchasing**
- `buy-golden-turd.sh [n]` — buys item 63 (golden turd pack), resolves card name from `vars`
- `buy-50kcoin-pack.sh [n]` — buys item 66 (50k coin pack), resolves card name from `vars`
- `buy-1k-epic-stones.sh [n]` — uses item 200009 (epic stone), resolves card name from `vars`
- `buy-watts-converter.sh [n]` — buys item 82 (watts) one at a time with delay
- `convert-coins-to-watts.sh` / `buy-watts.sh` — buys item 83 (giggity watts at 3000 coins each), auto-calculates how many to buy from current coin balance
- `count-stones-and-gems.sh [n]` — calculates cumulative gem/stone cost for n purchases (escalating price formula)

## Key API Patterns

All calls POST to `https://cb-live.synapsegames.com/api.php?message=<action>&user_id=<id>` with `password=<hash>` in the POST body.

Common `message` values: `init`, `getStaticFiles`, `startMission`, `startHuntingBattle`, `useItem`, `buyStoreItem`.

The `result` field in responses is `true`/`false`; on failure, `result_message[0]` has the error. New cards appear in `new_units[].unit_id`.

## Output File Formats

**`Decks/CARDS`** — `<count> <rarity-letter> <name>: <level><stars> <show> <card-type>` where:
- Stars (`*`, `**`) indicate fuse cycles beyond max level (e.g., `6**` = max-fused legendary)
- Show: `FG` `AD` `BB` `KotH` `FT` `Archer` `gen` (generic cross-show)
- Card type: `PC` (power card / combo, has Combo Mastery), `item` (base single-show card), `chr` (character card)

**`Combos/ComboMastery`** — `<cm-level> | <combo-name> | <token-count>` (token count omitted when 0; CM level 0–3).

**`Decks/Clash/`**, **`Decks/Melee/`**, **`Decks/Siege/`** — static text files storing named deck configurations for specific game modes (Clash events, Melee, Siege). Manually maintained.
