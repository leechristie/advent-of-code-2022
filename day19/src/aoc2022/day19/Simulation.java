package aoc2022.day19;

import java.util.Arrays;
import java.util.Objects;

public final class Simulation {

    public static final int FAIL = -1;

    private static final int ORE_ROBOT = 0;
    private static final int CLAY_ROBOT = 1;
    private static final int OBSIDIAN_ROBOT = 2;
    private static final int GEODDE_ROBOT = 3;

    private final int timeLimit;
    private final Blueprint blueprint;

    public Simulation(Blueprint blueprint, int timeLimit) {
        if (timeLimit < 1) {
            throw new IllegalArgumentException("id = " + timeLimit + ", expected >= 1");
        }
        this.timeLimit = timeLimit;
        Objects.requireNonNull(blueprint, "blueprint");
        this.blueprint = blueprint;
    }

    public int timeLimit() {
        return timeLimit;
    }

    public Blueprint blueprint() {
        return blueprint;
    }

    public int runVersion2(int[] plan) {

        long nano = System.nanoTime();

        // validate at least enough robots for 1st CLAY > 1st OBSIDIAN > 1st GEODE
        if (plan.length < 3) {
            return FAIL;
        }

        // validate final robot is OBSIDIAN
        if (plan[plan.length-1] != GEODDE_ROBOT) {
            return FAIL;
        }

        // validate sequence 1st CLAY > 1st OBSIDIAN > 1st GEODE
        boolean containsClayCollectingRobot = false;
        boolean containsObsidianCollectingRobot = false;
        for (int i = 0; i < plan.length; i++) {
            if (plan[i] == CLAY_ROBOT) {
                containsClayCollectingRobot = true;
            } else if (plan[i] == OBSIDIAN_ROBOT) {
                if (!containsClayCollectingRobot) {
                    return FAIL;
                }
                containsObsidianCollectingRobot = true;
            } else if (plan[i] == GEODDE_ROBOT) {
                if (!containsObsidianCollectingRobot) {
                    return FAIL;
                }
                break;
            }
        }

        // set up the state of the number of robots and resources
        int oreRobots = 1;
        int clayRobots = 0;
        int obsidianRobots = 0;
        int geodeRobots = 0;
        int ore = 0;
        int clay = 0;
        int obsidian = 0;
        int geodes = 0;

        // next robot in the queue
        int nextIndex = 0;
        int nextRobot = plan[0];

        // extract te costs to local variables
        final int oreCostForOreRobot = blueprint.ore_ore();
        final int oreCostForClayRobot = blueprint.ore_clay();
        final int oreCostForObsidianRobot = blueprint.ore_obsidian();
        final int clayCostForObsidianRobot = blueprint.clay_obsidian();
        final int oreCostForGeodeRobot = blueprint.ore_geode();
        final int obsidianCostForGeodeRobot = blueprint.obsidian_geode();

        int minute = 1;
        while (minute <= timeLimit) {

            //System.out.println("--------------------------------------------------------------------------------");
            //print("start of minute " + minute, ore, clay, obsidian, geodes);

            // spend resources to build a robot
            boolean spent;
            if (nextRobot == -1) {
                spent = false;
            } else if (nextRobot == ORE_ROBOT) {
                spent = ore >= oreCostForOreRobot;
                if (spent) {
                    ore -= oreCostForOreRobot;
                    //System.out.println("at start of minute " + minute + ", started building ore robot");
                    //System.out.println("spent " + oreCostForOreRobot + " ore");
                }
            } else if (nextRobot == CLAY_ROBOT) {
                spent = ore >= oreCostForClayRobot;
                if (spent) {
                    ore -= oreCostForClayRobot;
                    //System.out.println("at start of minute " + minute + ", started building clay robot");
                    //System.out.println("spent " + oreCostForClayRobot + " ore");
                }
            } else if (nextRobot == OBSIDIAN_ROBOT) {
                spent = clay >= clayCostForObsidianRobot && ore >= oreCostForObsidianRobot;
                if (spent) {
                    clay -= clayCostForObsidianRobot;
                    ore -= oreCostForObsidianRobot;
                    //System.out.println("at start of minute " + minute + ", started building obsidian robot");
                    //System.out.println("spent " + oreCostForObsidianRobot + " ore");
                    //System.out.println("spent " + clayCostForObsidianRobot + " clay");
                }
            } else {
                spent = obsidian >= obsidianCostForGeodeRobot && ore >= oreCostForGeodeRobot;
                if (spent) {
                    obsidian -= obsidianCostForGeodeRobot;
                    ore -= oreCostForGeodeRobot;
                    //System.out.println("at start of minute " + minute + ", started building geode robot");
                    //System.out.println("spent " + oreCostForGeodeRobot + " ore");
                    //System.out.println("spent " + obsidianCostForGeodeRobot + " obsidian");
                }
            }

            if (spent) {

                //System.out.println("spent = " + spent);

                // collect resources
                ore += oreRobots;
                clay += clayRobots;
                obsidian += obsidianRobots;
                geodes += geodeRobots;

                //print("during minute " + minute, oreRobots, clayRobots, obsidianRobots, geodeRobots, ore, clay, obsidian, geodes);

                // add the robot
                if (spent && minute == timeLimit) {
                    return FAIL;
                }
                //if (spent) {
                //    System.out.println("built robot at end of minute " + minute);
                //}
                if (nextRobot == ORE_ROBOT) {
                    oreRobots++;
                    //System.out.println("your new ore robot is ready !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                } else if (nextRobot == CLAY_ROBOT) {
                    clayRobots++;
                    ///System.out.println("your new clay robot is ready !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                } else if (nextRobot == OBSIDIAN_ROBOT) {
                    obsidianRobots++;
                    //System.out.println("your new obsidian robot is ready !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                } else {
                    geodeRobots++;
                    //System.out.println("your new geode robot is ready !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                }
                nextIndex++;
                nextRobot = nextIndex < plan.length ? plan[nextIndex] : -1;

                // advance the time by 1
                minute++;

            } else {

                //System.out.println("spent = " + spent);
                //if (nextRobot == -1) {
                //    System.out.println("no more robots to build");
                //} else {
                //    System.out.println("can't built " + name_of(nextRobot) + " yet at start of minute " + minute);
                //}

                int timeRequired;
                if (nextRobot == -1) {
                    int timeLeft = this.timeLimit - minute;
                    //System.out.println("there are " + timeLeft + "minutes with unacounted time");
                    return geodes + geodeRobots * (timeLeft + 1);
                } else if (nextRobot == ORE_ROBOT) {
                    timeRequired = (oreCostForOreRobot - ore) / oreRobots;
                    if ((oreCostForOreRobot - ore) % oreRobots != 0) {
                        timeRequired++;
                    }
                    //System.out.println("need to wait " + timeRequired + " to build ore robot");
                } else if (nextRobot == CLAY_ROBOT) {
                    timeRequired = (oreCostForClayRobot - ore) / oreRobots;
                    if ((oreCostForClayRobot - ore) % oreRobots != 0) {
                        timeRequired++;
                    }
                    //System.out.println("need to wait " + timeRequired + " to build clay robot");
                } else if (nextRobot == OBSIDIAN_ROBOT) {

                    timeRequired = (oreCostForObsidianRobot - ore) / oreRobots;
                    if ((oreCostForObsidianRobot - ore) % oreRobots != 0) {
                        timeRequired++;
                    }
                    if (ore >= oreCostForObsidianRobot) {
                        //System.out.println("ore was already satisfied");
                        timeRequired = 0;
                    }

                    int altTimeRequired = (clayCostForObsidianRobot - clay) / clayRobots;
                    if ((clayCostForObsidianRobot - clay) % clayRobots != 0) {
                        altTimeRequired++;
                    }
                    if (clay >= clayCostForObsidianRobot) {
                        //System.out.println("clay was already satisfied");
                        altTimeRequired = 0;
                    }
                    if (altTimeRequired > timeRequired) {
                        timeRequired = altTimeRequired;
                    }
                    //System.out.println("need to wait " + timeRequired + " to build obsidian robot");
                } else if (nextRobot == GEODDE_ROBOT) {
                    timeRequired = (oreCostForGeodeRobot - ore) / oreRobots;
                    if ((oreCostForGeodeRobot - ore) % oreRobots != 0) {
                        timeRequired++;
                    }
                    if (ore >= oreCostForGeodeRobot) {
                        timeRequired = 0;
                    }
                    int altTimeRequired = (obsidianCostForGeodeRobot - obsidian) / obsidianRobots;
                    if ((obsidianCostForGeodeRobot - obsidian) % obsidianRobots != 0) {
                        altTimeRequired++;
                    }
                    if (obsidian >= obsidianCostForGeodeRobot) {
                        altTimeRequired = 0;
                    }
                    if (altTimeRequired > timeRequired) {
                        timeRequired = altTimeRequired;
                    }
                    //System.out.println("need to wait " + timeRequired + " to build geode robot");
                } else {
                    throw new AssertionError("nextRobot = " + nextRobot);
                }

                if (timeRequired < 1) {
                    throw new AssertionError("timeRequired = " + timeRequired);
                }

                // collect resources
                ore += oreRobots * timeRequired;
                clay += clayRobots * timeRequired;
                obsidian += obsidianRobots * timeRequired;
                geodes += geodeRobots * timeRequired;
                minute += timeRequired;
                //System.out.println("advancing clock by " + timeRequired + " from " + (minute - timeRequired) + " to minute " + minute);

                if (minute >= timeLimit) {
                    //System.out.println("jumped over end time, can't build robot " + name_of(nextRobot));
                    return FAIL;
                }

            }

        }

        //System.out.println("ended loop normally");
        return geodes;

    }

    private String name_of(int nextRobot) {
        if (nextRobot == 0) {
            return "ore";
        }
        if (nextRobot == 1) {
            return "clay";
        }
        if (nextRobot == 2) {
            return "obsidian";
        }
        if (nextRobot == 3) {
            return "geode";
        }
        return "?????";
    }

//
//    private void print(String str, int oreRobots, int clayRobots, int obsidianRobots, int geodeRobots, int ore, int clay, int obsidian, int geodes) {
//        System.out.println(str + " : ");
//        if (oreRobots > 0) {
//            System.out.println("    " + oreRobots + " ore-collecting robot collects " + oreRobots + " ore; you now have " + ore + " ore.");
//        }
//        if (clayRobots > 0) {
//            System.out.println("    " + clayRobots + " clay-collecting robot collects " + clayRobots + " clay; you now have " + clay + " clay.");
//        }
//        if (obsidianRobots > 0) {
//            System.out.println("    " + oreRobots + " obsidian-collecting robot collects " + obsidianRobots + " obsidian; you now have " + obsidian + " obsidian.");
//        }
//        if (geodeRobots > 0) {
//            System.out.println("    " + oreRobots + " geodes-collecting robot collects " + geodeRobots + " geodes; you now have " + geodes + " geodes.");
//        }
//    }

//    private void print(String str, int ore, int clay, int obsidian, int geodes) {
//        System.out.println(str + " : ");
//        if (ore == 0 && clay == 0 && obsidian == 0 && geodes == 0) {
//            System.out.println("    you so far have nothing.");
//        }
//        if (ore > 0) {
//            System.out.println("    you so far have " + ore + " ore.");
//        }
//        if (clay > 0) {
//            System.out.println("    you so far have " + clay + " clay.");
//        }
//        if (obsidian > 0) {
//            System.out.println("    you so far have " + obsidian + " obsidian.");
//        }
//        if (geodes > 0) {
//            System.out.println("    you so far have " + geodes + " geodes.");
//        }
//    }

    public int runVersion1(int[] plan) {

        // validate at least enough robots for 1st CLAY > 1st OBSIDIAN > 1st GEODE
        if (plan.length < 3) {
            return FAIL;
        }

        // validate final robot is OBSIDIAN
        if (plan[plan.length-1] != GEODDE_ROBOT) {
            return FAIL;
        }

        // validate sequence 1st CLAY > 1st OBSIDIAN > 1st GEODE
        boolean containsClayCollectingRobot = false;
        boolean containsObsidianCollectingRobot = false;
        for (int i = 0; i < plan.length; i++) {
            if (plan[i] == CLAY_ROBOT) {
                containsClayCollectingRobot = true;
            } else if (plan[i] == OBSIDIAN_ROBOT) {
                if (!containsClayCollectingRobot) {
                    return FAIL;
                }
                containsObsidianCollectingRobot = true;
            } else if (plan[i] == GEODDE_ROBOT) {
                if (!containsObsidianCollectingRobot) {
                    return FAIL;
                }
                break;
            }
        }

        // set up the state of the number of robots and resources
        int oreRobots = 1;
        int clayRobots = 0;
        int obsidianRobots = 0;
        int geodeRobots = 0;
        int ore = 0;
        int clay = 0;
        int obsidian = 0;
        int geodes = 0;

        // next robot in the queue
        int nextIndex = 0;
        int nextRobot = plan[0];

        // extract te costs to local variables
        final int oreCostForOreRobot = blueprint.ore_ore();
        final int oreCostForClayRobot = blueprint.ore_clay();
        final int oreCostForObsidianRobot = blueprint.ore_obsidian();
        final int clayCostForObsidianRobot = blueprint.clay_obsidian();
        final int oreCostForGeodeRobot = blueprint.ore_geode();
        final int obsidianCostForGeodeRobot = blueprint.obsidian_geode();

        // simulate minutes
        for (int minute = 1; minute <= timeLimit; minute++) {

            if (minute == timeLimit && nextRobot != -1) {
                //System.out.println("at last minute " + minute + " == " + timeLimit + " and nextRobot = " + nextRobot);
                return FAIL;
            }

            // spend resources to build a robot
            boolean spent = true;
            if (nextRobot == -1) {
                spent = false;
            } else if (nextRobot == ORE_ROBOT) {
                spent = ore >= oreCostForOreRobot;
                if (spent) {
                    ore -= oreCostForOreRobot;
                }
            } else if (nextRobot == CLAY_ROBOT) {
                spent = ore >= oreCostForClayRobot;
                if (spent) {
                    ore -= oreCostForClayRobot;
                }
            } else if (nextRobot == OBSIDIAN_ROBOT) {
                spent = clay >= clayCostForObsidianRobot && ore >= oreCostForObsidianRobot;
                if (spent) {
                    clay -= clayCostForObsidianRobot;
                    ore -= oreCostForObsidianRobot;
                }
            } else {
                spent = obsidian >= obsidianCostForGeodeRobot && ore >= oreCostForGeodeRobot;
                if (spent) {
                    obsidian -= obsidianCostForGeodeRobot;
                    ore -= oreCostForGeodeRobot;
                }
            }

            // collect resources
            ore += oreRobots;
            clay += clayRobots;
            obsidian += obsidianRobots;
            geodes += geodeRobots;

            // add new robot
            if (spent) {
                if (nextRobot == ORE_ROBOT) {
                    oreRobots++;
                } else if (nextRobot == CLAY_ROBOT) {
                    clayRobots++;
                } else if (nextRobot == OBSIDIAN_ROBOT) {
                    obsidianRobots++;
                } else {
                    geodeRobots++;
                }
                nextIndex++;
                nextRobot = nextIndex < plan.length ? plan[nextIndex] : -1;
            }

            ///if (spent) {
            //    System.out.println("built robot at end of minute " + minute);
            //}

        }

        // not allowed to end with a robot on the queue
        if (nextRobot != -1) {
            return FAIL;
        }

        // return number of geode
        return geodes;

    }

    public int runAllVersion1(int length) {
        if (length < 3) {
            return FAIL;
        }
        if (length < 0 || length >= timeLimit) {
            throw new IllegalArgumentException("length = " + length + ", expected [0, " + timeLimit + ")");
        }
        int[] plan = new int[length];
        Arrays.fill(plan, 3);
        plan[0] = 1;
        plan[1] = 2;
        plan[plan.length-1] = 3;
        int bestGeodes = FAIL;
        boolean hasNext;
        do {

            // run the plan
            int geodes1 = runVersion1(plan);
            if (geodes1 > bestGeodes) {
                bestGeodes = geodes1;
            }

            // base 4 counter [1, 2, 3, 3, ..., 3] to [0, 0, 0, 0, ..., 0] then exits do-while by not setting hasNext
            hasNext = false;
            for (int i = plan.length - 2; i >= 0; i--) {
                if (plan[i] > 0) {
                    plan[i]--;
                    hasNext = true;
                    break;
                }
                plan[i] = 3;
            }

        } while (hasNext);

        return bestGeodes;

    }


    public static void main(String[] args) {
        Simulation s = new Simulation(new Blueprint(1, 4, 2, 3, 14, 2, 7), 32);
        System.out.println(s.runAllVersion1(4));
    }

}
