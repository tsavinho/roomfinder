//
//  QueueStuff.swift
//  roomfinder
//
//  Created by Pascal Köchli on 12.02.2024.
//

import Foundation

struct PriorityQueue<Element: Comparable>: Queue {
    private var heap: Heap<Element>

    init(sort: @escaping (Element, Element) -> Bool) {
        heap = Heap(sort: sort)
    }

    var isEmpty: Bool {
        heap.isEmpty
    }

    var peek: Element? {
        heap.peek()
    }

    mutating func enqueue(_ element: Element) {
        heap.insert(element)
    }

    mutating func dequeue() -> Element? {
        heap.remove()
    }
}

protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element: Element)
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}

struct Heap<Element: Comparable> {
    private var elements: [Element] = []
    private let sort: (Element, Element) -> Bool

    var isEmpty: Bool {
        elements.isEmpty
    }

    init(sort: @escaping (Element, Element) -> Bool) {
        self.sort = sort
    }

    func peek() -> Element? {
        elements.first
    }

    mutating func insert(_ element: Element) {
        elements.append(element)
        siftUp()
    }

    mutating func remove() -> Element? {
        guard !isEmpty else {
            return nil
        }
        elements.swapAt(0, elements.count - 1)
        defer {
            siftDown()
        }
        return elements.removeLast()
    }

    private mutating func siftUp() {
        var child = elements.count - 1
        while child > 0 {
            let parent = (child - 1) / 2
            if sort(elements[child], elements[parent]) {
                elements.swapAt(child, parent)
                child = parent
            } else {
                return
            }
        }
    }

    private mutating func siftDown() {
        var parent = 0
        while true {
            let left = 2 * parent + 1
            let right = left + 1
            var candidate = parent
            if left < elements.count && sort(elements[left], elements[candidate]) {
                candidate = left
            }
            if right < elements.count && sort(elements[right], elements[candidate]) {
                candidate = right
            }
            if candidate == parent {
                return
            }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
}
