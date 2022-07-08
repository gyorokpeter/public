\P 16

.sts.importSave:{[fh]
    raw:`byte$.base64.b64decode first read0 fh;
    decoded:`char$bitxor'[count[raw]#"key";raw];
    .json.parse decoded};

.sts.exportSave:{[fh;data]
    raw:.j.j data;
    encoded:`char$bitxor'[count[raw]#"key";raw];
    out:.base64.b64encode encoded;
    fh 0: enlist out};

//fh:`$":D:/Program Files/Steam/steamapps/common/SlayTheSpire/saves/IRONCLAD.autosave"
//data:.sts.importSave fh
//data[`is_ascension_mode]:1b
//data[`ascension_level]:10
//data[`cards]:([]upgrades:1; misc:1000; id:50#("Madness";"Omega"));
//data[`relics]:enlist"Unceasing Top"
//.sts.exportSave[fh;data]
