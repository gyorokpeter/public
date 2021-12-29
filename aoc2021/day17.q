d17:{
    a:"J"$".."vs/:last each "="vs/:2_" "vs x except",";
    if[(a[0;0]<=0) or a[1;1]>=0; '"nyi"];
    xs:1+til a[0;1];
    xss:{0,sums reverse 1+til x}each xs;
    xsi:where any each xss within a[0];
    xs2:xs xsi;
    xss2:xss xsi;
    ys:a[1;0]+til 2*abs a[1;0];
    yss:{[lim;y]first each{[lim;yv]$[yv[0]<lim;yv;(yv[0]+yv[1];yv[1]-1)]}[lim]\[(0;y)]}[a[1;0]]each ys;
    ysi:where any each yss within a[1];
    ys2:ys ysi;
    yss2:yss ysi;
    f:{[a;r]
        xs:(min[count each r`xs`ys]#r`xs),(0|count[r`ys]-count[r`xs])#last r`xs;
        pos:xs,'r`ys;
        if[not any all each pos within'\: a; :()];
        enlist`xv`yv`pos!(r`xv;r`yv;max pos[;1])}[a];
    shots:raze f each([]xv:xs2;xs:xss2)cross([]yv:ys2;ys:yss2);
    shots};
d17p1:{exec max pos from d17[x]};
d17p2:{count d17[x]};

/
d17p1 x:"target area: x=20..30, y=-10..-5"
d17p2 x

OVERVIEW:
We generate x and y trajectories independently. An x trajectory can be valid if the starting
velocity is less than the x coordinate of the right edge of the target area.
For the y coordinate, if the initial velocity is positive, the trajectory will have a symmetric
non-negative section before returning to zero, and the first negative value will be one higher
than the starting velocity. We can use these facts to constrain the velocities. x needs to be
within 1..x2-1 and y needs to be within -y1..y1-1.
The x coordinates can be calculated by a combination of til and sums since they eventually reach
zero. But the y coordinate grows indefinitely so we need an iterated function that only halts when
the y coordinate is over the limit.
After getting these lists of coordinates, we filter them to those that have at least one within the
target zone.
Then we take the cross product of the x and y coordinate lists and match up the coordinates. This
needs cutting or extending the x cooridnates to match the length of the y coordinates. Then we
check if any of the points are indeed within the target area. If so, we return a one-row table with
the velocity and the highest y coordinate. Otherwise we return nothing. After razing these results,
we get a table that contains the answers for both parts, the answer to part 1 is the maximum of the
pos column and the one for part 2 is the count of the table.
