# Babarcade Broken Down

[Baba is You](https://hempuli.com/baba/) is normally about manipulating the rules in the level to end up with a winning situation. However when you reach the world named ["Babarcade"](https://babaiswiki.fandom.com/wiki/Babarcade) you will notice that suddenly something feels very different. Not a single rule in sight, or whatever is there is just a ___ IS WIN with just one tile having to be moved into place. However the game mechanics are nothing like those in the usual levels. Now you are playing a puzzle game where you select trains to move them out of each other's way. A shoot-em-up. A variation of Snake. A dungeon crawler. A platformer?! (That is really ugly when translated to a grid-based and turn-based system but still good effort there.)

It turns out that these levels do work like regular levels and all the unique mechanics are implemented in the Baba is You rule system. It's just that the rules are normally hidden. They can still be seen in the editor and images of these levels with the text revealed can be found on the Baba is You FANDOM wiki. Still when you look at that text, it's as if it came right out of the Obfuscated C Code Competition. Rules are all over the place, referring to random objects that don't even appear in the level. Therefore I decided to reverse engineer these levels and present the rules in a more logical arrangement. I discovered a few recurring patterns along the way.

The "BABA programming paradigm" includes techniques such as
 * Sprite swapping: for example a SAX may look like a CART. Different objects may share the same sprite, although possibly in a different color. This effect is also used in the "00" levels of "Land Land Land".
 * Stateful objects: objects turn into other objects when a certain event happens, putting them into a different state that reacts to other events.
 * Signal objects: an object only exists for one turn and causes another object to react via a WITHOUT or NOT WITHOUT rule. (There is no WITH condition but NOT WITHOUT does exactly that.)

## Baba Hour

[Source](https://babaiswiki.fandom.com/wiki/Baba_Hour?file=Baba_Hour_Rules.png)

Only the TRAIN (locomotive) and CART sprites are used, but under the hood these are various different objects. Each one has an "unselected" and a "selected" variant, and the two-part trains also have separate objects for the front part and the back part, with the two parts facing each other (so e.g. a horizontal train consists of a "left horizontal part" facing right and a "right horizontal part" facing left).

The meaning of each object is as follows:

 * BABA: unselected horizontal single train
 * BUG: selected horizontal single train
 * BEE: unselected vertical single train
 * CRAB: selected vertical single train
 * BOLT: unselected left part of horizontal double train
 * SAX: selected left part of horizontal double train
 * CART: unselected right part of horizontal double train
 * UFO: selected right part of horizontal double train
 * WORM: unselected top part of vertical double train
 * CAKE: selected top part of vertical double train
 * TURNIP: unselected bottom part of vertical double train
 * BURGER: selected bottom part of vertical double train

Rules:

```
TEXT ON TILE IS HIDE
```

Tiles are used to cover up most of the rules, the exception being the initially broken FLAG IS WIN.


```
CURSOR IS YOU AND PHANTOM
```

Allows you to control the cursor and disables collision on it so the cursor can go anywhere. Due to the other rules, it can only interact with the train objects.


```
IDLE STICK IS CURSOR
IDLE CURSOR IS STICK
```

Implements toggling between moving the cursor and moving a train. STICK is a placeholder for CURSOR while moving a train. STICK is not YOU, only CURSOR is, but you can freely switch back and forth between the two by idling.


```
SAX AND UFO IS YOU
BURGER AND CAKE IS YOU
CRAB AND BUG IS YOU
```

All the activated train sprites are YOU, allowing you to move them while they are selected.


```
ALL IS STOP
FLAG AND STICK IS NOT STOP
```

Prevents trains from overlapping or escaping the play area. STICK is an exception as the cursor (in its "idle" state) should not block trains, and similarly FLAG as a train needs to go over the flag to complete the FLAG IS WIN rule.


```
BUG AND BABA IS RIGHT
BEE AND CRAB IS DOWN
SAX AND BOLT IS RIGHT
UFO AND CART IS LEFT
CAKE AND WORM IS DOWN
BURGER AND TURNIP IS UP
```

Each train/wagon object is forced into its designated direction to make the selection mechanism work, and also this visually maintains the orientation of the trains.


```
UFO AND SAX AND BUG IS vLOCKED and ^LOCKED
CAKE AND BURGER AND CRAB IS <LOCKED and >LOCKED
```

Forces trains to move only in their designated directions. Horizontal trains are prevented from moving up/down and vertical trains are prevented from moving left/right.


```
IDLE TURNIP ON CURSOR IS BURGER
IDLE WORM ON CURSOR IS CAKE
IDLE CART ON CURSOR IS UFO
IDLE BOLT ON CURSOR IS SAX
IDLE BEE ON CURSOR IS CRAB
IDLE BABA ON CURSOR IS BUG
```

First part of the selection mechanism: whatever train piece is under the cursor transforms into its "selected" variant when idling.


```
IDLE BOLT FACING CURSOR IS SAX
IDLE CART FACING CURSOR IS UFO
IDLE TURNIP FACING CURSOR IS BURGER
IDLE WORM FACING CURSOR IS CAKE
```

Second part of the selection mechanism: the other part of two-part trains also becomes selected. This is where trains being composed of two objects facing each other becomes important. There is no rule necessary for the locomotives.


```
IDLE BURGER IS TURNIP
IDLE CAKE IS WORM
IDLE UFO IS CART
IDLE SAX IS BOLT
IDLE CRAB IS BEE
IDLE BUG IS BABA
```

Unselect mechanism: "selected" objects transform back to their "unselected" variants when idling. At the same time the STICK also transforms back into CURSOR, allowing another train to be selected.

## Baba Invaders

[Source](https://babaiswiki.fandom.com/wiki/Baba_Invaders?file=Baba+Invaders+Rules.gif)

The only sprite swap used here is the enemy projectile which looks like a red BOLT but in reality it's a SEED. There are also some objects hidden in the level:
 * A line of objects on the right and left side, which serve as guides for the moving enemies. Initially there is a line of BATs on the left and a line of BURGERs on the right.
 * A line of DUST at the top and bottom of the level to swallow projectiles.
 * Two SUNs which are blocked by pipes and clouds to only be able to move up, and when this happens, they form the rules ROCKET MAKE BOLT and ME IS TILE, which are part of the shooting mechanism.
 * Two MEs in the positions where the texts moved by the SUNs end up, which take part in resetting the shooting mechanism.

Rules:

### Basics

These rules identify the player and enemies, as well as the win/loss conditions.

```
BAT IS HIDE
ME AND SUN IS HIDE
MOON AND TILE IS HIDE
BOOK AND BURGER AND ARROW AND BAT IS HIDE
TEXT AND BEE IS HIDE
PIPE IS HIDE
```

The machinery of the level is hidden.

```
ROCKET IS YOU AND ^LOCKED AND vLOCKED AND UP
```

The rocket behaves as you would expect from an "Invaders" game: it can only move left and right and always faces up.

```
BABA AND KEKE AND UFO IS GROUP
```

The three enemies are put into a group to simplify some rules.

```
ROCKET WITHOUT GROUP IS WIN
```

Since ROCKET is also YOU, when all the enemies are destroyed you immediately win.

```
GROUP AND SEED IS DEFEAT
```

Touching any enemy or their projectiles results in a loss.

```
DUST ON GROUP IS ARROW
ROCKET NOT WITHOUT ARROW IS DEFEAT
```

Alternative defeat condition if the enemies reach the bottom row. ARROW is an arbitrary object to convey state.

```
LEVEL WITHOUT ROCKET IS WEAK
```

After defeat the entire level also disintegrates. Doesn't seem to have an impact on gameplay.

```
CLOUD IS STOP
```

The clouds act as a barrier so you can't move out of bounds.

### Enemy movement and attack

These rules are responsible for making the enemies move left/right until they reach the edge of the level, then move down one row and start moving in the other direction.

```
GROUP ON BURGER IS POWER
BABA AND GROUP ON BEE IS POWER
```

Power is used to indicate when the enemies should move down and switch between going left and right. POWER is activated when the enemies reach the line of "guide" objects on either side. Not sure why there is an extra BABA in the BEE rule.

```
POWERED GROUP IS vNUDGE
```

This is one of the main uses of power: whenever the enemies hit the guide objects, they move down one line.

```
POWERED BOOK IS BURGER
POWERED BURGER IS BOOK
POWERED BAT IS BEE
POWERED BEE IS BAT
```

This is the other use of power: the guide objects switch between two states, the right one between BOOK and BURGER, and the left one between BAT and BEE. Due to the rules on what is POWER, the transformation also immediately turns off POWER.

```
GROUP WITHOUT BOOK IS >NUDGE
GROUP WITHOUT BURGER IS <NUDGE
```

This makes the enemies move in the current direction. Initially only the WITHOUT BOOK rule is active, and this flips whenever POWER is triggered.

```
SEED IS SHUT AND DOWN
```

The enemy projectile faces down so that's the direction it travels. It is also SHUT for the purpose of killing you.

```
SELDOM AND SELDOM UFO MAKE SEED
```

SELDOM is a unique property that only appears in this level and acts as a randomizer. This makes UFOs randomly shoot projectiles at you. Note that the other enemies don't shoot.

```
SEED IS AUTO
BOLT IS AUTO
```

Projectiles move automatically.

```
BOLT ON DUST IS EMPTY
SEED ON DUST IS EMPTY
```

Projectiles disintegrate when they reach the far edge of the level.

### Player attack

There is an entire category of rules just to let the player attack by pressing up.

```
BOLT IS SHUT
GROUP ON BOLT IS OPEN
```

Makes the player's projectiles kill the enemies.

```
SUN NOT WITHOUT ME IS YOU
```

SUNs are the primary actors in the player shooting mechanic. They can only move up, which completes two rules, one of which turns ME into TILE so SUN is no longer YOU, resulting in the mandatory delay between two shots.

```
SUN IS vFALL
```

SUNs fall down, so you can continue shooting by repeatedly pressing up.

```
_incomplete_ ROCKET MAKE BOLT
```

Moving the SUNs up completes this rule, making the rocket fire a projectile.

```
_incomplete_ ME IS TILE
TILE IS MOON
MOON IS ME
```

The other rule that is completed by SUNs moving up, and this is kicks off a sequence to reset the firing mechanism. The MEs go through a three-phase transformation. While they are not MEs you can't control the SUNs so you can't shoot again. The TILE phase is probably just for extra delay, so you need to wait 3 turns between shots. When they become MEs again the text has already fallen down so the sequence doesn't repeat until shooting again.

```
TEXT ON MOON IS vFALL
SUN IS STOP
```

Resets the player shooting rules by making their respective first words fall. This happens as part of the MEs' transforming cycle. Since SUN is also FALL and STOP, the text ends up above the SUNs, exactly where it was in the initial state of the level.

```
PIPE IS STOP
```

Mainly to prevent SUNs from moving in any direction but up.

## Gravity Chamber

[Source](https://babaiswiki.fandom.com/wiki/Gravity_Chamber?file=Gravity+Chamber+Rules.gif)

The interesting bit of this level is the actual gravity mechanism.

On the right side of the level there is a small piped-off area containing a bit of ice as well as the texts BABA and BOX stacked. ```TEXT NOT ON TILE IS YOU``` makes these texts controllable (every other bit of text is on tiles). Moving in any direction moves the texts to complete the rules ```BABA+BOX IS FALL``` in the corresponding direction. The tiles that the text just moved to contain grass and ```TEXT ON GRASS IS WEAK``` so the texts are destroyed, however new copies spawn on the ice thanks to ```ICE MAKE BOX AND BABA``` - this creates actual objects, but these quickly get destroyed due to ```BOX AND BABA ON ICE IS MELT``` (they are also ```HOT``` due to another rule), and since ```BABA AND BOX HAS TEXT```, they drop their text equivalents, ready to be controlled on the next move.

A small glitch is that after the first move, there is nothing that is YOU and it takes another turn for the spawned Baba and box to become text, making you have to skip that turn. There is also no effort to hide the Baba and box in the "control room" so they just remain there and explode every turn.

## Snakeke

[Source](https://babaiswiki.fandom.com/wiki/Snakeke?file=Snakeke+Rules.gif)

The only sprite swap is CART made to look like KEKE. The real KEKE is the one in the front, while the rest of the "snake" is made up of CARTs.

Rules:

```
TEXT AND BAT AND BLOB IS HIDE
BURGER AND CAKE AND EAR IS HIDE
TEXT ON GRASS IS NOT HIDE
```

As usual the level machinery is hidden, with the exception of text on grass, which is the incomplete KEKE IS WIN rule that is formed if the WORM moves all the way to the right.

```
KEKE ON CART IS ROCKET
LEVEL NOT WITHOUT ROCKET IS WEAK
```

The loss condition, running into your tail results in the level disintegrating. ROCKET is a placeholder object used just to convey this state.

```
CART IS MOVE
```

The tail of the snake moves forward. This is not enough for them to really act like a snake, but...

```
CART FOLLOW KEKE AND CART
```

This makes each piece of the snake's tail always face the piece in front of it, including the head which is a KEKE, thus this is responsible for the actual "snake" effect. I guess this relies on the creation order of objects to break ties in case there is more than one part of the snake adjacent to a particular piece because otherwise it would be possible to break the snake by letting the head move parallel with the tail.

```
WALL IS STOP
```

This prevents the fruit from spawning outside the play area. It also effectively makes running into a wall a loss condition because of the CART IS MOVE rule, which makes the snake's tail trample over its head if it tries to move into a wall.

```
NOT IDLE KEKE IS YOU
IDLE KEKE IS AUTO
```

These let you control the snake both by pressing in a direction as well as idling. This means idling will switch to the "tumbleweed" music because in effect nothing is YOU, but it still allows you to regain control of KEKE by trying to move as that results in the NOT IDLE condition being true.

### The fruit mechanism

This is the interesting part as it uses multiple state objects with transformation sequences, as well as a randomization feature to spawn the next fruit. Notice that there is a hidden CAKE and BURGER on screen which are part of this mechanism. Let's start from the state when there is a fruit on screen.

```
FRUIT ON KEKE IS EAR AND BAT
```

When the snake's head moves over a fruit, it creates two state objects - both are invisible due to the HIDE rules.

```
BAT IS EMPTY
WORM NOT WITHOUT BAT IS NUDGE
```

The BAT state object is simply used to move the worm towards its goal and then disappears immediately.

```
EAR NOT ON CART AND NOT ON KEKE IS CART AND CAKE AND POWER
POWERED CAKE IS BURGER
```

This adds a new segment to the snake once the snake moves off the location where the fruit was picked up. In addition to creating the snake segment (CART), it creates a new CAKE which is the first state of the fruit state object. In the meantime it also triggers POWER just for one step which advances the previous CAKE into BURGER, which will then start wandering around waiting for the new fruit to be picked up.

```
BURGER NOT WITHOUT EAR IS BLOB
```

The other state object, EAR, triggers a change from BURGER to BLOB, which is the next object in its transformation sequence.

```
BLOB AND BURGER IS CHILL
```

CHILL is another unique property that acts as a randomizer - it makes the affected object randomly move around, in case of BURGER or BLOB the purpose of this is to find a new place for a fruit to spawn. It keeps moving as the player is busy picking up the current fruit.

```
BLOB NOT ON CART AND NOT ON KEKE IS FRUIT
```

As the next part of the transformation sequence, the BLOB becomes the next fruit for the player to pick up, but only if it is not overlapping the snake, otherwise it keeps searching for a good spawn position.

## Darkish Dungeon

[Source](https://babaiswiki.fandom.com/wiki/Darkish_Dungeon?file=Darkish_Dungeon.jpg)

Sprite swaps:
 * CAKE looks like FOOT. IT shows the foot on the HUD.
 * RING looks like EYE. It shows the eye on the HUD.
 * COG looks like KEY. It is the key pickup that appears in the world. The keys on the HUD are actual KEYs.
 * SEED looks like BANANA although this object is hidden. It is a placeholder for keys on the HUD.

Furthermore other special objects are used in the level:
 * TRIANGLE is a placeholder for hearts on the HUD.
 * BUCKET and WIND are the "writing head" for the keys on the HUD.
 * PLANET and PUMPKIN are the "writing head" for the hearts on the HUD.

Rules:

```
BABA IS 3D AND HOT
```

Establishes the player character. The HOT property is used for destroying some objects as detailed below.

```
TEXT IS HIDE
BOOK AND CIRCLE AND SQUARE AND SEED AND WIND AND BUCKET AND PIANO AND PLANET AND PUMPKIN AND TRIANGLE AND PANTS IS GROUP
GROUP IS HIDE
```

As usual the level machinery is hidden. Since we are in 3D, hiding the text only makes the rules not appear on the pause screen. The objects in GROUP are mostly state objects so they have good reason to be hidden.

```
FLAG IS WIN
```

Simple win condition.

```
BABA WITHOUT LOVE IS DEFEAT
```

The loss condition is running out of health, which is represented by LOVE objects.

```
ROCK IS PUSH
```

Straightforward.

```
WALL AND HEDGE AND CLIFF IS GROUP2
GROUP2 IS STOP
```

Establishes the wall-type objects. Note that WALL does have specific rules to implement the "fake" walls.

```
COG AND BURGER AND GHOST AND SKULL AND FOOT AND EYE IS GROUP3
GROUP3 IS MELT
```

This group is the objects that disappear when touched by the player. These include pickups and enemies.

```
GHOST FACING WALL IS >TURN
GHOST IS AUTO
```

The behavior of ghosts - they move until they hit a wall, at which point they turn right.

```
SKULL HAS PANTS
GHOST HAS PANTS
BABA ON BOG AND NOT WITHOUT FOOT MAKE PANTS
PANTS IS EMPTY
```

PANTS is a signal object for taking damage. Signal objects only exist for one turn. Moving into a skull or ghost MELTs them but also results in taking damage. If you don't have the foot pickup and move over a bog, you take damage by spawning the signal object. Note that FOOT refers to the pickup, not the item displayed on the HUD, therefore the condition is "NOT WITHOUT FOOT", i.e. the condition is true if the pickup still exists in the level.

```
BURGER HAS PIANO
PIANO IS EMPTY
```

Similarly, PIANO is a signal object for gaining health.

```
DOOR HAS CIRCLE
CIRCLE IS EMPTY
```

CIRCLE is the signal object for using up a key.

```
DOOR IS STOP
DOOR NOT WITHOUT KEY IS WEAK
```

Doors normally block you unless you have a key, in which case they are WEAK and thus spawn the CIRCLE "use up key" signal object when opened. KEY itself appears on the HUD so the condition for you having a key is "NOT WITHOUT KEY".

```
COG HAS SQUARE
SQUARE IS EMPTY
```

SQUARE is the signal object for picking up a key.

```
PLANET AND PUMPKIN AND WIND AND BUCKET IS PUSH
```

These objects are part of the "write heads", they are all PUSH so moving one part of the head also moves the other.

```
PLANET NOT WITHOUT PIANO IS >NUDGE
PUMPKIN NOT WITHOUT PANTS IS <NUDGE
```

PLANET and PUMPKIN are part of the "write head" for the player's health. The respective signal objects cause them to move left/right.

```
LOVE ON PUMPKIN IS TRIANGLE
TRIANGLE ON PLANET IS LOVE
```

This is how the "write head" actually "writes" the player's health, by toggling it between TRIANGLE (empty slot) and LOVE (filled slot).

```
WIND NOT WITHOUT CIRCLE IS <NUDGE
BUCKET NOT WITHOUT SQUARE IS >NUDGE
KEY ON WIND IS SEED
SEED ON BUCKET IS KEY
```

Similarly this is how the "write head" works for the keys, toggling them between KEY and SEED.

```
RING NOT WITHOUT EYE IS HIDE
CAKE NOT WITHOUT FOOT IS HIDE
```

The icons on the HUD are hidden as long as the corresponding objects exist in the level. These are one-off pickups so no other special handling is required.

```
WALL ON BOOK AND WITHOUT EYE IS CYAN AND NOT STOP
```

The BOOK object indicates fake walls. Once you pick up the eye, these walls are highlighted in cyan and you can go through them.

## Jump Up, Babastar

[Source](https://babaiswiki.fandom.com/wiki/Jump_Up,_Babastar?file=Jump+Up%2C+Babastar+Rules.png)

Sprite swaps:
 * BOOK looks like an inner pipe segment.
 * BOX looks like an active ? block.
 * BUBBLE looks like DUST although it is never shown long enough to notice.
 * CA$H looks like an inactive ? block.
 * FOLIAGE looks like a red BOX.
 * HUSK looks like a top pipe segment.

I think the sprites for BOX and CA$H are swapped because CA$H has the brighter sprite, while you would expect the used ? block to be darker.

Rules:

```
KEKE AND DUST AND TRIANGLE AND UFO AND WORM AND TEXT AND BURGER AND WATER IS GROUP
GROUP IS HIDE
TEXT ON TILE IS NOT HIDE
```

As usual the level machinery is hidden. The only exception is ORB IS BONUS which is visible.

```
BABA IS YOU AND STOP
BABA IS vFALL
FLAG IS WIN
FIRE IS DEFEAT
```

Straightforward.

```
FOLIAGE IS PUSH
FOLIAGE IS vFALL
```

Also straightforward, just keep in mind that FOLIAGE looks like a red BOX.

```
PIXEL IS STOP
CA$H AND CLOUD IS STOP
PIXEL AND HEDGE AND BOOK AND HUSK AND RUBBLE AND BOX IS STOP
```

Also obvious. PIXEL is the barrier that surrounds the lower right area. Having it in two STOP rules is redundant.

```
LEVEL IS BLUE
```

Doesn't seem to have any effect.

```
JIJI IS MOVE AND vFALL
```

The enemies move around. FALL is normally not relevant since they are prevented from falling, although it can happen (glitch?).

```
JIJI FACING DUST IS >TURN AND >TURN
```

DUST acts as a guide at the end of platforms to force enemies to turn around.

```
BABA IS OPEN
JIJI WITHOUT WATER IS SHUT
```

Enemies defeat the player on contact. WATER is a signal object that disables this behavior while jumping as seen below.

```
BABA IS HOT
JIJI NOT WITHOUT WATER AND ON BABA IS MELT
```

Baba can defeat enemies by jumping. Again it uses WATER as a signal object.

```
BURGER WITHOUT BOX IS ORB
```

Once all the question mark blocks are opened, the ORB appears.

```
BOX IS OPEN
BOX FACING BABA MAKE BUBBLE
BUBBLE IS SHUT
BUBBLE HAS CA$H
```

Collectively these rules implement the opening of ? blocks. When you approach them from below, a BUBBLE is created, which OPENs the BOX and also turns the BUBBLE into CA$H (the inactive ? block).

### The jumping mechanic

```
KEKE IS <LOCKED AND >LOCKED
KEKE IS YOU
```

There are two hidden KEKEs in the lower right area. They can only move up which initiates a jump.

```
_incomplete_ BABA IS ^NUDGE
```

This rule is completed by moving KEKE up, which also breaks BABA IS vFALL so you don't fall while jumping.

```
_incomplete_ KEKE IS UFO
```

The other rule that is formed by moving KEKE up, also breaking KEKE IS YOU, UFO IS KEKE and WORM IS WATER in the process. UFO is a state-changed KEKE that exists during jumping.

```
TRIANGLE NOT WITHOUT UFO MAKE WORM
WORM IS AUTO
KEKE AND UFO IS PUSH
```

WORM acts as the countdown timer for when a jump should end. It is spawned from the TRIANGLEs when jumping and starts moving down. On its second move, it restores the initial state of the jumping mechanism, including moving the UFOs into their original positions, breaking the rules KEKE IS UFO and BABA IS ^NUDGE, and making the rules WORM IS WATER, KEKE IS YOU, UFO IS KEKE and BABA IS vFALL.

```
WORM IS WATER
WATER IS EMPTY
```

Note that WORM IS WATER is disabled while jumping and reactivates when the jump should end. At this moment it turns into WATER which is a signal object, allowing you to stomp enemies while falling.

```
UFO IS KEKE
```

Disabled while jumping. At the end of the jump, it reactivates, returning KEKE to its original state.
