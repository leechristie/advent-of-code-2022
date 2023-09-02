package aoc;

import java.io.*;
import java.text.*;
import java.util.*;

public final class Puzzle<T> {

    private final int day;
    private final String name;
    private final File input;
    private final T expected1;
    private final T expected2;

    private final long start;

    public File input() {
        return this.input;
    }

    public Puzzle(final int day,
                  final String name,
                  final File input,
                  final T expected1,
                  final T expected2) {

        Objects.requireNonNull(input, "input");
        Objects.requireNonNull(name, "name");
        Objects.requireNonNull(input, "expected1");
        Objects.requireNonNull(input, "expected2");

        this.day = day;
        this.name = name;
        this.input = input;
        this.expected1 = expected1;
        this.expected2 = expected2;

        // start the timer
        this.start = System.nanoTime();

    }

    public Puzzle(final int day,
                  final String name,
                  final File input,
                  final T expected1) {

        Objects.requireNonNull(input, "input");
        Objects.requireNonNull(name, "name");
        Objects.requireNonNull(input, "expected1");

        this.day = day;
        this.name = name;
        this.input = input;
        this.expected1 = expected1;
        this.expected2 = null;

        // start the timer
        this.start = System.nanoTime();

    }

    public Puzzle(final int day,
                  final String name,
                  final File input) {

        Objects.requireNonNull(input, "input");
        Objects.requireNonNull(name, "name");

        this.day = day;
        this.name = name;
        this.input = input;
        this.expected1 = null;
        this.expected2 = null;

        // start the timer
        this.start = System.nanoTime();

    }

    public void check(final T answer1, final T answer2) {

        // stop the timer
        long time = System.nanoTime() - start;

        // validate answers if known, used for refactoring without breaking the solver
        if (expected1 != null) {
            if (!expected1.equals(answer1))
                throw new AssertionError(
                        "expected " + expected1 + " for day " + day +  " part 1, but found " + answer1);
        }
        if (expected2 != null) {
            if (!expected2.equals(answer2))
                throw new AssertionError(
                        "expected " + expected2 + " for day " + day + " part 2, but found " + answer2);
        }

        // print outcome for day's puzzle
        System.out.println("--- Day " + day + ": " + name + " ---");
        System.out.println("Part 1: " + answer1);
        System.out.println("Part 2: " + answer2);
        System.out.println("Time: "
                + (new DecimalFormat("0.000")).format(time / 1_000_000_000.0) + " seconds");
        System.out.println();

    }

}
