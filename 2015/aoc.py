from typing import Iterator


def load_single_line(filename: str) -> str:
    with open(filename) as file:
        return next(file).strip()


def load_lines(filename: str) -> Iterator[str]:
    with open(filename) as file:
        for line in file:
            yield line.strip()
