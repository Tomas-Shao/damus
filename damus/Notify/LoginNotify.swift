//
//  LoginNotify.swift
//  damus
//
//  Created by William Casarin on 2023-07-30.
//

import Foundation

public struct LoginNotify: Notify {
    public typealias Payload = Keypair
    public var payload: Keypair
}

public extension NotifyHandler {
    static var login: NotifyHandler<LoginNotify> {
        .init()
    }
}

public extension Notifications {
    static func login(_ keypair: Keypair) -> Notifications<LoginNotify> {
        .init(.init(payload: keypair))
    }
}
