class Solver:

    __slots__ = ['encoding', 'decoding', 'moves']

    def __init__(self, encoding):
        self.encoding = {}
        self.decoding = {}
        for i, e in enumerate(encoding):
            self.encoding[e] = i
            self.decoding[i] = e
        self.moves = {}

    def encode(self, unencoded):
        rv = []
        for e in unencoded:
            rv.append(self.encoding[e])
        return tuple(rv)

    def decode(self, encoded):
        rv = []
        for e in encoded:
            rv.append(self.decoding[e])
        return tuple(rv)

    def addEncoded(self, from_index, to_indices):
        if from_index not in self.moves:
            self.moves[from_index] = []
        self.moves[from_index].append(to_indices)

    def replace_at(self, current, index, replacement):
        return current[:index] + replacement + current[index+1:]

    def next_steps(self, current):
        for index in range(len(current)):
            element = current[index]
            if element in self.moves:
                for replacement in self.moves[element]:
                    yield self.replace_at(current, index, replacement)

    def advance(self, distance: int, seen: set[tuple], current: set[tuple]):
        new = set()
        for c in current:
            for step in self.next_steps(c):
                if step not in seen:
                    new.add(step)
                    seen.add(step)
        return distance + 1, seen, new


solver = Solver(('e', 'H', 'O'))

solver.addEncoded(0, (1, ))  # e => H
solver.addEncoded(0, (2, ))  # e => O
solver.addEncoded(1, (1, 2))  # H => HO
solver.addEncoded(1, (2, 1))  # H => OH
solver.addEncoded(2, (1, 1))  # O => HH


START = solver.encode('e')
GOAL = solver.encode('HOHOHO')

distance = 0
seen = {START}
current = {START}
snaps = {}

print('distance', 'seen', 'current', sep='\t')
print(distance, len(seen), len(current), sep='\t')
snaps[distance] = list(current)
while GOAL not in current:
    distance, seen, current = solver.advance(distance, seen, current)
    print(distance, len(seen), len(current), sep='\t')
    snaps[distance] = list(current)

