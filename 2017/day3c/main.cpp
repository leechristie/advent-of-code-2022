#include <chrono>
#include <iostream>

void locateRing(int accessPort,
                int &resultNum,
                int &resultX,
                int &resultY,
                int &resultCorner1,
                int &resultCorner2,
                int &resultCorner3,
                int &resultTerminator) {
    int num = 2;
    int currentRingSize = 8;
    int x = 1;
    int toFirstCorner = 1;
    int betweenCorners = 2;
    while (accessPort >= num + currentRingSize) {
        num += currentRingSize;
        currentRingSize += 8;
        x += 1;
        toFirstCorner += 2;
        betweenCorners = toFirstCorner + 1;
    }
    resultNum = num;
    resultX = x;
    resultY = x - 1;
    resultCorner1 = num + toFirstCorner;
    resultCorner2 = resultCorner1 + betweenCorners;
    resultCorner3 = resultCorner2 + betweenCorners;
    resultTerminator = resultCorner3 + betweenCorners;
}

void location(int accessPort, int &x, int &y) {
    int first;
    int corner1;
    int corner2;
    int corner3;
    int terminator;
    locateRing(accessPort, first, x, y, corner1, corner2, corner3, terminator);
    int current = first;
    while (current < corner1) {
        if (current == accessPort) {
            return;
        }
        y--;
        current++;
    }
    while (current < corner2) {
        if (current == accessPort) {
            return;
        }
        x--;
        current++;
    }
    while (current < corner3) {
        if (current == accessPort) {
            return;
        }
        y++;
        current++;
    }
    while (current < terminator) {
        if (current == accessPort) {
            return;
        }
        x++;
        current++;
    }
}

int numSteps(int accessPort) {
    if (accessPort == 1) {
        return 0;
    }
    int x;
    int y;
    location(accessPort, x, y);
    return abs(x) + abs(y);
}

int main() {
    const int accessPort = 312051;
    auto start = std::chrono::high_resolution_clock::now();
    int answer = numSteps(accessPort);
    auto stop = std::chrono::high_resolution_clock::now();
    std::cout << "Part 1: " << answer << std::endl;
    auto duration = duration_cast<std::chrono::microseconds>(stop - start);
    std::cout << "Time: " << duration.count() << "ms" << std::endl;
    return 0;
}
