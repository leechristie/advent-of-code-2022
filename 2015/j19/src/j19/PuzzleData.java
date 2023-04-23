package j19;

import java.util.*;

public final class PuzzleData {

    private final Sequence end;
    private final Map<Integer, Set<Sequence>> forward = new HashMap<>();
    private final Map<Sequence, Set<Integer>> backward = new HashMap<>();

    private void add(int from, int[] toArr) {
        Sequence to = new Sequence(toArr);
        forward.putIfAbsent(from, new HashSet<>());
        forward.get(from).add(to);
        backward.putIfAbsent(to, new HashSet<>());
        backward.get(to).add(from);
    }

    public static void main(String[] args) {
        PuzzleData data = new PuzzleData();
        
    }

    public PuzzleData() {
        this.end = new Sequence(new int[] {13, 10, 14, 3, 9, 12, 6, 16, 3, 9, 12, 14, 4, 15, 10, 11, 4, 15, 3, 10, 11, 10, 11, 9, 2, 3, 3, 10, 14, 10, 14, 12, 12, 6, 15, 9, 2, 3, 9, 6, 16, 9, 12, 14, 4, 15, 4, 15, 3, 10, 14, 2, 9, 6, 15, 9, 14, 3, 9, 12, 14, 4, 15, 3, 10, 11, 3, 3, 4, 15, 9, 2, 3, 3, 9, 12, 12, 14, 4, 15, 3, 10, 14, 10, 1, 16, 10, 11, 14, 4, 15, 15, 3, 10, 14, 2, 4, 15, 3, 3, 10, 14, 10, 11, 3, 3, 3, 4, 16, 3, 9, 12, 2, 3, 10, 11, 3, 10, 11, 9, 6, 15, 10, 14, 3, 9, 2, 4, 16, 3, 3, 4, 15, 3, 3, 3, 3, 10, 11, 3, 10, 14, 9, 14, 4, 15, 9, 2, 10, 11, 9, 14, 4, 15, 10, 14, 6, 15, 3, 4, 16, 4, 15, 3, 10, 14, 10, 1, 15, 12, 12, 12, 12, 12, 12, 12, 14, 9, 6, 15, 9, 12, 12, 12, 2, 10, 14, 10, 1, 15, 12, 12, 14, 9, 6, 15, 3, 4, 16, 2, 9, 2, 9, 12, 14, 10, 14, 6, 15, 10, 11, 3, 4, 15, 3, 10, 11, 4, 15, 9, 14, 4, 15, 3, 10, 14, 12, 2, 10, 11, 10, 14, 10, 1, 16, 3, 4, 15, 9, 14, 4, 15, 10, 11, 3, 4, 15, 3, 3, 10, 11, 3, 3, 3, 10, 14, 9, 14, 3, 4, 15, 4, 16, 9, 6, 15, 3, 9, 2, 3, 9, 2, 10, 14, 4, 16, 9, 2, 3, 4, 15, 3, 10, 1});
        add(1, new int[] {11, 14, 4, 15});
        add(1, new int[] {11, 4});
        add(2, new int[] {2, 3});
        add(2, new int[] {12, 14, 4, 15});
        add(2, new int[] {12, 2});
        add(3, new int[] {10, 11});
        add(3, new int[] {10, 14, 4, 16, 4, 15});
        add(3, new int[] {9, 2});
        add(3, new int[] {3, 3});
        add(3, new int[] {10, 14, 6, 15});
        add(3, new int[] {9, 14, 4, 15});
        add(4, new int[] {9, 6});
        add(4, new int[] {10, 1});
        add(4, new int[] {3, 4});
        add(5, new int[] {8, 14, 4, 15});
        add(5, new int[] {13, 4, 16, 6, 15});
        add(5, new int[] {7, 14, 4, 16, 4, 15});
        add(5, new int[] {7, 14, 6, 15});
        add(5, new int[] {13, 6, 16, 4, 15});
        add(5, new int[] {5, 3});
        add(5, new int[] {8, 2});
        add(5, new int[] {7, 11});
        add(5, new int[] {13, 4, 16, 4, 16, 4, 15});
        add(5, new int[] {13, 1, 15});
        add(6, new int[] {12, 6});
        add(6, new int[] {2, 4});
        add(7, new int[] {5, 10});
        add(7, new int[] {13, 4, 15});
        add(8, new int[] {13, 4, 16, 4, 15});
        add(8, new int[] {7, 14, 4, 15});
        add(8, new int[] {8, 12});
        add(8, new int[] {5, 9});
        add(8, new int[] {13, 6, 15});
        add(9, new int[] {9, 12});
        add(9, new int[] {3, 9});
        add(9, new int[] {10, 14, 4, 15});
        add(10, new int[] {3, 10});
        add(11, new int[] {11, 3});
        add(12, new int[] {2, 9});
        add(12, new int[] {12, 12});
        add(0, new int[] {5, 4});
        add(0, new int[] {7, 1});
        add(0, new int[] {8, 6});
    }

}