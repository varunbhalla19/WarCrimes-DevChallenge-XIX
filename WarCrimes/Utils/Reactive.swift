//
//  Reactive.swift
//  WarCrimes
//

import Foundation

/*
 A simple small reactive container to call subscribers (existing and new) for new values received.
 */
final class Reactive<T> {
    typealias Listener = ((T) -> Void)
    private var listeners: [Listener] = []

    var value: T {
        didSet { listeners.forEach { listener in listener(value) } }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: @escaping Listener) {
        self.listeners.append(listener)
        listener(value)
    }
    
    func invokeAllListeners(){
        listeners.forEach { listener in listener(value) }
    }
}
