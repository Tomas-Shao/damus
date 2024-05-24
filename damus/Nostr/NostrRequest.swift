//
//  NostrRequest.swift
//  damus
//
//  Created by William Casarin on 2022-04-12.
//

import Foundation

public struct NostrSubscribe {
    let filters: [NostrFilter]
    let sub_id: String
}

public enum NostrRequestType {
    case typical(NostrRequest)
    case custom(String)
    
    var is_write: Bool {
        guard case .typical(let req) = self else {
            return true
        }
        
        return req.is_write
    }
    
    var is_read: Bool {
        guard case .typical(let req) = self else {
            return true
        }
        
        return req.is_read
    }
}

public enum NostrRequest {
    case subscribe(NostrSubscribe)
    case unsubscribe(String)
    case event(NostrEvent)
    case auth(NostrEvent)

    var is_write: Bool {
        switch self {
        case .subscribe:
            return false
        case .unsubscribe:
            return false
        case .event:
            return true
        case .auth:
            return false
        }
    }
    
    var is_read: Bool {
        return !is_write
    }
    
}
