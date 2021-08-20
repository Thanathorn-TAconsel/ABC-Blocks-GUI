char Boardarray[][] = { {'A','B','C','D'},{'E','F','G','H'},{'I','J','N','K'}};
String gamefilename = "gamesave.xml";
String gameversion = "3";
int PlayTime = 0;
long MoveCount = 0;
void setup() {
    
   try {
       LoadGame(gamefilename);
   }catch (Exception e) {
       randommap();
   }    
   
    frameRate(60);
    size(400,350);
    fill(120);
    rect(300, 200, 100, 100);
    textSize(16);    
    
    text("PlayTime: ", 10, 330);
    textSize(32);    
}   
int oldx,oldy;
float deltax,deltay;
int nextX = -1,nextY = -1,x,y;
int animationstate = 0;
boolean animationrunning = false;
boolean iswin = false;
int ptime = 0;
int ptimec = 0;
char point;

void draw() {
    if (!iswin){ptime = (PlayTime + millis()) / 1000;}
    if (ptime != ptimec) {
        ptimec = ptime;
        drawStatus();
    }
    if (mouseY < 300) {
        if ( (mousePressed || animationrunning) && !iswin) {
            moveBlock();
        } else {
            if (oldx != -1 && oldy != -1) {
                oldx = -1;
                oldy = -1;
                if ( (abs(deltax) >= 50 || abs(deltay) >= 50) && (nextX != -1) ) {
                    Boardarray[nextY][nextX] = Boardarray[y][x];
                    Boardarray[y][x] = 'N';
                    MoveCount++;
                    drawStatus();
                    SaveGame(gamefilename);
                }
                nextX = -1;
                for (int y = 0;y < 3;y++) {
                        for (int x = 0;x < 4;x++) {
                            fill(255);
                            rect(x*100, y*100, 100, 100);
                            fill(60);
                            if (Boardarray[y][x] == 'N')
                            text(' ',(x*100)+40, (y*100)+60);
                            else text(Boardarray[y][x], (x*100)+40, (y*100)+60);
                        }
                    }
                if (checkwin()) {
                    fill(255,255,255,200);
                    rect(0, 0, 400, 300);
                    fill(0);
                    text("YOU WIN", 130, 150);
                    randommap();
                    PlayTime = 0;
                    MoveCount = 0;
                    SaveNewGame(gamefilename);
                    iswin = true;
                } 
            }
        }
    }
}
void drawStatus() {
    textSize(16);    
        fill(255);
        rect(0, 300, 400, 50);
        fill(0);
        text("PlayTime: " + ptime/60 + " Minute " + ptime%60 + " Second" + "  MoveCount: " + MoveCount, 10, 330);
        textSize(32);    
}
void SaveGame(String filename) {
    String data = "<ABCBlockMAP><information><GameVersion>" + gameversion + "</GameVersion><PlayTime>" + (PlayTime + millis()) +"</PlayTime><MoveCount>" + MoveCount + "</MoveCount></information><Map><Row1>" + Boardarray[0][0] + Boardarray[0][1] + Boardarray[0][2] + Boardarray[0][3] + "</Row1><Row2>" +  Boardarray[1][0] + Boardarray[1][1] + Boardarray[1][2] + Boardarray[1][3] + "</Row2><Row3>"+  Boardarray[2][0] + Boardarray[2][1] + Boardarray[2][2] + Boardarray[2][3] + "</Row3></Map></ABCBlockMAP>";
    XML xml = parseXML(data);
    saveXML(xml,filename);
}
void SaveNewGame(String filename) {
    String data = "<ABCBlockMAP><information><GameVersion>" + gameversion + "</GameVersion><PlayTime>" + 0 +"</PlayTime><MoveCount>" + MoveCount + "</MoveCount></information><Map><Row1>" + Boardarray[0][0] + Boardarray[0][1] + Boardarray[0][2] + Boardarray[0][3] + "</Row1><Row2>" +  Boardarray[1][0] + Boardarray[1][1] + Boardarray[1][2] + Boardarray[1][3] + "</Row2><Row3>"+  Boardarray[2][0] + Boardarray[2][1] + Boardarray[2][2] + Boardarray[2][3] + "</Row3></Map></ABCBlockMAP>";
    XML xml = parseXML(data);
    saveXML(xml,filename);
}
void LoadGame(String filename) {
    final XML xml = loadXML(filename);
    XML information = xml.getChildren("information")[0];
    XML Map = xml.getChildren("Map")[0];
    String gameversion = information.getChildren("GameVersion")[0].getContent();
    PlayTime = Integer.valueOf(information.getChildren("PlayTime")[0].getContent());
    MoveCount = Integer.valueOf(information.getChildren("MoveCount")[0].getContent());
    String[] row = {Map.getChildren("Row1")[0].getContent(),Map.getChildren("Row2")[0].getContent(),Map.getChildren("Row3")[0].getContent()};
    for (int y = 0;y < 3;y++) {
        for (int x = 0;x < 4;x++) {
            Boardarray[y][x] = row[y].charAt(x);
        }
    }
}


/*
void LoadGame(String filename) {
    //byte[] loadtxt = loadBytes(filename);
    int nextindex = 0;
    String strin[] = loadStrings(filename);
    for (int y = 0;y < 3;y++) {
        String br[] = strin[y].split(",");
        for (int x = 0;x < 4;x++) {
            Boardarray[y][x] = br[x].charAt(0);
            nextindex++;
        }
    }
}
void SaveGame(String filename) {
    String sd[] = new String[3];
    int nextindex = 0;
    for (int y = 0;y < 3;y++) {
        sd[y] = "";
        for (int x = 0;x < 4;x++) {
            sd[y] += Boardarray[y][x];
            sd[y] += ',';
        }
    }
    saveStrings(filename, sd);
}
*/
/*
void SaveGame(String filename) {
    //byte[] saveline = new byte[24];
    int nextindex = 0;
    for (int y = 0;y < 3;y++) {
        for (int x = 0;x < 4;x++) {
            saveline[nextindex] = (byte) Boardarray[y][x];
            nextindex++;
            saveline[nextindex] = (byte) ',';
            nextindex++;
        }
    }
    saveBytes(filename, saveline);
}
*/
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
            
            if (Boardarray[y][x] == 'N')
            text(" ", (moveX)+40, (moveY)+60);
            else text(Boardarray[y][x], (moveX)+40, (moveY)+60);
            
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
    char BoardarrayWin[][] = { {'A','B','C','D'},{'E','F','G','H'},{'I','J','K','N'}};
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
        if (Boardarray[y][x-1] == 'N')
        return 'L';
    }
    if(x+1 <= 3) {
        if (Boardarray[y][x+1] == 'N')
        return 'R';
    }
    if(y-1 >= 0) {
        if (Boardarray[y-1][x] == 'N')
        return 'U';
    }
    if(y+1 <= 2) {
        if (Boardarray[y+1][x] == 'N')
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
    Boardarray[2][3] = 'N';
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