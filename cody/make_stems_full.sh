#!/usr/bin/env bash
# Full-length stems — the whole track, not the twelve-bar demo cut.
# Same treatment as make_stems.sh otherwise: mono, 48k, peak-normalised to
# -1 dBFS per stem, because FromSound's analyzer reports confidence-weighted
# amplitude and a stem left at its mix level tracks almost nothing.
# Normalisation is over the WHOLE track here, so the balance differs slightly
# from the twelve-bar cut, where each stem was normalised against that window.
set -e
cd "$(dirname "$0")"
SRC="Jimbocho STEMS (BPM143)"
DST="jimbocho_full"
mkdir -p "$DST"
while IFS='|' read -r in out; do
  ffmpeg -y -v error -i "$SRC/$in.wav" -ac 1 -ar 48000 -c:a pcm_s16le "$DST/$out.wav"
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
    w = wave.open(f, 'rb'); params = w.getparams()
    a = np.frombuffer(w.readframes(w.getnframes()), dtype=np.int16).astype(np.float32); w.close()
    peak = np.abs(a).max()
    gain = (32768 * 0.891) / peak if peak > 0 else 1.0
    out = np.clip(a * gain, -32768, 32767).astype(np.int16)
    o = wave.open(f, 'wb'); o.setparams(params); o.writeframes(out.tobytes()); o.close()
    print(f"{os.path.basename(f):14} peak {peak/32768:.4f} -> x{gain:.2f}")
PY
rm -rf "$DST/.weresocool_cache"
echo "wrote $DST/ — 10 stems, full length"
