package aoc2022.day19;

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Thing4 {

    public static void main(String[] args) throws IOException {

        final int TIME_LIMIT = 32;

        List<Blueprint> blueprints = new ArrayList<>();
        blueprints.add(new Blueprint(1, 4, 4, 4, 14, 3, 16));
        blueprints.add(new Blueprint(2, 4, 3, 3, 11, 4, 7));
        blueprints.add(new Blueprint(3, 4, 4, 3, 14, 3, 8));

        for (Blueprint blueprint : blueprints) {

            Simulation simulation = new Simulation(blueprint, TIME_LIMIT);
            System.out.println(blueprint);

            //pause();

            // no inserts: 6 * 45 * 19
            // 1 insert: 9 * 47 * 24

            int bestGeodes = -1;
            try (BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream("plans_2_insert_sample.csv")))) {
            //try (BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream("plans_1_insert.csv")))) {
            //try (BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream("plans.csv")))) {
                String line;
                while ((line = in.readLine()) != null) {
                    String[] tokens = line.strip().split(",");
                    int[] plan = new int[tokens.length];
                    for (int i = 0; i < tokens.length; i++) {
                        plan[i] = Integer.parseInt(tokens[i]);
                    }
                    int geodes = simulation.runVersion1(plan);
                    if (geodes > bestGeodes) {
                        bestGeodes = geodes;
                        System.out.println("Best for Blueprintt#" + blueprint.id() + ": " + geodes + " --- " + Arrays.toString(plan));
                    }
                }
            }

            //pause();

        }

    }

    private static void pause() throws IOException {
        System.out.println("press enter...");
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        br.readLine();
    }

}
