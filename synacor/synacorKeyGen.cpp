#include <iostream>
using namespace std;

//the buffers are static at startup
int g_srcBufferTablet[] = {21004, 25178, 4474};     //3#28398 _ mem
int g_srcBufferMaze[] = {6702, 31882, 8286};        //3#28300 _ mem
int g_srcBufferTP[] = {4657, 30347, 26626};        //3#29664 _ mem
int g_srcBufferTPHacked[] = {3263, 4481, 26832};        //3#29242 _ mem
int g_srcBufferMirror[] = {28494, 19355, 29616};        //3#29943 _ mem

//alphabets are static at startup
//"c"$52#25867 _ mem
char g_charBuffer[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
int g_charBufferLen = 52;

//"c"$23#25920 _ mem
char g_charBuffer2[] = "dbqpwuiolxv8WTYUIOAHXVM";
int g_charBuffer2Len = 23;

void printCode(int r0, int *srcBuffer, char *abc, int abcLen) {
    int tbuf[3];
    for (int i=0; i<3; ++i) tbuf[i] = srcBuffer[i];
    for (int i=0; i<12; ++i) {
        int tr = ((tbuf[i%3] * 5249 % 32768) + 12345) % 32768;
        tbuf[i%3] = tr;
        cout << abc[(r0^tr) % abcLen];
    }
    cout << endl;
}

int main() {
    //tablet code: all parameters are constants
    printCode(4242,g_srcBufferTablet,g_charBuffer,g_charBufferLen);

    //maze code
    //the xor key is based on the rooms visited in the maze,
    //it starts at 0 in the ladder room and various rooms in the maze
    //set a certain bit in the value, thus taking the correct route
    //(the only route without hacking) to the code yields 88 (8 | 16 | 64)
    printCode(88,g_srcBufferMaze,g_charBuffer,g_charBufferLen);

    //teleporter code
    //the xor key is based on the solution of the coin puzzle,
    //starting with 0, then for each element in the coin puzzle solution
    //add to the current number, multiply with 31660 and xor with the
    //same solution number
    //since the solution is 9 2 5 7 3, the number 2875 is derived like this:
    //(    0+9)*31660 = 22796, 22796 xor 9 = 22789
    //(22789+2)*31660 = 11700, 11700 xor 2 = 11702
    //(11702+5)*31660 =  4772,  4772 xor 5 =  4769
    //( 4769+7)*31660 = 16608, 16608 xor 7 = 16615
    //(16615+3)*31660 =  2872,  2872 xor 3 =  2875
    printCode(2875,g_srcBufferTP,g_charBuffer,g_charBufferLen);

    //hacked teleporter code
    //the xor key is the r7 value that is the solution to the puzzle: 25734
    printCode(25734,g_srcBufferTPHacked,g_charBuffer,g_charBufferLen);

    //vault code
    //the xor key is the xor of 3 values (n0, n1, n2)
    //based on the path traveled in the vault,
    //updated using the following parameters
    //- "id" is the label of the room: 0, 1, ... from top to bottom, skipping the
    //  bottom left room (orb)
    //- "cont" is the content of the room: the number, or +=0, -=1, *=2
    //- "step" is the number of steps taken, leaving the orb room is the first
    //- the 3 numbers (n0, n1, n2) start off as 0, for each step taken:
    //  - n0 <- n0 rol (2+step) xor id
    //  - n1 <- n1 rol (step*step) xor (id*id)
    //  - n2 <- n2 rol 13 xor (cont*cont*81)
    //  (rol is the rotate left operator)
    //- the correct path is this:
    //  step=1, id=8, cont=0 ('+') orb: 22+
    //    0 rol (1+2)  =     0,     0 xor 8         =     8
    //    0 rol (1*1)  =     0,     0 xor 8*8       =    64
    //    0 rol 13     =     0,     0 xor (0*0*81)  =     0
    //  step=2, id=9, cont=4 ('4') orb: 22+4 = 26
    //    8 rol (2+2)  =   128,   128 xor 9         =   137
    //   64 rol (2*2)  =  1024,  1025 xor 9*9       =  1105
    //    0 rol 13     =     0,     0 xor (4*4*81)  =  1296
    //  step=3, id=10, cont=1 ('-') orb: 26-
    //  137 rol (3+2)  =  4384,  4384 xor 10        =  4394
    // 1105 rol (3*3)  =  8721,  8721 xor 10*10     =  8821
    // 1296 rol 13     =   324,   324 xor (1*1*81)  =   277
    //  step=4, id=6, cont=11 ('11'), orb: 26-11 = 15
    // 4394 rol (4+2)  = 19080, 19080 xor 6         = 19086
    // 8821 rol (4*4)  = 17642, 17642 xor 6*6       = 17614
    //  277 rol 13     =  8261,  8261 xor (11*11*81)=  1548
    //  step=5, id=5, cont=2 ('*'), orb: 15*
    //19086 rol (5+2)  = 18250, 18250 xor 5         = 18255
    //17614 rol (5*5)  = 14886, 14886 xor 5*5       = 14911
    // 1548 rol 13     =   387,   387 xor (2*2*81)  =   199
    //  step=6, id=9, cont=4 ('4'), orb: 15*4 = 60
    //18255 rol (6+2)  = 20366, 20366 xor 9         = 20359
    //14911 rol (6*6)  =  4061,  4061 xor 9*9       =  3980
    //  199 rol 13     = 24625, 24625 xor (4*4*81)  = 25889
    //  step=7, id=10, cont=1 ('-'), orb: 60-
    //20359 rol (7+2)  =  3902,  3902 xor 10        =  3892
    // 3980 rol (7*7)  = 30913, 30913 xor 10*10     = 30885
    //25889 rol 13     = 14664, 14664 xor (1*1*81)  = 14617
    //  step=8, id=11, cont=18 ('18'), orb: 60-18 = 42
    // 3892 rol (8+2)  = 20601, 20601 xor 11        = 20594
    //30885 rol (8*8)  =  2655,  2655 xor 11*11     =  2598
    //14617 rol 13     = 11846, 11846 xor (18*18*81)= 18626
    //  step=9, id=10, cont=1 ('-'), orb: 42-
    //20594 rol (9+2)  =  5383,  5383 xor 10        =  5389
    // 2598 rol (9*9)  =  2437,  2437 xor 10*10     =  2529
    //18626 rol 13     = 21040, 21040 xor (1*1*81)  = 21089
    //  step=10, id=6, cont=11 ('11'), orb: 42-11 = 31
    //  5389 rol(10+2) = 21153, 21153 xor 6         = 21159
    //  2529 rol(10*10)=  1103,  1103 xor 6*6       =  1131
    // 21089 rol 13    = 13464, 13464 xor (11*11*81)=  4817
    //  step=11, id=2, cont=1 ('-'), orb: 31-
    // 21159 rol(11+2) = 29865, 29865 xor 2         = 29867
    //  1131 rol(11*11)=  2262,  2262 xor 2*2       =  2258
    //  4817 rol 13    =  9396,  9396 xor (1*1*81)  =  9445
    //  step=12, id=3, cont=1 ('1'), orb: 31-1 = 30
    // 29867 rol(12+2) = 31317, 31317 xor 3         = 31318
    //  2258 rol(12*12)=  9251,  9251 xor 3*3       =  9258
    //  9445 rol 13    = 10553, 10553 xor (1*1*81)  = 10600
    // 31318 xor 9258 xor 10600 = 30484
    printCode(30484,g_srcBufferMirror,g_charBuffer2,g_charBuffer2Len);
    return 0;
}