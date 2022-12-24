from typing import Any, Callable
from abc import ABC, abstractmethod
from functools import partial
from tqdm.notebook import tqdm


class AbstractHeap(ABC):

    @abstractmethod
    def add(self, element: Any, key: int) -> None:
        pass

    @abstractmethod
    def decrease_key(self, element: Any, new_key: int) -> None:
        pass

    @abstractmethod
    def delete_minimum(self) -> Any:
        pass

    @abstractmethod
    def __bool__(self) -> bool:
        pass


class ArrayHeap(AbstractHeap):

    __slots__ = ['data']

    def __init__(self):
        self.data = []

    def add(self, element: Any, key: int):
        for k, e in self.data:
            if e == element:
                raise ValueError(f'duplicate element: {element}')
        self.data.append((key, element))
        self.data.sort()

    def decrease_key(self, element: Any, new_key: int):
        index = None
        for i, e in enumerate(self.data):
            if e[1] == element:
                index = i
        if index is None:
            raise ValueError(f'no such element: {element}')
        old_key, _ = self.data[index]
        if old_key < new_key:
            raise ValueError(f'cannot increase key for {element} from {old_key} to {new_key}')
        del self.data[index]
        self.add(element, new_key)

    def delete_minimum(self):
        if not self:
            raise ValueError(f'no such element')
        _, rv = self.data[0]
        del self.data[0]
        return rv

    def __bool__(self):
        return bool(self.data)

    def __str__(self):
        return 'Heap{' + ', '.join([f'{key}: {element}' for key, element in self.data]) + '}'

    def __repr__(self):
        return str(self)


def dijkstra(heap_factory: Callable[[], AbstractHeap],
             source_vertex: Any,
             neighbourhood_function: Callable[[Any], list[tuple[Any, int]]],
             is_target: Callable[[Any], bool],
             pbar: Callable[[Any], None] = None) -> tuple[list[Any], list[Any]]:
    return a_star(heap_factory, source_vertex, neighbourhood_function, is_target, heuristic=lambda _: 0, pbar=pbar)


def a_star(heap_factory: Callable[[], AbstractHeap],
           source_vertex: Any,
           neighbourhood_function: Callable[[Any], list[tuple[Any, int]]],
           is_target: Callable[[Any], bool],
           heuristic: Callable[[Any], int],
           pbar: Callable[[Any], None] = None) -> tuple[list[Any], list[Any]]:

    if pbar is None:
        pbar = lambda x: None

    previous_vertices = {}  # to reconstruct the path

    g_scores = {source_vertex: 0}
    f_scores = {source_vertex: heuristic(source_vertex)}

    frontier = heap_factory()
    frontier.add(source_vertex, heuristic(source_vertex))

    visited = []

    while frontier:

        current = frontier.delete_minimum()
        visited.append(current)
        pbar(1)
        current_g_score = g_scores[current]

        # if done, path from source to target
        if is_target(current):

            rv = [current]
            while rv[0] != source_vertex:
                p = previous_vertices[rv[0]]
                rv = [p] + rv
            return rv, visited

        for neighbour, cost in neighbourhood_function(current):

            new_g_score = current_g_score + cost

            known_g_score = None
            if neighbour in g_scores:
                known_g_score = g_scores[neighbour]

            # newly discovered node
            if known_g_score is None:

                g_scores[neighbour] = new_g_score
                neighbour_f_score = new_g_score + heuristic(neighbour)
                f_scores[neighbour] = neighbour_f_score
                frontier.add(neighbour, neighbour_f_score)
                previous_vertices[neighbour] = current

            # previously discovered node
            elif new_g_score < known_g_score:

                assert new_g_score + heuristic(neighbour) < frontier.data[heuristic]
                g_scores[neighbour] = new_g_score
                neighbour_f_score = new_g_score + heuristic(neighbour)
                f_scores[neighbour] = neighbour_f_score
                frontier.decrease_key(neighbour, neighbour_f_score)
                previous_vertices[neighbour] = current

    raise ValueError(f'No path found!!!')


def manhattan(a: tuple[int, int], b: tuple[int, int]) -> int:
    return abs(a[0] - b[0]) + abs(a[1] - b[1])
