#!/usr/bin/env bash
# Checks stylesheets against the Instrument rules that can be checked by
# pattern. It does not judge the design; it catches the slips.
#
#   lint.sh [path ...]          files or directories (default: .)
#   FLOOR_PX=16 lint.sh src     wall scale: 16px type floor instead of 12px
#
# Directories are searched for .css, .scss, .html, .vue, .svelte, .jsx and
# .tsx, skipping node_modules, dist and build. A line that breaks a rule on
# purpose can carry the comment  instrument-lint: ok  with its reason.
#
# Exit status: 1 if any FAIL, otherwise 0. WARN lines need a look, not a fix.

set -u
FLOOR_PX="${FLOOR_PX:-12}"
[ $# -eq 0 ] && set -- .

files=()
for p in "$@"; do
  if [ -d "$p" ]; then
    while IFS= read -r f; do files+=("$f"); done < <(
      find "$p" \( -name node_modules -o -name dist -o -name build -o -name .git \) -prune -o \
        -type f \( -name '*.css' -o -name '*.scss' -o -name '*.html' -o -name '*.vue' \
        -o -name '*.svelte' -o -name '*.jsx' -o -name '*.tsx' \) -print | sort)
  elif [ -f "$p" ]; then
    files+=("$p")
  else
    echo "lint.sh: no such file or directory: $p" >&2; exit 2
  fi
done
[ ${#files[@]} -eq 0 ] && { echo "lint.sh: nothing to check" >&2; exit 2; }

awk -v floor="$FLOOR_PX" '
function report(level, msg) {
  printf "%s  %s:%d  %s\n      %s\n", level, FILENAME, FNR, msg, substr(trimmed, 1, 110)
  if (level == "FAIL") fails++; else warns++
}
FNR == 1 { incomment = 0 }
{
  line = $0
  trimmed = line; sub(/^[ \t]+/, "", trimmed)
  if (line ~ /instrument-lint: *ok/) next

  # Drop comments, so prose about a rule is not read as a breach of it.
  code = line
  if (incomment) {
    if (match(code, /\*\//)) { code = substr(code, RSTART + 2); incomment = 0 } else next
  }
  while (match(code, /\/\*/)) {
    head = substr(code, 1, RSTART - 1); rest = substr(code, RSTART + 2)
    if (match(rest, /\*\//)) code = head " " substr(rest, RSTART + 2)
    else { code = head; incomment = 1; break }
  }
  low = tolower(code)

  if (low ~ /prefers-reduced-motion/) reduced = 1
  if (low ~ /tabular-nums/) tabular = 1
  if (low ~ /--(arc|engrave|ground) *:/) tokens = 1

  # Hairlines.
  if (low ~ /(^|[^0-9.])1px +(solid|dashed|dotted)/) report("FAIL", "1px rule: rules never drop below 2px (var(--rule))")

  # Radius: 0 or 2px, or 50% for a dot or dial.
  if (match(low, /border(-[a-z]+)*-radius *:[^;}]*/)) {
    v = substr(low, RSTART, RLENGTH); sub(/^[^:]*:/, "", v)
    n = split(v, part, /[ \/]+/); bad = 0
    for (i = 1; i <= n; i++) {
      t = part[i]
      if (t == "" || t == "0" || t ~ /^(0|1|2)px$/ || t == "50%" || t ~ /^(inherit|initial|unset)$/) continue
      bad = 1
    }
    if (bad) report("FAIL", "radius is 0 or 2px (50% only for dots and dials)")
  }

  # Shadows, glows, blur.
  if (low ~ /box-shadow *:/ && low !~ /box-shadow *: *(none|inset 0 0 0 )/) report("FAIL", "box-shadow: no shadows or glows (a flat inset outline is fine)")
  if (low ~ /text-shadow *:/ && low !~ /text-shadow *: *none/) report("FAIL", "text-shadow: no glow")
  if (low ~ /(backdrop-filter|filter) *:[^;]*blur\(/) report("FAIL", "blur: no glass, no soft focus")

  # Gradients: flat-colour drawing is fine, a visible fade needs a reason.
  if (low ~ /(radial|conic)-gradient\(/) report("WARN", "radial/conic gradient: only for a dial drawn in CSS")
  else if (low ~ /linear-gradient\(/) {
    g = low; flat = 1
    while (match(g, /linear-gradient\([^()]*(\([^()]*\)[^()]*)*\)/)) {
      inner = substr(g, RSTART + 16, RLENGTH - 17)
      g = substr(g, RSTART + RLENGTH)
      # Flat means both stops are the same colour.
      m = split(inner, st, /, */)
      if (!(m == 2 && st[1] == st[2])) flat = 0
    }
    if (!flat) report("WARN", "gradient: allowed as a drawing technique or a scrim to --ground, not as decoration")
  }

  # Pure black.
  if (low ~ /#000([^0-9a-f]|$)/ || low ~ /#000000([^0-9a-f]|$)/ || low ~ /: *black *[;}]/ || low ~ /rgba?\( *0[ ,]+0[ ,]+0[ ,\/)]/) report("FAIL", "pure black: use var(--ground)")

  # Font CDNs.
  if (low ~ /fonts\.(googleapis|gstatic)\.com|fonts\.bunny\.net|use\.typekit\.net/) report("FAIL", "font CDN: self-host the fonts")

  # Type floor.
  if (match(low, /font-size *: *[0-9.]+(px|rem)/)) {
    v = substr(low, RSTART, RLENGTH); sub(/^[^:]*: */, "", v)
    num = v + 0
    px = (v ~ /rem$/) ? num * 16 : num
    # In wall.css terms rem is not 16px, so only px is checked above a 12px floor.
    if ((v ~ /px$/ || floor <= 12) && px < floor) report("FAIL", "type below the floor (" floor "px): use var(--t-min) or larger")
  }

  # Light theme.
  if (low ~ /prefers-color-scheme *: *light/) report("WARN", "light theme: the style is dark only")

  # Colours outside the tokens.
  rest = low; gsub(/--[a-z0-9-]+ *:[^;}]*/, "", rest)   # token definitions are where hex belongs
  if (rest ~ /#[0-9a-f]{3,8}([^0-9a-z_-]|$)/ && rest !~ /(href|url\(|theme-color)/) report("WARN", "raw colour: give it a token and a job")

  if (low ~ /animation[^;]*infinite/) loops++
}
END {
  if (tokens && !reduced) { printf "FAIL  no prefers-reduced-motion block in the files checked\n"; fails++ }
  if (tokens && !tabular) { printf "WARN  no tabular-nums in the files checked\n"; warns++ }
  if (loops > 1) { printf "WARN  %d looping animations: at most one thing moves at rest\n", loops; warns++ }
  printf "%d failed, %d to look at, %d file%s checked\n", fails, warns, ARGC - 1, (ARGC - 1 == 1 ? "" : "s")
  exit (fails > 0)
}
' "${files[@]}"
