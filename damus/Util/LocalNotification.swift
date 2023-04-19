//
//  LocalNotification.swift
//  damus
//
//  Created by William Casarin on 2023-04-15.
//

import Foundation

public struct LossyLocalNotification {
    public let type: LocalNotificationType
    public let event_id: String
    
    public func to_user_info() -> [AnyHashable: Any] {
        return [
            "type": self.type.rawValue,
            "evid": self.event_id
        ]
    }
    
    public static func from_user_info(user_info: [AnyHashable: Any]) -> LossyLocalNotification {
        let target_id = user_info["evid"] as! String
        let typestr = user_info["type"] as! String
        let type = LocalNotificationType(rawValue: typestr)!
        
        return LossyLocalNotification(type: type, event_id: target_id)
    }
}

public struct LocalNotification {
    public let type: LocalNotificationType
    public let event: NostrEvent
    public let target: NostrEvent
    public let content: String
    
    public func to_lossy() -> LossyLocalNotification {
        return LossyLocalNotification(type: self.type, event_id: self.target.id)
    }
}

public enum LocalNotificationType: String {
    case dm
    case like
    case mention
    case repost
    case zap
}
