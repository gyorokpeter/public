# Need for Speed 3 music player
The music in Need for Speed 3 is quite unique as it's not a linear track or loop, but each track has
multiple segments, and which one gets played depends on in-game conditions. Usually, music player
applications that recognize the NFS file format play the linearized versions, which are often quite
subpar as they skip a lot of segments.

This project is an interactive music player for NFS3 that allows you to jump to any segment and then
automatically plays the appropriate sequence of segments from there. There is extra logic to attempt
to detect the various loops in each track (corresponding to different sections in the in-game map)
for each "power level". There is also a manual power level slider for jumping between the different
variants of the same loop.

## Research
I have used some of the research in [GameAudioPlayer](https://github.com/ValeryAnisimovsky/GameAudioPlayer/) (GAP)
as well as some of the code as a template to implement the decoding the audio data. GAP's research
is missing some details on the .MAP/.LIN formats and suggests using the linearized version for
playback. I was interested in how those files are actually structured and whether it's actually
possible to extract the individual music loops.

### Power levels
A unique feature of NFS3 is that the intensity of the music changes according to racing conditions.
Some of this mechanism is reflected in the music files - in particular the .MAP records that
indicate the next segments can have multiple next segments corresponding to different power levels.
The power level is a number that can range from 0 to 100. I didn't research how the power level is
determined in the game, but it's clear that higher power levels correspond to more intense versions
of the music (which is why I chose the term "power level"). In GAP's research, the next
segment record contains three fields: `bUnknown`, `bMagic` and `bNextSection`, and it notes that
the non-nteractive tracks have a value of 0x64 (100) in `bMagic`. In reality, `bUnknown` is the
minimum power level and `bMagic` is the maximum power level. Since non-interactive playback always
follows the same sequence, the minimum power level is always set to 0 and the maximum to 100, so
this is where the use of 100 is coming from. In the interactive versions, there are usually three
ways the music can continue based on the power level (two for the pursuit segments). The thresholds
in the power levels are erratically set (e.g. between 26-33 for the upper bound of the low-power
segment and 69-76 for the upper bound of the middle-power segment), so if you are racing at the
power boundary (not sure if this is actually possible to control that precisely), the music might
jump back and forth between different intensities.

### Trigger table
In GAP's research, there is a "seemingly useless" record in the .MAP file. I call this the trigger
table (`triggers` in `lin.sch`), and it contains the IDs of certain important music segments.
Here is the example for Hometown Techno:
```
189 189 189 189 189 189 189 189 189 189 189 189 189 189 189 189
115 113 112 189 0   40  189 117 189 189 189 189 189 189 189 189
115 113 112 189 16  48  189 125 189 189 189 189 189 189 189 189
115 113 112 189 24  64  189 133 189 189 189 189 189 189 189 189
115 113 112 189 0   40  80  189 141 189 189 189 189 189 189 189
115 113 112 189 16  48  88  189 149 189 189 189 189 189 189 189
115 113 112 189 24  64  96  189 157 189 189 189 189 189 189 189
115 113 112 189 189 40  189 117 141 189 189 189 189 189 189 189
115 113 112 189 189 48  189 125 149 189 189 189 189 189 189 189
115 113 112 189 189 64  189 133 157 189 189 189 189 189 189 189
116 189 189 189 24  64  96  133 157 181 189 189 189 189 189 189
115 113 113 189 16  48  88  125 149 173 189 189 189 189 189 189
116 113 112 189 0   189 80  189 141 165 189 189 189 189 189 189
116 113 112 189 16  189 88  189 149 173 189 189 189 189 189 189
116 113 112 189 24  189 96  189 157 181 189 189 189 189 189 189
116 113 112 189 189 40  80  189 189 165 189 189 189 189 189 189
116 113 112 189 189 48  88  189 189 173 189 189 189 189 189 189
116 113 112 189 189 64  96  189 189 181 189 189 189 189 189 189
116 113 112 189 189 189 189 117 141 189 189 189 189 189 189 189
116 113 112 189 189 189 189 125 149 189 189 189 189 189 189 189
116 113 112 189 189 189 189 133 157 189 189 189 189 189 189 189
115 113 112 189 16  189 189 125 189 189 189 189 189 189 189 189
```
I haven't been able to figure out which trigger is for what purpose, only some general patterns:
- For some tracks, the starting segment (189 in this case) is used as a filler. In others, 0 is used
as a filler instead even if that is not the starting segment, which is annoying because it's not
possible to confirm where 0 is being used for its value and where as a filler.
  - Hometown Rock has an apparent alternate starting segment (171, where 170 is the normal one).
171 is used in a few rows as a filler instead of 170.
- Sometimes there are rows full of fillers, especially the first row, but this is not true for every
track.
- The first column contains the crash segments, with the occasional filler. They are repeated a
couple of times. Possibly this is to have one for each map section and power level, but this doesn't
add up with the fact that _columns_ are used for map sections in other triggers.
- The second and third columns contain the pursuit segments. There are random breaks in the pattern
of which one is in which column and there are also sometimes fillers here. There are two pursuit
segments for most tracks, a low-power and high-power one.
- The fourth column is typically fillers, but sometimes it's another column with a pursuit segment.
- The fifth and further columns are for the regular segments of the music. Each column corresponds
to a different section of the game map. Unneeded columns are filled with fillers, and sometimes
fillers appear in columns that also contain meaningful segments. Rows correspond to different power
levels, but there is a lot of repetition here that I can't explain.

## Usage
Prerequisites:
* [finos/kdb](https://github.com/finos/kdb) for the module system
* [qutils](https://github.com/gyorokpeter/qutils) for the web interface
* [qbinparse](https://github.com/gyorokpeter/qbinparse) for the binary parsing

For setup, copy `config.example.q` to `config.q` and update the paths accordingly.

To load, first load the FINOS bootstrapper, then `.finos.dep.include` the file `nfs3.q`.
```
\l d:/....../finos_init.q
.finos.dep.include"d:/....../nfs3.q"
```

This will load all the music files and cache them in the `data` directory. This is a very slow
process (a few minutes per track) because q is so bad at sequential operations and binary
operations, and this music importing does both.

Once loaded, open a server port in the `q` process and connect to it from a browser. The loaded
tracks are listed. Choose one to bring up the player. Click on `start` to star with the first
segment as defined in the music file, or click on any button corresponding to a segment. The "Loops"
section contains all the loops detected in the music, ordered by map section and power level, but
only on a best effort basis due to the erratic structure of the trigger table.
