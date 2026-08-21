#!/usr/bin/env bash
# Rebuild jimbocho/ — the 20-second demo cut the piece actually reads from.
#
# The masters ("Jimbocho STEMS (BPM143)/") are 183s and gitignored, as is
# everything this writes; jimbocho_impasto.socool is the only file that lands
# in the repo, so this script is how the piece gets its audio back.
#
# The window: twelve bars at 143 BPM (bar = 1.67832s) starting at bar 59.
# Chosen because t=100..114 is the ONLY stretch where all ten stems sound at
# once — Bass Synth doesn't enter until 78, Sax runs 86..113.5, and Clarinet is
# intermittent throughout. Verified against detected kick onsets: hits land on
# n*1.67832 to within 4ms, so bar 59 is a real downbeat and the cut loops.
#
# Peak-normalising is not cosmetic. Percussion 1 peaks at 0.097 in the master
# and FromSound's analyzer reports confidence-weighted amplitude — left alone
# that stem tracks almost nothing and its panel stays empty.
set -e
cd "$(dirname "$0")"
SRC="Jimbocho STEMS (BPM143)"
DST="jimbocho"
START=99.0209
DUR=20.1399

mkdir -p "$DST"
while IFS='|' read -r in out; do
  ffmpeg -y -v error -ss $START -t $DUR -i "$SRC/$in.wav" \
         -ac 1 -ar 48000 -c:a pcm_s16le "$DST/$out.wav"
done <<'STEMS'
Arp Synths|arps
Bass Arps|bass_arps
Bass Synth|bass_synth
Clarinet|clarinet
Kicks|kicks
Melody Synth|melody
Pad Synths|pads
Percussion 1|perc1
Percussion 2|perc2
Sax|sax
STEMS

python3 - "$DST" <<'PY'
import glob, os, sys, wave
import numpy as np

for f in sorted(glob.glob(os.path.join(sys.argv[1], "*.wav"))):
    w = wave.open(f, 'rb')
    params = w.getparams()
    a = np.frombuffer(w.readframes(w.getnframes()), dtype=np.int16).astype(np.float32)
    w.close()
    peak = np.abs(a).max()
    gain = (32768 * 0.891) / peak if peak > 0 else 1.0   # -1 dBFS
    out = np.clip(a * gain, -32768, 32767).astype(np.int16)
    o = wave.open(f, 'wb')
    o.setparams(params)
    o.writeframes(out.tobytes())
    o.close()
    print(f"{os.path.basename(f):14} peak {peak/32768:.4f} -> x{gain:.2f}")
PY

# The analyzer caches per (file, voices, fps) and keys on mtime, so new trims
# invalidate the old cache on their own — but stale entries for settings the
# piece no longer uses just sit there.
rm -rf "$DST/.weresocool_cache"
echo "wrote $DST/ — 10 stems, ${DUR}s each"
