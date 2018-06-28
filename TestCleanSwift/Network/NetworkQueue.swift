//
//  NetworkQueue.swift
//  TestCleanSwift
//
//  Created by Tanasak.Nge on 5/6/2561 BE.
//  Copyright © 2561 NilNilNil. All rights reserved.
//

import Foundation

public struct Queue<T> {
  private var array = [T?]()
  private var head = 0
  private typealias funcType = () -> ()

  public var isEmpty: Bool {
    return count == 0
  }

  public var count: Int {
    return array.count - head
  }

  public var front: T? {
    if isEmpty {
      return nil
    } else {
      return array[head]
    }
  }

  private func synced(_ lock: Any, closure: funcType) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }

  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    removeUnusedEmptySpace()

    return element
  }

  public mutating func dequeueSyncAndExecute() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    removeUnusedEmptySpace()

    // Execute each element synchronously
    synced(self) {
      (element as? funcType)?()
    }
    return element
  }

  // Using this instead of removeFirst to improve performance O(1) instead of O(n)
  private mutating func removeUnusedEmptySpace () {
    let percentage = Double(head)/Double(array.count)
    if array.count > 50 && percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }
  }
}
