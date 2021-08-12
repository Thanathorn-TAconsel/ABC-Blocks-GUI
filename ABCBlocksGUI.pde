char Boardarray[][] = { {'A','B','C','D'},{'E','F','G','H'},{'I','J',' ','K'}};
char BoardarrayWin[][] = { {'A','B','C','D'},{'E','F','G','H'},{'I','J','K',' '}};
int moveCount = 0;
void setup() {
    /*
    fill(0);
    textSize(32);
    text("LNZ", 0, 40); // Large
    */

    //randommap();
    frameRate(60);
    size(400,300);
    textSize(32);
    
    fill(120);
    rect(300, 200, 100, 100);
    smooth();

}   
int oldx,oldy;
float deltax,deltay;
int location[];
int nextX = -1,nextY = -1,x,y;
int animationstate = 0;
boolean animationrunning = false;
char point;
void draw() {
    if (mousePressed || animationrunning) {

        if (oldx == -1 && oldy == -1) {
            oldx = mouseX;
            oldy = mouseY;
            location = mapMouseLocationtoBlock(mouseX,mouseY);
        }
        if (!mousePressed && animationrunning) {
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
        x = location[0];
        y = location[1];        
        
        point = CheckAvilableMove(x,y); 
        //surface.setTitle(point + " " + x + "," + y);
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
            //surface.setTitle(moveX + "," + moveY);
        } else {
            animationrunning = false;
            fill(255,120,120);
            rect( x*100, y*100, 100, 100);
            fill(0,0,0);
            text(Boardarray[y][x], (x*100)+40, (y*100)+60);
        }
    } else {
        surface.setTitle("Stoped");
        if (oldx != -1 && oldy != -1) {
            oldx = -1;
            oldy = -1;
            if ( (abs(deltax) >= 50 || abs(deltay) >= 50) && (nextX != -1) ) {
                Boardarray[nextY][nextX] = Boardarray[y][x];
                Boardarray[y][x] = ' ';
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
            } else {
               
            }
        }
    }
    
    /*
    background(0, 0, 0, 0);
    int[] loc = mapMouseLocationtoBlock(mouseX,mouseY);
    fill(255);
    textSize(16);
    text(loc[0] + "," +loc[1], 0, 40);
    */
}
boolean checkwin() {
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
/*
void randommap(){   
    ArrayList<char> abc = new ArrayList<char>();
    abc.add({'A','B','C','D','E','F','G','H','I','J','K'});
    for (int y = 0;y < 3;y++) {
        for (int x = 0;x < 4;x++) {
            
            Boardarray[y][x]
        }
    }
        /*
    while (len(Boardarray) > 0){
        int rand = (int)random(1, len(Boardarray));
        Boardarray[(int)(moveCount / 4)][moveCount % 4] = Boardarray.pop(rand);
        moveCount ++;
    }
    
}
*/
/*
void renderMovingBlock(){

}


*/

/*
// Get a random element from an array
String[] words = { "apple", "bear", "cat", "dog" };
int index = int(random(words.length));  // Same as int(random(4))
println(words[index]);  // Prints one of the four words

*/