# How to extract level data from GemCraft: Frostborn Wrath

1. Open GemCraft: Frostborn Wrath.swf in [JPEXS Decompiler](https://github.com/jindrapetrik/jpexs-decompiler)
2. Export the files scripts/com/giab/games/gcfw/stages/StageCollection1 and StageCollectionIron1.
3. Open levels_skeleton.js. Copy the level data from StageCollection1 (the first line to copy is "this.stageDatasJ = ...." and the last one is "this.stageDatasT.push...") into the skeleton as indicated by the comment.
4. Run the resulting JavaScript. For example you could copy it into a browser's Developer Tools console and run it.
5. The JavaScript should print a long JSON. Save this to levels.json.
6. Repeat steps 3.-5. for StageCollectionIron1 (note that it only has stageDatasJ) and save the JSON output as levelsIron.json.
7. Copy config.example.q to config.q and update the values as appropriate for your machine. Load config.q before loading process.q.
8. Further details are found in process.q.
