StringToolbox = {
    base64ZipDecodeString:function(pData) {
        return pData.replaceAll("_","=");
    }
}

StageType = {
    NORMAL:0,
    SECRET:1,
    STORY_RELATED:2,
    TILE_GIVING:3,
    EPIC:4
}

function StageMetaData(pStrId, pMapX, pMapY, pType, pOrbDrops, pStashDrops)
{
    this.strId = pStrId;
    this.mapX = pMapX;
    this.mapY = pMapY;
    this.type = pType;
    this.orbDrops = pOrbDrops;
    this.stashDrops = pStashDrops;
}

function StageCollection1()
{
    //paste level data here
}

var a = new StageCollection1()
console.log(JSON.stringify(a))
