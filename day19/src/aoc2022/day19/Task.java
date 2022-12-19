package aoc2022.day19;

import java.util.Objects;

public record Task(Simulation simulation, int length) {
    public Task {
        Objects.requireNonNull(simulation, "simulation");
        if (length < 0 || length >= simulation.timeLimit()) {
            throw new IllegalArgumentException(
                    "length = " + length + ", expected: [0, " + simulation.timeLimit() + ")");
        }
    }
}
