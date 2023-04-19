//
//  TipCounter.swift
//  damus
//
//  Created by William Casarin on 2022-05-11.
//

import Foundation

public class TipCounter {
    public var tips: [String: Int64] = [:]
    public var user_tips: [String: Set<String>] = [:]
    public var our_tips: [String: NostrEvent] = [:]
    public var our_pubkey: String
    
    enum CountResult {
        case already_tipped
        case success(Int64)
    }
    
    public init (our_pubkey: String) {
        self.our_pubkey = our_pubkey
    }
}
    
