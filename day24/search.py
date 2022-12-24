from typing import Any, Callable
from abc import ABC, abstractmethod
from collections import deque
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


class BinaryHeapNode:

    __slots__ = ['element', 'key', 'index']

    def __init__(self, element: Any, key: int, index: int):
        self.element = element
        self.key = key
        self.index = index

    def __hash__(self):
        return hash(self.element)

    def __eq__(self, other):
        if type(other) != BinaryHeapNode:
            return False
        return self.element == other.element

    def __ne__(self, other):
        if type(other) != BinaryHeapNode:
            return True
        return self.element != other.element

    def __str__(self):
        return repr(self)

    def __repr__(self):
        return f'BinaryHeapNode(element={self.element}, key={self.key}, index={self.index})'


class BinaryHeap(AbstractHeap):

    def __init__(self):
        self.heap: deque[BinaryHeapNode] = deque()
        self.lookup: dict[Any, BinaryHeapNode] = {}

    def __bool__(self) -> bool:
        return bool(self.heap)

    def add(self, element: Any, key: int) -> None:
        if element in self.lookup:
            raise ValueError(f'duplicate element: {element}')
        self.__append_node(element, key)
        self.__fix_heap_property(key, len(self.heap) - 1)

    def decrease_key(self, element: Any, new_key: int) -> None:
        if element not in self.lookup:
            raise ValueError(f'no such element: {element}')
        node: BinaryHeapNode = self.lookup[element]
        old_key = node.key
        if old_key < new_key:
            raise ValueError(f'cannot increase key for {element} from {old_key} to {new_key}')
        node.key = new_key
        self.__fix_heap_property(new_key, node.index)

    def delete_minimum(self) -> Any:
        if not self:
            raise ValueError(f'no such element:')
        if len(self.heap) == 1:
            root_element = self.heap.popleft().element
        else:
            root_element = self.heap[0].element
            self.__swap_nodes(0, len(self.heap) - 1);
            self.heap.pop()
            self.__heapify(0)
        del self.lookup[root_element]
        return root_element

    def __append_node(self, element: Any, key: int) -> None:
        index = len(self.heap)
        node = BinaryHeapNode(element, key, index)
        self.lookup[element] = node
        self.heap.append(node)

    def __swap_nodes(self, a: int, b: int) -> None:
        node_a = self.heap[a]
        node_b = self.heap[b]
        node_a.index = b
        node_b.index = a
        self.heap[a] = node_b
        self.heap[b] = node_a

    def __fix_heap_property(self, key: Any, index: int):
        parent_index = (index - 1) // 2
        parent_key = self.heap[parent_index].key
        while key < parent_key:
            self.__swap_nodes(index, parent_index)
            index = parent_index
            parent_index = (index - 1) // 2
            parent_key = self.heap[parent_index].key

    def __heapify(self, index: int):
        left_index = 2 * index + 1
        right_index = left_index + 1
        key = self.heap[index].key;
        left_key = self.heap[left_index].key if left_index < len(self.heap) else None
        right_key = self.heap[right_index].key if right_index < len(self.heap) else None
        smallest_index = index
        smallest_key = key
        if left_key is not None and left_key < smallest_key:
            smallest_key = left_key
            smallest_index = left_index
        if right_key is not None and right_key < smallest_key:
            smallest_index = right_index
        if smallest_index != index:
            self.__swap_nodes(index, smallest_index)
            self.__heapify(smallest_index)


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
