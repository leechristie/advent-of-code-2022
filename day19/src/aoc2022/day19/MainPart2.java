package aoc2022.day19;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.TimeUnit;

public class MainPart2 {

    public static void main(String[] args) {

        // Length 21 result

        // Blueprint: 1		Length: 21		Geodes: 11		Best#1: 11		Total: 12650		Runtime: PT4H16M56.099322375S		On thread: worker1		Total Runtime: PT4H17M58.856849959S
        // Blueprint: 2		Length: 21		Geodes: 47		Best#2: 47		Total: 12925		Runtime: PT4H18M7.150288583S		On thread: worker6		Total Runtime: PT4H22M10.09198375S
        // Blueprint: 3		Length: 21		Geodes: 25		Best#3: 25		Total: 12925		Runtime: PT4H18M47.223781125S		On thread: worker4		Total Runtime: PT4H22M55.314104959S

        long totalStart = System.nanoTime();

        //for (int fixedLength = 4; fixedLength <= 7; fixedLength++) {
        for (int fixedLength = 22; fixedLength <= 31; fixedLength++) {

            // set up the blueprints
            List<Blueprint> blueprints = new ArrayList<>();

//            final boolean USING_EXAMPLE = false;
//            // example
//            if (USING_EXAMPLE) {
//                blueprints.add(new Blueprint(1, 4, 2, 3, 14, 2, 7));
//                blueprints.add(new Blueprint(2, 2, 3, 3, 8, 3, 12));
//            } else {
                blueprints.add(new Blueprint(1, 4, 4, 4, 14, 3, 16));
                blueprints.add(new Blueprint(2, 4, 3, 3, 11, 4, 7));
                blueprints.add(new Blueprint(3, 4, 4, 3, 14, 3, 8));
//            }

            // set the time limit and max plan length
            final int TIME_LIMIT = 32;

//            System.out.println("Testing function");
//            Simulation test = new Simulation(blueprints.get(0), TIME_LIMIT);
//            test.runVersion1(new int[]{});
//            System.out.println("Done testing");

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

            Task polled;
            while ((polled = queue.poll()) != null) {
                final Task current = polled;
                CompletableFuture.supplyAsync(() -> {
                    long start = System.nanoTime();
                    Simulation simulation = current.simulation();
                    Blueprint blueprint = simulation.blueprint();
                    int id = blueprint.id();
                    int length = current.length();
                    LocalDateTime now = LocalDateTime.now();
                    String threadName = Thread.currentThread().getName();
                    if (!threadName.equals("main")) {
                        String[] tokens = threadName.split("-");
                        threadName = "worker" + tokens[tokens.length - 1];
                    }
                    synchronized (System.out) {
                        System.out.println("beginning work on length " + length + " for blueprint " + id + " on thread " + threadName + " at " + now);
                    }
                    int geodes = simulation.runAllVersion1(length);
                    Duration time = Duration.ofNanos(System.nanoTime() - start);
                    synchronized (System.out) {
                        if (geodes > best[id - 1]) {
                            best[id - 1] = geodes;
                        }
                        int total = 1;
                        for (int q : best) {
                            if (q != Simulation.FAIL) {
                                total *= q;
                            } else {
                                total = 0;
                            }
                        }
                        System.out.println("Blueprint: " + id
                                + "\t\tLength: " + length
                                + "\t\tGeodes: " + geodes
                                + "\t\tBest#" + id + ": " + best[id - 1]
                                + "\t\tTotal: " + "(MANUAL)"
                                + "\t\tRuntime: " + time
                                + "\t\tOn thread: " + threadName
                                + "\t\tTotal Runtime: " + Duration.ofNanos(System.nanoTime() - totalStart));
                    }
                    return null;
                });
            }

            while (!ForkJoinPool.commonPool().awaitQuiescence(Long.MAX_VALUE, TimeUnit.NANOSECONDS)) ;

        }

        System.out.println("done.");
        System.out.println("final total = " + "MANUAL");
        System.out.println("total runtime = " + Duration.ofNanos(System.nanoTime() - totalStart));

    }

}
