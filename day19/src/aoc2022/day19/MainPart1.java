package aoc2022.day19;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.*;

public class MainPart1 {

    public static void main(String[] args) {

        long totalStart = System.nanoTime();

        // set up the blueprints
        List<Blueprint> blueprints = new ArrayList<>();

        final boolean USING_EXAMPLE = false;
        // example
        if (USING_EXAMPLE) {
            blueprints.add(new Blueprint(1, 4, 2, 3, 14, 2, 7));
            blueprints.add(new Blueprint(2, 2, 3, 3, 8, 3, 12));
        } else {
            blueprints.add(new Blueprint(1, 4, 4, 4, 14, 3, 16));
            blueprints.add(new Blueprint(2, 4, 3, 3, 11, 4, 7));
            blueprints.add(new Blueprint(3, 4, 4, 3, 14, 3, 8));
            blueprints.add(new Blueprint(4, 2, 3, 2, 14, 3, 8));
            blueprints.add(new Blueprint(5, 2, 4, 3, 19, 4, 8));
            blueprints.add(new Blueprint(6, 2, 4, 3, 14, 4, 9));
            blueprints.add(new Blueprint(7, 3, 3, 2, 20, 3, 18));
            blueprints.add(new Blueprint(8, 4, 4, 2, 14, 3, 17));
            blueprints.add(new Blueprint(9, 2, 4, 4, 15, 2, 20));
            blueprints.add(new Blueprint(10, 4, 4, 2, 7, 4, 13));
            blueprints.add(new Blueprint(11, 2, 4, 4, 17, 3, 11));
            blueprints.add(new Blueprint(12, 4, 3, 3, 18, 4, 8));
            blueprints.add(new Blueprint(13, 4, 4, 2, 11, 4, 8));
            blueprints.add(new Blueprint(14, 3, 4, 4, 6, 3, 16));
            blueprints.add(new Blueprint(15, 3, 3, 3, 20, 2, 12));
            blueprints.add(new Blueprint(16, 4, 2, 2, 16, 2, 8));
            blueprints.add(new Blueprint(17, 4, 3, 4, 11, 3, 15));
            blueprints.add(new Blueprint(18, 3, 4, 4, 5, 3, 12));
            blueprints.add(new Blueprint(19, 4, 3, 3, 10, 2, 10));
            blueprints.add(new Blueprint(20, 4, 3, 4, 15, 3, 12));
            blueprints.add(new Blueprint(21, 3, 4, 3, 10, 2, 7));
            blueprints.add(new Blueprint(22, 4, 4, 4, 12, 4, 19));
            blueprints.add(new Blueprint(23, 4, 3, 4, 16, 2, 15));
            blueprints.add(new Blueprint(24, 3, 4, 4, 18, 3, 13));
            blueprints.add(new Blueprint(25, 3, 3, 2, 16, 3, 14));
            blueprints.add(new Blueprint(26, 3, 3, 2, 15, 3, 9));
            blueprints.add(new Blueprint(27, 4, 4, 4, 10, 2, 7));
            blueprints.add(new Blueprint(28, 4, 4, 4, 5, 3, 15));
            blueprints.add(new Blueprint(29, 3, 4, 2, 15, 2, 13));
            blueprints.add(new Blueprint(30, 4, 4, 4, 12, 3, 8));
        }

        // set the time limit and max plan length
        final int TIME_LIMIT = 24;
        final int MAX_PLAN_LENGTH = 23;
        assert MAX_PLAN_LENGTH < TIME_LIMIT;

        System.out.println("Testing function");
        Simulation test = new Simulation(blueprints.get(0), 24);
        test.runVersion1(new int[] {});
        System.out.println("Done testing");

        // create the tasks
        int numTasks = (MAX_PLAN_LENGTH + 1) * blueprints.size();
        Queue<Task> queue = new ArrayBlockingQueue<>(numTasks);
        for (int length = 0; length <= MAX_PLAN_LENGTH; length++) {
            for (Blueprint blueprint: blueprints) {
                Simulation simulation = new Simulation(blueprint, 24);
                queue.offer(new Task(simulation, length));
            }
        }
        assert queue.size() == numTasks;

        // result tracker
        final int[] best = new int[blueprints.size()];
        Arrays.fill(best, Simulation.FAIL);

        Task polled;
        while ((polled = queue.poll()) != null) {
            final Task current = polled;
            CompletableFuture.supplyAsync(() -> {
                long start = System.nanoTime();
                Simulation simulation = current.simulation();
                Blueprint blueprint = simulation.blueprint();
                int id = blueprint.id();
                int length = current.length();
                int geodes = simulation.runAllVersion1(length);
                int quality = blueprint.quality(geodes);
                Duration time = Duration.ofNanos(System.nanoTime() - start);
                String threadName = Thread.currentThread().getName();
                if (!threadName.equals("main")) {
                    String[] tokens = threadName.split("-");
                    threadName = "worker" + tokens[tokens.length-1];
                }
                synchronized (System.out) {
                    if (quality > best[id-1]) {
                        best[id-1] = quality;
                    }
                    int total = 0;
                    for (int q: best) {
                        if (q != Simulation.FAIL) {
                            total += q;
                        }
                    }
                    System.out.println("Blueprint: " + id
                            + "\t\tLength: " + length
                            + "\t\tGeodes: " + geodes
                            + "\t\tQuality: " + quality
                            + "\t\tBest#" + id + ": " + best[id-1]
                            + "\t\tTotal: " + total
                            + "\t\tRuntime: " + time
                            + "\t\tOn thread: " + threadName
                            + "\t\tTotal Runtime: " + Duration.ofNanos(System.nanoTime() - totalStart));
                }
                return null;
            });
        }

        while (!ForkJoinPool.commonPool().awaitQuiescence(Long.MAX_VALUE, TimeUnit.NANOSECONDS));

        System.out.println("done.");
        int total = 0;
        for (int q: best) {
            total += q;
        }
        System.out.println("final total = " + total);
        System.out.println("total runtime = " + Duration.ofNanos(System.nanoTime() - totalStart));

    }

}
