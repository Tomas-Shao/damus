//
//  Profiles.swift
//  damus
//
//  Created by William Casarin on 2022-04-17.
//

import Foundation
import UIKit


public class Profiles {
    public var profiles: [String: TimestampedProfile] = [:]
    public var validated: [String: NIP05] = [:]
    public var nip05_pubkey: [String: String] = [:]
    public var zappers: [String: String] = [:]
    
    func is_validated(_ pk: String) -> NIP05? {
        return validated[pk]
    }
    
    func lookup_zapper(pubkey: String) -> String? {
        if let zapper = zappers[pubkey] {
            return zapper
        }
        
        return nil
    }
    
    func add(id: String, profile: TimestampedProfile) {
        profiles[id] = profile
    }
    
    func lookup(id: String) -> Profile? {
        return profiles[id]?.profile
    }
    
    func lookup_with_timestamp(id: String) -> TimestampedProfile? {
        return profiles[id]
    }
}
