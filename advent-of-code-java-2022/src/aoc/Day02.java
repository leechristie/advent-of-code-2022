package aoc;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Day02 {

    private Day02() {}

    public static void solve(final Puzzle<Integer> puzzle) throws IOException {

        int part1 = 0;
        int part2 = 0;

        try (BufferedReader in = new BufferedReader(new FileReader(puzzle.input()))) {

            String line;
            while ((line = in.readLine()) != null) {


                // A for Rock, B for Paper, and C for Scissors
                int opponentOrdinal = (int) line.charAt(0) - (int) 'A';


                // PART 1 - meaning of X, Y, Z is your move

                // X for Rock, Y for Paper, and Z for Scissors
                int youOrdinalPart1 = (int) line.charAt(2) - (int) 'X';

                // 1 for Rock, 2 for Paper, and 3 for Scissors
                part1 += youOrdinalPart1 + 1

                // 0 if you lost, 3 if the round was a draw, and 6 if you won
                //  - just some ugly modular arithmetic with the ordinals
                         + (((3 + youOrdinalPart1 - opponentOrdinal) % 3 + 1) % 3) * 3;


                // PART 2 - meaning of X, Y, Z is changed to your outcome

                // X means lose, Y means draw, and Z means win
                int youOutcomePart2 = (int) line.charAt(2) - (int) 'X';

                // 1 for Rock, 2 for Paper, and 3 for Scissors
                //  - some more ugly modular arithmetic with the ordinals
                part2 += (youOutcomePart2 + ((3 + opponentOrdinal - 1) % 3)) % 3 + 1

                // 0 if you lost, 3 if the round was a draw, and 6 if you won
                         + youOutcomePart2 * 3;


            }

        }

        puzzle.check(part1, part2);

    }

}
