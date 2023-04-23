//
//  main.c
//  Advent of Code 2016 - C
//
//  Created by 0x1ac on 2023-04-19.
//

#include <stdio.h>
#include <stdlib.h>

enum Facing {
    NORTH,
    EAST,
    SOUTH,
    WEST
};

int main(int argc, const char * argv[]) {
    
    FILE *file = fopen("/Users/0x1ac/Developer/advent-of-code-2016/data/input01.txt", "r");
    if(file == NULL) {
       printf("error occoured opening file\n");
       exit(1);
    }
    
    int facing = NORTH;
    int x = 0;
    int y = 0;
    
    char currentDirection = '\0';
    int currentNumber = 0;
    
    int ci;
    while ((ci = fgetc(file)) != EOF) {

        char c = (char) ci;
        
        if (c == 'R' || c == 'L') {

            currentDirection = c;
            currentNumber = 0;

        } else if ('0' <= c && c <= '9') {

            int value = (int) (c - '0');
            currentNumber *= 10;
            currentNumber += value;

        } else if (c == ',' || c == '\n') {

            if (currentDirection == 'R') {
                facing++;
                if (facing > 3) {
                    facing = 0;
                }
            } else if (currentDirection == 'L') {
                facing--;
                if (facing < 0) {
                    facing = 3;
                }
            } else {
                printf("direction not set\n");
                exit(1);
            }
            
            if (facing == NORTH) {
                y += currentNumber;
            } else if (facing == EAST) {
                x += currentNumber;
            } else if (facing == SOUTH) {
                y -= currentNumber;
            } else if (facing == WEST) {
                x -= currentNumber;
            } else {
                printf("invalid facing: %i\n", facing);
                exit(1);
            }

        } else if (c == ' ') {

            // pass

        } else {

            printf("unknown char: %c\n", c);
            exit(1);

        }

    }
    
    printf("Part 1: %i\n", abs(x) + abs(y));
    
    fclose(file);

    return 0;
    
}
