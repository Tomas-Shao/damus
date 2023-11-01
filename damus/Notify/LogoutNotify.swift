//
//  LogoutNotify.swift
//  damus
//
//  Created by William Casarin on 2023-07-30.
//

import Foundation

public struct LogoutNotify: Notify {
    public typealias Payload = ()
    public var payload: ()
}

public extension NotifyHandler {
    static var logout: NotifyHandler<LogoutNotify> {
        .init()
    }
}

public extension Notifications {
    /// Sign out of damus. Goes back to the login screen.
    static var logout: Notifications<LogoutNotify> {
        .init(.init(payload: ()))
    }
}
