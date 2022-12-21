package aoc2022.day19;

public record Blueprint(int id, int ore_ore, int ore_clay, int ore_obsidian, int clay_obsidian, int ore_geode, int obsidian_geode) {

    private static void requirePositive(int value, String name) {
        if (value < 1) {
            throw new IllegalArgumentException(name + " = " + value + ", expected >= 1");
        }
    }

    public Blueprint {
        requirePositive(id, "id");
        requirePositive(ore_ore, "ore_ore");
        requirePositive(ore_clay, "ore_clay");
        requirePositive(ore_obsidian, "ore_obsidian");
        requirePositive(clay_obsidian, "clay_obsidian");
        requirePositive(ore_geode, "ore_geode");
        requirePositive(obsidian_geode, "obsidian_geode");
    }

    public String toString() {
        return "Blueprint " +
                id +
                ":\n  Each ore robot costs " +
                ore_ore +
                "o re .\n  Each clay robot costs " +
                ore_clay +
                " ore .\n  Each obsidian robot costs " +
                ore_obsidian +
                " ore and " +
                clay_obsidian +
                " clay.\n  Each geode robot costs " +
                ore_geode +
                " ore and " +
                obsidian_geode +
                " obsidian.\n";
    }

    public int quality(int geodes) {
        if (geodes == -1) {
            return -1;
        }
        return id * geodes;
    }

    public boolean attemptSpend(int nextRobot, int[] resources) {

        if (nextRobot == 0) {
            if (resources[0] < ore_ore) {
                return false;
            }
            resources[0] -= ore_ore;
            return true;
        }

        if (nextRobot == 1) {
            if (resources[0] < ore_clay) {
                return false;
            }
            resources[0] -= ore_clay;
            return true;
        }

        if (nextRobot == 2) {
            if (resources[0] < ore_obsidian || resources[1] < clay_obsidian) {
                return false;
            }
            resources[0] -= ore_obsidian;
            resources[1] -= clay_obsidian;
            return true;
        }

        if (resources[0] < ore_geode || resources[2] < obsidian_geode) {
            return false;
        }
        resources[0] -= ore_geode;
        resources[2] -= obsidian_geode;
        return true;

    }

}
