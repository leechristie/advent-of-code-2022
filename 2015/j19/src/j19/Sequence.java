package j19;

import java.util.Arrays;

public final class Sequence {

    private final int[] encoding;
    private final int hashCode;

    public Sequence(int[] encoding) {
        this.encoding = encoding;
        this.hashCode = Arrays.hashCode(encoding);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Sequence sequence = (Sequence) o;
        return Arrays.equals(encoding, sequence.encoding);
    }

    @Override
    public int hashCode() {
        return hashCode;
    }

    @Override
    public String toString() {
        return "Substring{" + Arrays.toString(encoding) + '}';
    }

}