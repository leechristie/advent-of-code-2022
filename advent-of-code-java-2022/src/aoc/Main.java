package aoc;

import java.io.*;

public class Main {

    public static void main(String[] args) throws IOException {

        System.out.println("Advent of Code 2022");
        System.out.println();

        Day01.solve(new Puzzle<>(1,
                                 "Calorie Counting",
                                 new File("data/input01.txt"),
                                 66719,
                                 198551));

    }

}
