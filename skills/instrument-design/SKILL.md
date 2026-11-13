---
name: instrument-design
description: The "Instrument" UI style, a dark machined-instrument design language (engraved corner brackets, 2px rules, arc-blue and gold accents, Archivo + Plex Mono, Monaspace Neon for code) that began on the Jarvis wall panel. Load before designing or styling any UI in a project that uses it (its CSS has --arc / --gold / --engrave tokens, or Archivo + Plex Mono) and whenever the instrument style is asked for. For its author, Anish, it is the default for new personal UIs (apps, PWAs, dashboards, artifacts). Skip for projects that already have their own established look unless asked to restyle them.
---

# Instrument: a house UI style

A dark UI built like a **machined instrument**, not a glowing sci-fi screen. It
started as the Iron Man HUD brief for the Jarvis wall panel. The design keeps that
brief and drops the usual way of doing it: no hairlines, hex grids, particles,
glow or decorative 9px text. What's left is engraved arcs, index ticks, corner
brackets and big, honest numbers. It's closer to an aviation chronograph than a
screensaver.

## Files in this folder

This folder is the source of truth. Read the file you need before inventing
anything.

| File | What it is |
|---|---|
| `starter.css` | The base to copy into a new project: tokens, type roles, the instrument surface and the shared components, at arm's-length (phone / web) scale |
| `wall.css` | Loaded after the starter for a fixed display read from 2 m: the wall scale and a viewport-derived root size |
| `charts.css` | Loaded after the starter in projects that draw charts |
| `fonts/` | The six self-hosted font files with their licences. Copy the whole folder |
| `lint.sh` | Checks stylesheets against the rules below that a pattern can check |
| `guide.html`, `instrument-design.pdf` | The printed guide for people. A rendering of this file, not a source: don't read it for rules |
| `LOCAL.md` | Optional, not published. If it exists, read it: it lists this machine's reference projects and which ones to leave alone |

When a project already uses the style, extend it and don't drift from it. When a
new project adopts it, keep the starter's header comment, naming the lineage and
every deliberate departure with its reason.

## Principles

1. **The display never lies.** Data that may be old looks old: it loses its
   colour and stops counting. Show "nothing planned" before a confident wrong
   number.
2. **Motion means something changed.** In the resting state nothing moves, except
   at most one purposeful indicator (Jarvis's reactor sweep). Animate on change, not
   for ambience. Respect `prefers-reduced-motion`.
3. **Colour is assigned meaning, and rare colours stay rare.** Red appears only
   for the one truly bad state, so it reads when it shows.
4. **Legibility over decoration.** There's a hard minimum type size. Tiny labels
   are decoration pretending to be information.
5. **Brackets, not boxes.** A surface is a raised panel with two engraved corner
   brackets, not a bordered, rounded, shadowed card.
6. **Offline-capable by default.** Self-host the fonts. Make the offline state a
   designed look, not an error page.
7. **Explain decisions in CSS comments.** Comment *why*: a measured number, a
   rejected alternative. That is part of the style.

## Palette

Dark only (`color-scheme: dark`). There is no light theme.

| Token | Hex | Role |
|---|---|---|
| `--ground` | `#0a0e14` | Page background. Deep anodized navy-slate. **Never `#000`**: pure black on an LCD reads as a dead panel. Also `theme-color` and icon background. |
| `--panel` | `#111823` | Raised instrument face (surfaces) |
| `--panel-lit` | `#16202e` | Focused, expanded or hovered surface |
| `--engrave` | `#2a3543` | Rules, corner brackets, borders, button hover fill |
| `--ink` | `#e8f1f8` | Primary text |
| `--ink-dim` | `#7c8fa3` | Secondary text, timestamps, meta |
| `--arc` | `#3dd6f5` | **Cool accent.** Live data, primary readouts, links, primary action, focus ring |
| `--arc-dim` | `#1d7f96` | Arc at rest. Labels, section headings, inactive ticks, tick-box outline |
| `--gold` | `#e8a33d` | **Warm accent.** Human or warm data, warnings, "almost", delays, unsent changes |
| `--alert` | `#ff4d4d` | The single worst state only (cancelled, can't). Rare. |
| `--slate` | `#55647a` | Offline/unknown substitute for arc, stale values, placeholders, empty-state titles |
| `--slate-dim` | `#3a4657` | Offline substitute for arc-dim |

The two accent temperatures are the identity: Iron Man is **gold and arc-blue**,
not blue alone. Two hues let "important" be told apart from "live".

**Semantic aliases.** Components use an alias for a state, never the raw hue.
The starter defines `--stale` and `--unsent`; a project adds its own
(`--on-pace: var(--arc); --behind: var(--gold);`) and lists them in its header
comment.

**Adding a colour** is allowed when a project needs a meaning the palette lacks.
Pick it at the arc's brightness so it sits in the same family, give it a semantic
alias, give it an offline value, and document it in a comment. Precedents: a
green `--go: #4fd68a` for a traffic light (`--ready` / `--almost` / `--no`), and
a violet `--meeting: #b39cff` (offline `#6f6596`) for a second kind of time.

**Offline / disconnected:** swap the tokens wholesale on a root attribute so no
component needs offline conditionals:
```css
:root[data-connection='offline'] { --arc: var(--slate); --arc-dim: var(--slate-dim); --gold: #8a7350; --ink: #b9c4d1; }
```

### Contrast, as measured

Ratios against `--ground` / `--panel` / `--panel-lit`:

| Token | Ratio | So it is used for |
|---|---|---|
| `--ink` | 16.9 / 15.6 / 14.4 | Anything |
| `--arc` | 11.2 / 10.3 / 9.5 | Anything |
| `--gold` | 9.0 / 8.3 / 7.6 | Anything |
| `--alert` | 5.9 / 5.5 / 5.0 | Anything |
| `--ink-dim` | 5.8 / 5.4 / 4.9 | Secondary text at any size |
| `--arc-dim` | 4.2 / 3.8 / 3.5 | Label-role text only (mono 500, uppercase, tracked, `--t-label` or larger) and marks |
| `--slate` | 3.2 / 3.0 / 2.7 | Placeholders, empty-state titles, marks. Never text that must be read to use the page |
| `--slate-dim`, `--engrave` | 2.0 and below | Marks and rules only, never text |

Two consequences. Don't set a sentence, a value or an instruction in `--arc-dim`
or `--slate`; use `--ink-dim`. And offline, labels fall to `--slate-dim` (under
2:1), so anything a person needs while offline must not be a `.label`.

## Typography

| Face | Use | Source |
|---|---|---|
| **Archivo** (variable, 400–700) | Data, readouts, headings, body (`--face-data`) | OFL |
| **IBM Plex Mono** (400, 500) | Labels, timestamps, status, buttons, meta, wordmark (`--face-mono`) | OFL |
| **Monaspace Neon** (variable, 200–800) | Code only: `code`, `pre`, `kbd`, `samp`, terminal output (`--face-code`) | GitHub Next, OFL |
| **Manjari** (400, 700) | Malayalam only, behind a `unicode-range` | SMC, OFL |

- The mono is where the instrument feel comes from: engraved, not luminous.
- **Plex Mono is the instrument's voice; Monaspace Neon is for code.** Labels,
  stamps and buttons never switch to Monaspace, and code never uses Plex Mono
  except as the fallback. Neon is the neo-grotesque of the
  [Monaspace](https://monaspace.githubnext.com/) family, so it sits beside
  Archivo. Don't mix in its other members (Argon, Xenon, Radon, Krypton).
- Monaspace ships **unmodified**: `fonts/monaspace-neon-var.woff2` is the
  official variable web font from the v1.400 release, renamed on disk only. Its
  licence reserves the name "Monaspace", so don't subset, instance or rename it.
  It is about 500 KB, but a browser downloads a face only when text uses it, so
  pages with no code never fetch it.
- Code keeps texture healing (`calt`, on by default) and **no code ligatures**
  (`ss01`–`ss10` off): the display shows the characters that are really there.
- **Self-host the fonts.** Copy this folder's `fonts/` (Latin subsets, about
  65 KB, plus Manjari) into the project's public root, licences included. Never
  use a CDN.
- Manjari is declared with `unicode-range: U+0D00-0D7F, U+200C-200D, U+20B9` so pages
  with no Malayalam never download it. Where content is known to be Malayalam,
  put Manjari first (`--face-malayalam`) to avoid a reflow. A project with no
  Malayalam can delete it. Another script gets its own face the same way.
- **Tabular numerals everywhere** on `body`: `font-variant-numeric: tabular-nums; font-feature-settings: 'tnum' 1;`.
  Changing numbers must not twitch.
- `-webkit-font-smoothing: antialiased`.

**Type roles:**
- `.hero`: the one number a surface exists to show. Weight 600, line-height 0.92, tracking -0.03em.
- `.readout`: weight 500, line-height 1.05.
- Body: line-height 1.35–1.45.
- `.label`: mono, weight 500, **UPPERCASE**, tracking 0.16em, colour `--arc-dim`. Section headings use this too.
- `.stamp`: mono, tracking 0.08em, `--ink-dim`. Timestamps and meta.
- Headings are Archivo 600, line-height ~1.05, negative tracking, `text-wrap: balance`.
- `.wordmark`: mono 500, uppercase, tracking 0.3em, `--ink`.
- **Code** (`code`, `kbd`, `samp`, `pre`): `--face-code` at `max(0.9em, --t-min)`,
  in `--ink`, not arc (arc means live or a link). Inline code sits on a
  `--panel-lit` slot with a 2px radius; `kbd` adds an engraved border. A `pre`
  block is an engraved slot: `--ground` fill, `--rule` border in `--engrave`,
  line-height 1.55, scrolls sideways instead of wrapping. Syntax colour stays
  within the palette's meanings (`.tok-*` in the starter): comments `--ink-dim`,
  keywords `--arc`, strings `--gold`, errors `--alert`. No rainbow themes.

### Scale depends on viewing distance

| Token | Wall, 2 m (`wall.css`) | Phone, arm's length (`starter.css`) |
|---|---|---|
| `--t-hero` | 9.25rem (148px) | `clamp(3.25rem, 17vw, 5.5rem)` |
| `--t-major` | 4.75rem | `clamp(1.75rem, 8vw, 2.75rem)` |
| `--t-readout` | 3rem | `clamp(1.375rem, 5.5vw, 1.875rem)` |
| `--t-headline` | 2.125rem | 1.25rem |
| `--t-body` | 1.625rem | 1rem |
| `--t-label` | 1.125rem | 0.8125rem |
| `--t-min` (floor) | 1rem (16px) | 0.75rem (12px) |

Nothing renders smaller than `--t-min`, including chart axes and SVG text.
Change the scale by **redefining the tokens once at `:root`**, never per
component. A wall display derives its root size from the viewport so it is
DPR-proof; `wall.css` explains the arithmetic. A phone or web app uses
`font-size: 100%`. A desktop page uses the phone scale in the 54rem column.

## Structure and spacing

- `--rule: 2px`. **Rules never drop below 2px**: hairlines smear or vanish, and
  the engraved look depends on them. Dividers between list items are
  `border-top: var(--rule) solid var(--engrave)`. The one exception is a chart
  gridline.
- `--gap` (wall 22px, phone 1rem), `--pad` (wall 28px, phone 1.25rem), `--bracket`
  (corner arm length: wall 26px, phone 1rem).
- **Radius: 0 or 2px.** Never rounded cards or pill shapes. Circles only for
  dials and chart point markers; status dots are square.
- **Nothing soft.** No drop shadows, glows, blur, or gradients that show as a
  fade or sheen. Two uses of the gradient *function* are fine because nothing
  looks like a gradient: drawing with flat colour (the bracket backgrounds
  below, a chevron), and a scrim that fades content into `--ground` under a
  sticky bar. A flat `inset 0 0 0 2px` box-shadow used as an outline is fine too.
- Content column on phone or web: `max-width: 54rem; margin: 0 auto;` and respect
  `env(safe-area-inset-*)`.

### The instrument (surface primitive)

`.instrument`: `--panel` face, `--pad` padding, an engraved bracket in the
top-left and bottom-right corners only, drawn with `::before` / `::after`.
Focused or expanded: `background: var(--panel-lit)`.

When the panel scrolls, or its pseudo-elements are taken, use
`.instrument-scroll`, which draws the same brackets as four flat background
layers so they stay on the panel's visible corners.

## Components

All of these are in `starter.css`. Copy them; don't re-derive them.

- **Button `.btn`**: min-height 48px, padding 0 1.25rem, radius 2px, `--rule`
  border in `--engrave`, transparent fill, mono uppercase text, hover fill
  `--engrave`, disabled opacity 0.35.
  - `.btn-primary`: `--arc` fill, `--ground` text, hover goes to `--ink`.
  - `.btn-quiet`: `--ink-dim` text. `.btn-danger`: `--alert` border and text.
  - `.btn-add`: full width, **dashed** border, `--arc` text.
- **FAB**: 60px square, radius 2px, `--arc` fill, `--ground` icon. The one job
  of a screen can take the same treatment at a larger size.
- **Top bar `.topbar`**: wordmark left, status right, an engraved rule under it.
- **Status control `.pill`**: borderless mono `--t-min` uppercase text with a
  `.dot`, `--ink-dim` going to `--ink` on hover, min-height 44px. The class is
  called pill; it has no pill shape.
- **Status dot `.dot`**: an 8px square in arc (ok), gold (error or attention),
  slate (offline, stale). "Syncing" blinks with `steps(2)`, not a smooth pulse.
  Colour is read before text, so the dot carries the state.
- **Tabs `.tabs`**: mono uppercase links on an engraved rule; the current one is
  arc with an arc underline (`aria-current="page"`).
- **Chip `.chip`**: an outlined mono toggle for filters; arc fill when
  `aria-pressed="true"`.
- **Inputs `.field`, `.input`**: `--panel` fill (`--ground` when on a panel),
  `--rule` `--engrave` border, min-height 48px, 1rem text, placeholder
  `--slate`. Focus shows as an `--arc-dim` border, not the ring.
- **Focus ring**: `:focus-visible { outline: var(--rule) solid var(--arc); outline-offset: 2px; }`
- **Tick box `.tick`**: an engraved square (`--rule` `--arc-dim` outline). When
  checked, an inset solid `--arc` square fills it. No check glyph.
- **List rows `.row`**: min-height 64px, `--engrave` rule between rows, title
  Archivo 600 1.125rem that turns `--arc` on hover, mono meta right-aligned.
- **Table `.table`**: label-style headers, engraved rules between rows, numbers
  right-aligned in mono.
- **Verdict / callout `.verdict`**: `--panel` with a 6px left border in the
  semantic colour (`--c`).
- **Sheet `.sheet`**: rises from the bottom over a `--ground` backdrop at 82%,
  never black. **Toast `.toast`**: `--panel-lit`, engraved border, one line and
  one action.
- **Stepper**: an `--engrave`-bordered group with 44px arc-coloured buttons and a mono label.
- **Dials and rings** (SVG): index ticks in `--engrave`, major ticks and ring in the
  semantic colour, `stroke-width` 2–4. Elapsed or progress shows as lit ticks. Broken
  dashes mean disconnected.
- **Back link `.back`**: mono uppercase `--ink-dim` with a `‹ ` prefix, `--arc` on hover.
- **Tags**: `--arc-dim` with a `#` prefix.
- **Empty state `.empty`**: centred, `--ink-dim`, title in label style coloured `--slate`, one action.
- **Loading `.placeholder`**: the page's shape in slate. It does not shimmer.

Touch targets are at least 44px everywhere.

## Motion

- Easing: `--ease: cubic-bezier(0.2, 0.7, 0.3, 1)`. Durations 160–520ms.
- Transitions on background and colour only. Content arriving may fade or slide in
  once (`arrive`, around 520ms).
- Attention flashes use `steps()` (a mechanical blink), never an elastic bounce.
- Nothing loops in the resting state except one meaningful indicator. No scrolling
  tickers: rotate and fade instead.
- Always include the `prefers-reduced-motion` block from the starter.

## States: design every one

- **Live**: arc. **Warning / late / almost**: gold. **Failed / impossible**: alert.
- **Stale** (may be old, still the best known value): `.is-stale`. Values go
  `--ink-dim`, lit marks go `--stale` (slate), countdowns freeze, and an age
  stamp sits beside them at full `--ink-dim`. Never keep ticking on data that
  can't refresh.
- **Expired** (past its useful life, no longer true: a departed train):
  `data-expired="true"` recedes the whole surface to opacity 0.34. Text at 0.34
  is under 3:1, so nothing inside is meant to be read. An age stamp that should
  be read means the state is stale, not expired.
- **Estimated or scheduled rather than live**: `.estimated`, a dotted underline, not a different colour.
- **Offline**: the token swap above. Keep the last data visible with an honest age stamp.
- **Unsent or local-only changes**: `.unsent`, a gold mono uppercase marker.
- **Loading**: a page-shaped placeholder in `--slate`, not a stray spinner.
- **Empty**: says what is empty ("Nothing planned"), with one action.

## Charts

`charts.css` has the classes. If a data-visualisation skill is available, use it
for choosing the chart form and for checking a palette; these rules replace its
colours.

- **The number first.** A hero or readout states the answer; the chart supports it.
- **Colour keeps its meaning.** Arc is the live or primary series, gold the warm
  or second one, slate is missing or off, alert is not a series colour. A dashed
  gold line is a plan or target. "Today" is arc; the other days are `--arc-dim`.
- **Fills step down, lines don't.** Bars and areas use `--c-1` / `--c-2` (the
  accents one step deeper), because a block of full-brightness arc glares on a
  panel. Lines, ticks and text use the full tokens.
- **A third series** needs a new colour under the "adding a colour" rule
  (violet `#b39cff` is the precedent). Check any new set for colour-vision
  separation and 3:1 against `--panel` before using it. Past three, use small
  multiples or direct labels instead of more hues.
- **Gridlines** are `--c-grid` and may be 1 unit thick, the only hairline in the
  system. The baseline is a 2px engraved rule. Few gridlines, no chart border.
- **Axis and legend text** is mono at `--t-min` or larger, in `--ink-dim`. An
  SVG that scales with its container scales its text too, so put axis labels in
  HTML (`.chart-axis`) or size the SVG text for the smallest width.
- **Tooltip** `.tip`: `--ground` fill, engraved border, mono. **Legend** keys are
  10px squares.
- No smoothing splines, drop shadows, area gradients or entrance animations.

## Icons and app identity

- Line icons on a 20-unit grid: stroke `--arc` (or `currentColor`), width ~1.6,
  round caps and joins, no fill (`.icon`).
- App icon: full-bleed `#0a0e14` square (so Android's masks cut only dark), the
  line mark inside the central 80% safe zone, optionally one engraved rule
  under it at 35% opacity. Ship the SVG, PNGs at 192 and 512 (plus maskable),
  and an apple-touch icon.
- `<meta name="theme-color" content="#0a0e14">`, `viewport-fit=cover`.

## Single-file pages and artifacts

- **One HTML file in a folder**: put the starter in a `<style>` block, make the
  font URLs relative (`fonts/…`) and keep the `fonts/` folder beside the page.
- **A published artifact**: publish the three Latin font files as supporting
  files next to the page and reference them the same relative way. If files
  can't be published with it, inline those three as base64 `data:` URLs (about
  90 KB). Add Manjari only if the page has Malayalam, and Monaspace Neon only if
  it shows code. Monaspace is too big to inline (about 680 KB as base64): if it
  can't be published as a file, leave it out and code falls back to Plex Mono.
  Don't fall back to a font CDN; without the files, `ui-monospace` and
  `system-ui` are the fallback.
- The page is dark in both themes: set `color-scheme: dark` and an explicit
  `--ground` body background, and don't write a light variant.

## Copy voice

Terse, instrument-like and honest. Labels are short uppercase nouns ("TONIGHT",
"INGREDIENTS", "METHOD"). State things plainly ("Nothing planned", "Not tonight",
"3 min"). No exclamation marks, no emoji in UI, no marketing tone. If a number
might be wrong, say how old it is.

## Don'ts

- Pure black, neon glow, drop shadows, glassmorphism, visible gradients.
- 1px hairlines, rounded cards, pill-shaped buttons.
- Hex grids, particles, scanlines, shimmer, ambient animation.
- Text below `--t-min`, or low-contrast "decorative" labels.
- A third accent colour used as decoration. Every colour needs a job.
- Google Fonts or CDN fonts. Self-host.
- Generic system UI defaults: Inter, Tailwind slate/indigo, Material components.
  If a project uses Tailwind, map its theme to these tokens.

## Checklist for a new project

1. Copy `starter.css` as the base stylesheet and `fonts/` into the public root.
   A project that never shows code can delete the Monaspace block and file.
   Add `wall.css` for a wall display, `charts.css` if there are charts.
2. Fill in the header comment: the project, the lineage, each deliberate departure.
3. Add semantic aliases for the project's states and document any new colour.
4. Design the offline, stale, expired, empty and loading states.
5. Icon, `theme-color` and manifest per the identity section.
6. Run `lint.sh <the project's source folder>` (`FLOOR_PX=16` for a wall) and
   fix every FAIL. Read each WARN and either fix it or mark the line
   `instrument-lint: ok` with the reason.
7. Look at it at 375px width, offline, and with reduced motion on.
