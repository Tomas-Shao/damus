//
//  Notify.swift
//  damus
//
//  Created by William Casarin on 2023-07-30.
//

import Foundation
import Combine

public protocol Notify {
    associatedtype Payload
    static var name: Notification.Name { get }
    var payload: Payload { get }
}

public extension Notify {
    static var name: Notification.Name {
        Notification.Name("\(Self.self)")
    }
}

// needed because static dispatch off protocol extensions doesn't work so well
public struct Notifications<T: Notify> {
    let notify: T

    init(_ notify: T) {
        self.notify = notify
    }
}

public struct NotifyHandler<T> { }

public func notify<T: Notify>(_ notify: Notifications<T>) {
    let notify = notify.notify
    NotificationCenter.default.post(name: T.name, object: notify.payload)
}

public func handle_notify<T: Notify>(_ handler: NotifyHandler<T>) -> AnyPublisher<T.Payload, Never> {
    return NotificationCenter.default.publisher(for: T.name)
        //.compactMap { notification in notification.object as? T.Payload }
        .map { notification in notification.object as! T.Payload }
        .eraseToAnyPublisher()
}
