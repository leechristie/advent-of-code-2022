#include <stdio.h>
#include <stdbool.h>
#include <time.h>

#define END_OF_INPUT_FILE (-1)
#define END_OF_INPUT_BLOCK (-2)
#define ERROR_END_OF_FILE_WITHOUT_LINE_BREAK (-3)
#define ERROR_UNKNOWN_CHARACTER (-4)

int readBlockSum(FILE *file);
int readIntLine(FILE *file);

bool finished = false;

int main() {

    printf("Advent of Code 2022\n");

    clock_t time = clock();

    FILE* file;
    file = fopen("../data/input01.txt", "r");

    if (file == NULL) {
        printf("ERROR: COULD NOT OPEN INPUT FILE!\n");
        return 1;
    }

    int first = 0;
    int second = 0;
    int third = 0;

    int current;
    while (true) {
        current = readBlockSum(file);
        if (current == ERROR_END_OF_FILE_WITHOUT_LINE_BREAK) {
            printf("ERROR: END OF FILE WITHOUT LINE BREAK!\n");
            fclose(file);
            return 1;
        } else if (current == ERROR_UNKNOWN_CHARACTER) {
            printf("ERROR: UNKNOWN CHARACTER!\n");
            fclose(file);
            return 1;
        } else if (current == END_OF_INPUT_FILE) {
            break;
        }
        if (current <= third) {
            continue;
        }
        third = current;
        if (third <= second) {
            continue;
        }
        int temp = second;
        second = third;
        third = temp;
        if (second <= first) {
            continue;
        }
        temp = first;
        first = second;
        second = temp;
    }

    int sum = first + second + third;

    time = clock() - time;

    double time_taken = ((double) time) / CLOCKS_PER_SEC;

    printf("Part 1: %i\n", first);
    printf("Part 2: %i\n", sum);
    printf("Time: %f seconds\n", time_taken);

    fclose(file);
    return 0;

}

int readBlockSum(FILE *file) {
    int current;
    int sum = 0;
    while (true) {
        current = readIntLine(file);
        if (current == END_OF_INPUT_FILE) {
            if (finished) {
                return END_OF_INPUT_FILE;
            } else {
                finished = true;
                if (sum == 0) {
                    return END_OF_INPUT_FILE;
                }
                return sum;
            }
        } else if (current == END_OF_INPUT_BLOCK) {
            return sum;
        } else if (current == ERROR_END_OF_FILE_WITHOUT_LINE_BREAK || current == ERROR_UNKNOWN_CHARACTER) {
            return current;
        } else {
            sum += current;
        }
    }
}

int readIntLine(FILE *file) {
    int current = 0;
    int character;
    while (true) {
        character = fgetc(file);
        if (character == EOF) {
            if (current == 0) {
                return END_OF_INPUT_FILE;
            } else {
                return ERROR_END_OF_FILE_WITHOUT_LINE_BREAK;
            }
        }
        if (character == '\n') {
            if (current > 0) {
                return current;
            }
            return END_OF_INPUT_BLOCK;
        }
        if (character < '0' || character > '9') {
            return ERROR_UNKNOWN_CHARACTER;
        }
        current *= 10;
        current += character - '0';
    }
}
