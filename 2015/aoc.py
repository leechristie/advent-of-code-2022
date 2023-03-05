import string
from typing import Iterator, Iterable, Union
from dataclasses import dataclass
from abc import ABC, abstractmethod


def load_single_line(filename: str) -> str:
    with open(filename) as file:
        return next(file).strip()


def load_and_map_chars(filename: str, mapping_function=str):
    line = load_single_line(filename)
    rv = []
    for char in line:
        rv.append(mapping_function(char))
    return rv


def load_lines(filename: str) -> list[str]:
    rv = []
    with open(filename) as file:
        for line in file:
            rv.append(line.strip())
    return rv


def load_split_lines(filename: str, token: str, dtype=str) -> list[tuple]:
    return [tuple(map(dtype, line.split(token))) for line in load_lines(filename)]


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
