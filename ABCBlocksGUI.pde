char Boardarray[][] = { {'A','B','C','D'},{'E','F','G','H'},{'I','J',' ','K'}};
String gamefilename = "gamesave.txt";
void setup() {
    
   try {
       LoadGame(gamefilename);
   }catch (Exception e) {
       randommap();
   }    
    frameRate(60);
    size(400,300);
    textSize(32);    
    fill(120);
    rect(300, 200, 100, 100);
    
}   
int oldx,oldy;
float deltax,deltay;
int nextX = -1,nextY = -1,x,y;
int animationstate = 0;
boolean animationrunning = false;
boolean iswin = false;
char point;
void draw() {
    if ( (mousePressed || animationrunning) && !iswin) {
        moveBlock();
    } else {
        if (oldx != -1 && oldy != -1) {
            oldx = -1;
            oldy = -1;
            if ( (abs(deltax) >= 50 || abs(deltay) >= 50) && (nextX != -1) ) {
                Boardarray[nextY][nextX] = Boardarray[y][x];
                Boardarray[y][x] = ' ';
                SaveGame(gamefilename);
            }
            nextX = -1;
            for (int y = 0;y < 3;y++) {
                    for (int x = 0;x < 4;x++) {
                        fill(255);
                        rect(x*100, y*100, 100, 100);
                        fill(60);
                        text(Boardarray[y][x], (x*100)+40, (y*100)+60);
                    }
                }
            if (checkwin()) {
                fill(255,255,255,200);
                rect(0, 0, 400, 300);
                fill(0);
                text("YOU WIN", 130, 150);
                randommap();
                SaveGame(gamefilename);
                iswin = true;
            } 
        }
    }
}
void LoadGame(String filename) {
    byte[] loadtxt = loadBytes(filename);
    int nextindex = 0;
    for (int y = 0;y < 3;y++) {
        for (int x = 0;x < 4;x++) {
            Boardarray[y][x] = (char)loadtxt[nextindex];
            nextindex++;
        }
    }
}
void SaveGame(String filename) {
    byte[] saveline = new byte[12];
    int nextindex = 0;
    for (int y = 0;y < 3;y++) {
        for (int x = 0;x < 4;x++) {
            saveline[nextindex] = (byte) Boardarray[y][x];
            nextindex++;
        }
    }
    saveBytes(filename, saveline);
}
void moveBlock() {
       
    if (oldx == -1 && oldy == -1) {
            oldx = mouseX;
            oldy = mouseY;
            int location[] = mapMouseLocationtoBlock(mouseX,mouseY);
            x = location[0];
            y = location[1];
            point = CheckAvilableMove(x,y);
        }
        if (!mousePressed && animationrunning) {
            rendermovingBlock();
        } else {
            deltax = mouseX - oldx;
            deltay = mouseY - oldy;
            if (abs(deltax) >= 50 || abs(deltay) >= 50)  {
                animationstate = 0;
            } else {
                animationstate = 1;
            }
            animationrunning = true;
        }
        textSize(32);
             
        
        
        fill(255);
        if (point != '0') {

            nextX = x;
            nextY = y;
            if (point == 'U') {
                deltay = limitvalue(deltay,-100,0);
                deltax = 0;
                nextY -= 1;
                rect( x*100, nextY*100, 100, 100);
            }
            if (point == 'D') {
                deltay = limitvalue(deltay,0,100);
                deltax = 0;
                nextY += 1;
                rect( x*100, nextY*100, 100, 100);
            }
            if (point == 'L') {
                deltax = limitvalue(deltax,-100,0);
                deltay = 0;
                nextX -= 1;
                rect(nextX*100, y*100, 100, 100);
            }
            if (point == 'R') {
                deltax = limitvalue(deltax,0,100);
                deltay = 0;
                nextX += 1;
                rect( nextX*100, y*100, 100, 100);
            }
            int moveX = (int)deltax + (x*100);
            int moveY = (int)deltay + (y*100);
            rect( x*100, y*100, 100, 100);
            if (mousePressed) {
                fill(200);
            }
            rect( moveX, moveY, 100, 100);
            fill(60);
            text(Boardarray[y][x], (moveX)+40, (moveY)+60);
        } else {
            animationrunning = false;
            renderBlock(x,y);
        }
}
void rendermovingBlock() {
    if (animationstate == 0) {
        if (point == 'U') {
            deltay-=(100-abs(deltay))/5.0;
        }
        if (point == 'D') {
            deltay+=(100-abs(deltay))/5.0;
        }
        if (point == 'L') {
            deltax-=(100-abs(deltax))/5.0;
        }
        if (point == 'R') {
            deltax+=(100-abs(deltax))/5.0;
        }
        if (abs(deltax) >= 97 || abs(deltay) >= 97)  {
            animationrunning = false;
            
        }
    } else {
        if (point == 'U') {
            deltay+=(abs(deltay))/5.0;
        }
        if (point == 'D') {
            deltay-=(abs(deltay))/5.0;
        }
        if (point == 'L') {
            deltax+=(abs(deltax))/5.0;
        }
        if (point == 'R') {
            deltax-=(abs(deltax))/5.0;
        }
        if (abs(deltax) <= 3 && abs(deltay) <= 3)  {
            animationrunning = false;
        }
    }
}
void renderBlock(int x,int y) {
    fill(255,120,120);
    rect( x*100, y*100, 100, 100);
    fill(0,0,0);
    text(Boardarray[y][x], (x*100)+40, (y*100)+60);
}
boolean checkwin() {
    char BoardarrayWin[][] = { {'A','B','C','D'},{'E','F','G','H'},{'I','J','K',' '}};
    for (int y =0;y < 3;y++) {
        for (int x =0;x < 4;x++) {
            if (Boardarray[y][x] != BoardarrayWin[y][x])return false;
        }
    }
    return true;
}
float limitvalue(float x,int min,int max) {
    if (x > max) {
        return max;
    } else if (x < min) {
        return min;
    }
    return x;
}
char CheckAvilableMove(int x,int y) { 
    if(x-1 >= 0) {
        if (Boardarray[y][x-1] == ' ')
        return 'L';
    }
    if(x+1 <= 3) {
        if (Boardarray[y][x+1] == ' ')
        return 'R';
    }
    if(y-1 >= 0) {
        if (Boardarray[y-1][x] == ' ')
        return 'U';
    }
    if(y+1 <= 2) {
        if (Boardarray[y+1][x] == ' ')
        return 'D';
    }
    return '0';   
    
}

int[] mapMouseLocationtoBlock(int x,int y) {
    int location[] = {0,0};
    location[0] = x / 100;
    location[1] = y / 100;
    return location;
    
}

void randommap(){   
    char abc[] = {'A','B','C','D','E','F','G','H','I','J','K'};

    for (int y = 0;y < 3;y++) {
        for (int x = 0;x < 4;x++) {
            if (abc.length > 0) {
                int indextoremove = (int)random(abc.length);
                Boardarray[y][x] = abc[indextoremove];
                abc = removeArray(abc,indextoremove);
            }
        }
    }
    Boardarray[2][3] = ' ';
}
char[] removeArray(char[] inputarray,int indextoremove) {
    if (inputarray.length > 0) {
        char[] outputarray = new char[inputarray.length - 1];
        int index = 0;
        for (int i = 0;i < inputarray.length;i++) {
            if (i != indextoremove) {
                outputarray[index] = inputarray[i];
                index++;
            }
        }
        return outputarray;
    }
    return new char[0];
}