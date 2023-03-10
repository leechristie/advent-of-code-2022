import string
from typing import Iterator, Iterable, Union, Callable
from dataclasses import dataclass
from itertools import permutations

import numpy as np


def load_single_line(filename: str) -> str:
    with open(filename) as file:
        return next(file).strip()


def load_and_map_chars(filename: str, mapping_function=str):
    line = load_single_line(filename)
    rv = []
    for char in line:
        rv.append(mapping_function(char))
    return rv


def load_lines(filename: str, dtype=str) -> list[str]:
    rv = []
    with open(filename) as file:
        for line in file:
            rv.append(dtype(line.strip()))
    return rv


def load_split_lines(filename: str, sep: str, dtype=str) -> list[tuple]:
    return [tuple(map(dtype, line.split(sep))) for line in load_lines(filename)]


def load_split_lines_at_indices(filename: str, sep: str, indices: list[int], dtypes=(str, ), ignore: str='') -> list[tuple]:
    rv = []
    for line in load_lines(filename):
        for c in ignore:
            line = line.replace(c, '')
        current = []
        tokens = line.split(sep)
        output_index = 0
        for i, t in enumerate(tokens):
            if i in indices:
                current.append(dtypes[output_index % len(dtypes)](t))
                output_index += 1
        rv.append(tuple(current))
    return rv


def load_int_matrix(filename: str, mapping_function: Callable[[str], int]):
    lines = []
    for line in load_lines(filename):
        current = []
        for char in line:
            current.append(mapping_function(char))
        lines.append(current)
    return np.array(lines, dtype=int)


class DefaultMatrix:

    __slots__ = ['matrix', 'default', 'height', 'width', 'shape']

    def __init__(self, matrix, default=0):
        self.matrix = matrix
        self.default = default
        self.height, self.width = self.shape = matrix.shape

    def copy(self):
        return DefaultMatrix(np.copy(self.matrix), self.default)

    def __setitem__(self, key, value):
        y, x = key
        if 0 <= x < self.width and 0 <= y < self.height:
            self.matrix[key] = value

    def __getitem__(self, item: tuple[int, int]) -> int:
        y, x = item
        if 0 <= x < self.width and 0 <= y < self.height:
            return self.matrix[item]
        return self.default

    def __str__(self):
        return str(self.matrix)

    def __repr__(self):
        return repr(self.matrix)

    def neighbours(self, item: tuple[int, int]) -> Iterator[tuple[int, int]]:

        y, x = item

        yield y-1, x-1
        yield y-1, x
        yield y-1, x+1

        yield y, x-1
        yield y, x+1

        yield y+1, x-1
        yield y+1, x
        yield y+1, x+1

    def print_mapped(self, mapping_function):
        for y in range(self.height):
            line = ''
            for x in range(self.width):
                line += mapping_function(self[(y, x)])
            print(line)


def split_prefix(line: str, valid_prefixes: Iterable[str]) -> tuple[str, str]:
    for prefix in valid_prefixes:
        if line.startswith(prefix):
            return prefix, line[len(prefix):]
    raise ValueError(f'unknown prefix for string: {line}')


def parse_int_or_str(value: str) -> Union[str, int]:
    try:
        return int(value)
    except ValueError:
        return value


def is_non_empty_lowercase_alphabetic_only(value: str) -> bool:
    if not value:
        return False
    for v in value:
        if v not in string.ascii_lowercase:
            return False
    return True


def is_non_empty_uppercase_alphabetic_only(value: str) -> bool:
    if not value:
        return False
    for v in value:
        if v not in string.ascii_uppercase:
            return False
    return True


@dataclass
class Position:

    x: int
    y: int

    def __init__(self, x: int = 0, y: int = 0):
        self.x = x
        self.y = y

    def __hash__(self):
        return hash((self.x, self.y))

    @staticmethod
    def parse(s: str) -> 'Position':
        x, y = s.split(',')
        x = int(x)
        y = int(y)
        return Position(x, y)

    def np(self):
        assert self.x >= 0 and self.y >= 0
        return self.y, self.x

    @staticmethod
    def closed_rectangle(start: 'Position', end: 'Position') -> Iterator['Position']:
        start_y = min(start.y, end.y)
        end_y = max(start.y, end.y)
        start_x = min(start.x, end.x)
        end_x = max(start.x, end.x)
        for y in range(start_y, end_y+1):
            for x in range(start_x, end_x+1):
                yield Position(x, y)


@dataclass
class Velocity:

    dx: int
    dy: int

    def __init__(self, dx: int = 0, dy: int = 0):
        self.dx = dx
        self.dy = dy

    def __hash__(self):
        return hash((self.dx, self.dy))

    @staticmethod
    def from_arrow(arrow: str) -> 'Velocity':
        if arrow == '^':
            return Velocity(0, 1)
        if arrow == '>':
            return Velocity(1, 0)
        if arrow == 'v':
            return Velocity(0, -1)
        if arrow == '<':
            return Velocity(-1, 0)

    def __add__(self, other):
        if type(other) == Position:
            return Position(other.x + self.dx, other.y + self.dy)
        if type(other) == Velocity:
            return Velocity(other.dx + self.dx, other.dy + self.dy)
        else:
            raise TypeError()

    def __radd__(self, other):
        if type(other) == Position:
            return Position(other.x + self.dx, other.y + self.dy)
        if type(other) == Velocity:
            return Velocity(other.dx + self.dx, other.dy + self.dy)
        else:
            raise TypeError()


def all_unique_symmetric_tsp_permutations(n, return_home=True):
    if return_home:
        for p in permutations(range(1, n)):
            if p[0] < p[-1]:
                yield (0, ) + p
    else:
        for p in permutations(range(0, n)):
            yield p


def evaluate_symmetric_tsp_from_dense_matrix(matrix, permutation, return_home=True):
    total = 0
    n = len(permutation)
    for i in range(n):
        from_city = permutation[i]
        to_city = permutation[(i + 1) % n]
        if return_home or i < n-1:
            total += matrix[(from_city, to_city)]
    return total


def exhaustively_evaluate_symmetric_tsp_from_dense_matrix(matrix, return_home=True):
    n = len(matrix)
    best_value = None
    best_permutation = None
    for permutation in all_unique_symmetric_tsp_permutations(n, return_home=return_home):
        value = evaluate_symmetric_tsp_from_dense_matrix(matrix, permutation, return_home=return_home)
        if best_value is None or best_value < value:
            best_value = value
            best_permutation = permutation
    return best_value, best_permutation


def optimize(candidates, evaluation, minimize=False):
    best = None
    best_candidate = None
    for candidate in candidates:
        current = evaluation(candidate)
        if minimize:
            if best is None or best > current:
                best, best_candidate = current, candidate
        else:
            if best is None or best < current:
                best, best_candidate = current, candidate
    return best, candidate


def product(numbers: Union[float, int]) -> Union[float, int]:
    rv = 1
    for number in numbers:
        rv *= number
    return rv
