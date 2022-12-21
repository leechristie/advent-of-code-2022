package aoc2022.day19;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.concurrent.ArrayBlockingQueue;

public class MainPart2 {

    public static void main(String[] args) {

        try (PrintWriter p = new PrintWriter(new FileWriter(new File("output.txt")))) {

            int rownum = 0;

            for (int fixedLength = 3; fixedLength <= 16; fixedLength++) {

                // set up the blueprints
                List<Blueprint> blueprints = new ArrayList<>();

                blueprints.add(new Blueprint(1, 4, 4, 4, 14, 3, 16));
                blueprints.add(new Blueprint(2, 4, 3, 3, 11, 4, 7));
                blueprints.add(new Blueprint(3, 4, 4, 3, 14, 3, 8));

                // set the time limit and max plan length
                final int TIME_LIMIT = 32;

                // create the tasks
                int numTasks = blueprints.size();
                Queue<Task> queue = new ArrayBlockingQueue<>(numTasks);
                for (Blueprint blueprint : blueprints) {
                    Simulation simulation = new Simulation(blueprint, TIME_LIMIT);
                    queue.offer(new Task(simulation, fixedLength));
                }
                assert queue.size() == numTasks;

                // result tracker
                final int[] best = new int[blueprints.size()];
                Arrays.fill(best, Simulation.FAIL);

                Task current;
                while ((current = queue.poll()) != null) {
                    Simulation simulation = current.simulation();
                    ResultRecord rr = simulation.runAllVersion3(current.length());
                    int geodes = rr.bestGeodes();
                    List<int[]> bests = rr.bests();
                    if (geodes > best[simulation.blueprint().id() - 1]) {
                        best[simulation.blueprint().id() - 1] = geodes;
                    }

                    System.out.println("---> "
                            + ';'
                            + current.length()
                            + ';'
                            + geodes
                            + ';'
                            + bests.size());

                    for (int[] b : bests) {
                        p.println((rownum++) + ";" + simulation.blueprint().id()
                                + ';'
                                + current.length()
                                + ';'
                                + geodes
                                + ';'
                                + bests.size()
                                + ";"
                                + asc(b)
                                + ";"
                                + Arrays.toString(b).replace(", ", ",").replace("[", "").replace("]", ""));
                    }
                }

            }

        } catch (IOException e) {
            throw new RuntimeException(e);
        }

    }

    private static boolean asc(int[] b) {
        int current = 0;
        for (int i : b) {
            if (i < current) {
                return false;
            }
            current = i;
        }
        return true;
    }

}
