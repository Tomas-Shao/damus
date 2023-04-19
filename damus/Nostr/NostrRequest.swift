//
//  NostrRequest.swift
//  damus
//
//  Created by William Casarin on 2022-04-12.
//

import Foundation

public struct NostrSubscribe {
    public let filters: [NostrFilter]
    public let sub_id: String
}

public enum NostrRequest {
    case subscribe(NostrSubscribe)
    case unsubscribe(String)
    case event(NostrEvent)
}
