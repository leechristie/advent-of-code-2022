package aoc;

import java.io.*;

public final class Day01 {

    public static void solve(final Puzzle<Integer> puzzle) throws IOException {

        // tracks the largest three numbers in descending order
        int[] most = new int[3];

        try (BufferedReader in = new BufferedReader(new FileReader(puzzle.input()))) {

            // sum of current block
            int current = 0;

            String line;
            while ((line = in.readLine()) != null) {
                if (line.isEmpty()) {

                    // update the tracker if we end a block with a blank line
                    insert(most, current);
                    current = 0;

                } else {

                    // add the new number to the running total
                    current += Integer.parseInt(line);

                }
            }

            // update the tracker one more in case the file does not have a trailing blank line
            insert(most, current);

        }

        // part 1: the highest number, part 2: the sum of the three highest numbers
        puzzle.check(most[0],
                     most[0] + most[1] + most[2]);

    }

    private static void insert(final int[] most,
                               final int current) {

        // replace 3rd highest
        if (current <= most[2])
            return;
        most[2] = current;

        // replace 2nd highest
        if (most[2] <= most[1])
            return;
        int temp = most[1];
        most[1] = most[2];
        most[2] = temp;

        // replace 1st highest
        if (most[1] <= most[0])
            return;
        temp = most[0];
        most[0] = most[1];
        most[1] = temp;

    }

}
