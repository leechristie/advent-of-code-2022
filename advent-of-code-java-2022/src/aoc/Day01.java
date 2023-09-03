package aoc;

import java.io.*;

public final class Day01 {

    public static void solve(final Puzzle<Integer> puzzle) throws IOException {
        Day01 day01 = new Day01(puzzle);
        day01.solve();
    }

    private final Puzzle<Integer> puzzle;

    // tracks the largest three numbers in descending order
    private int first = 0;
    private int second = 0;
    private int third = 0;

    private Day01(final Puzzle<Integer> puzzle) {
        this.puzzle = puzzle;
    }

    private void solve() throws IOException {

        try (BufferedReader in = new BufferedReader(new FileReader(puzzle.input()))) {

            // sum of current block
            int current = 0;

            String line;
            while ((line = in.readLine()) != null) {
                if (line.isEmpty()) {

                    // update the tracker if we end a block with a blank line
                    insert(current);
                    current = 0;

                } else {

                    // add the new number to the running total
                    current += Integer.parseInt(line);

                }
            }

            // update the tracker one more in case the file does not have a trailing blank line
            insert(current);

        }

        // part 1: the highest number, part 2: the sum of the three highest numbers
        puzzle.check(first,
                     first + second + third);

    }

    private void insert(final int current) {

        // replace 3rd highest
        if (current <= third)
            return;
        third = current;

        // replace 2nd highest
        if (third <= second)
            return;
        int temp = second;
        second = third;
        third = temp;

        // replace 1st highest
        if (second <= first)
            return;
        temp = first;
        first = second;
        second = temp;

    }

}
