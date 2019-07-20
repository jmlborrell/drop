//
//  Queue.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-29.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import Foundation

enum LinkedListError : Error {
    case first
    case last
    case empty
    case outOfBounds
}

final class Node<T> {
    let value: T
    var next: Node<T>?
    weak var previous: Node<T>?
    
    init(value: T) {
        self.value = value
        next = nil
        previous = nil
    }
}

final class LinkedList<T> {
    
    private var first: Node<T>?
    private var head: Node<T>?
    private var tail: Node<T>?
    
    init() {
        first = nil
        head = nil
        tail = nil
    }
    
    func isEmpty() -> Bool {
        return head == nil
    }
    
    func start() -> Result<Node<T>,LinkedListError> {
        guard let f = self.first else {
            return .failure(.empty)
        }
        
        return .success(f)
    }
    
    func current() -> Result<Node<T>,LinkedListError> {
        guard let h = self.head else {
            return .failure(.empty)
        }
        
        return .success(h)
    }
    
    func last() -> Result<Node<T>,LinkedListError> {
        guard let t = self.tail else {
            return .failure(.empty)
        }
        
        return .success(t)
    }
    
    func append(value: T) {
        let node = Node(value: value)
        self.append(node: node)
    }
    
    func append(node: Node<T>) {
        guard let t = tail else {
            self.first = node
            self.head = node
            self.tail = node
            return
        }
        
        t.next = node
        node.previous = t
        self.tail = node
    }
    
    func prepend(value: T) {
        let node = Node(value: value)
        self.prepend(node: node)
    }
    
    func prepend(node: Node<T>) {
        guard let h = head else {
            self.first = node
            self.head = node
            self.tail = node
            return
        }
        
        guard let n = h.next else {
            self.append(node: node)
            return
        }
        
        h.next = node
        node.previous = h
        
        n.previous = node
        node.next = n
    }
    
    func next() -> Result<Node<T>,LinkedListError> {
        guard let h = self.head else {
            return .failure(.empty)
        }
        guard let n = h.next else {
            return .failure(.last)
        }
        
        self.head = n
        return .success(n)
    }
    
    func previous() -> Result<Node<T>, LinkedListError> {
        guard let h = self.head else {
            return .failure(.empty)
        }
        guard let p = h.previous else {
            return .failure(.first)
        }
        
        self.head = p
        return .success(p)
    }
    
    func length() -> Int {
        guard let f = first else {
            return 0
        }
        return length(node: f, count: 1)
    }
    
    private func length(node: Node<T>, count: Int) -> Int {
        guard let n = node.next else {
            return count
        }
        return length(node: n, count: count+1)
    }
    
    func reset() {
        self.head = self.first
    }
    
    func clean() {
        self.first = nil
        self.first = self.head
    }
    
    func delete() {
        self.first = nil
        self.head = nil
        self.tail = nil
    }
    
    func delete(at index: Int) throws {
        
        if (index < 0) {
            throw LinkedListError.outOfBounds
        }
        
        guard let h = self.head else {
            throw LinkedListError.empty
        }
        
        do {
            try delete(at: index, current: h)
        } catch LinkedListError.outOfBounds {
            throw LinkedListError.outOfBounds
        }
    }
    
    private func delete(at index: Int, current: Node<T>) throws {
        
        if (index == 0) {
            if let n = current.next {
                if let p = current.previous {
                    n.previous = p
                    p.next = n
                    current.next = nil
                    current.previous = nil
                } else {
                    n.previous = nil
                    current.next = nil
                    self.head = n
                }
            } else {
                if let p = current.previous {
                    current.previous = nil
                    p.next = nil
                    self.tail = p
                } else {
                    self.delete()
                }
            }
            return
        }
        
        guard let n = current.next else {
            throw LinkedListError.outOfBounds
        }
        
        do {
            try delete(at: index-1, current: n)
        } catch LinkedListError.outOfBounds {
            throw LinkedListError.outOfBounds
        }
    }
    
    func insert(at index: Int, node: Node<T>) throws {
        
        if (index < 0) {
            throw LinkedListError.outOfBounds
        }
        
        guard let h = self.head else {
            if (index == 0) {
                self.prepend(node: node)
                return
            } else {
                throw LinkedListError.empty
            }
        }
        
        if (index == 0) {
            if let p = h.previous {
                p.next = node
                node.previous = p
            }
            node.next = h
            h.previous = node
            
            self.head = node
            return
        }
        
        if (index == 1) {
            self.prepend(node: node)
            return
        }
        
        do {
            try insert(at: index, node: node, current: h)
        } catch LinkedListError.outOfBounds {
            throw LinkedListError.outOfBounds
        }
    }
    
    private func insert(at index: Int, node: Node<T>, current: Node<T>) throws {
        
        if (index == 1) {
            guard let n = current.next else {
                self.append(node: node)
                return
            }
            
            current.next = node
            node.previous = current
            
            n.previous = node
            node.next = n
            
            return
        }
        
        guard let n = current.next else {
            throw LinkedListError.outOfBounds
        }
        
        do {
            try insert(at: index-1, node: node, current: n)
        } catch LinkedListError.outOfBounds {
            throw LinkedListError.outOfBounds
        }
    }
}
