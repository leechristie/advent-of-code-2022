from typing import Iterator
from dataclasses import dataclass


def load_single_line(filename: str) -> str:
    with open(filename) as file:
        return next(file).strip()


def load_and_map_chars(filename: str, mapping_function=str):
    line = load_single_line(filename)
    rv = []
    for char in line:
        rv.append(mapping_function(char))
    return rv


def load_lines(filename: str) -> Iterator[str]:
    with open(filename) as file:
        for line in file:
            yield line.strip()


def load_split_lines(filename: str, token: str, dtype=str) -> list[tuple]:
    return [tuple(map(dtype, line.split(token))) for line in load_lines(filename)]


@dataclass
class Position:

    x: int
    y: int

    def __init__(self, x: int = 0, y: int = 0):
        self.x = x
        self.y = y

    def __hash__(self):
        return hash((self.x, self.y))


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
