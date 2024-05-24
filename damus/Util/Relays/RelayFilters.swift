//
//  RelayFilters.swift
//  damus
//
//  Created by William Casarin on 2023-02-08.
//

import Foundation

struct RelayFilter: Hashable {
    let timeline: Timeline
    let relay_id: RelayURL

    init(timeline: Timeline, relay_id: RelayURL) {
        self.timeline = timeline
        self.relay_id = relay_id
    }
}

public class RelayFilters {
    private let our_pubkey: Pubkey
    private var disabled: Set<RelayFilter>

    func is_filtered(timeline: Timeline, relay_id: RelayURL) -> Bool {
        let filter = RelayFilter(timeline: timeline, relay_id: relay_id)
        let contains = disabled.contains(filter)
        return contains
    }

    func remove(timeline: Timeline, relay_id: RelayURL) {
        let filter = RelayFilter(timeline: timeline, relay_id: relay_id)
        if !disabled.contains(filter) {
            return
        }
        
        disabled.remove(filter)
        save_relay_filters(our_pubkey, filters: disabled)
    }

    func insert(timeline: Timeline, relay_id: RelayURL) {
        let filter = RelayFilter(timeline: timeline, relay_id: relay_id)
        if disabled.contains(filter) {
            return
        }
        
        disabled.insert(filter)
        save_relay_filters(our_pubkey, filters: disabled)
    }

    public init(our_pubkey: Pubkey) {
        self.our_pubkey = our_pubkey
        disabled = load_relay_filters(our_pubkey) ?? Set()
    }
}

func save_relay_filters(_ pubkey: Pubkey, filters: Set<RelayFilter>) {
    let key = pk_setting_key(pubkey, key: "relay_filters")
    let arr = Array(filters.map { filter in "\(filter.timeline)\t\(filter.relay_id)" })
    UserDefaults.standard.set(arr, forKey: key)
}

func relay_filter_setting_key(_ pubkey: Pubkey) -> String {
    return pk_setting_key(pubkey, key: "relay_filters")
}

func load_relay_filters(_ pubkey: Pubkey) -> Set<RelayFilter>? {
    let key = relay_filter_setting_key(pubkey)
    guard let filters = UserDefaults.standard.stringArray(forKey: key) else {
        return nil
    }
    
    return filters.reduce(into: Set()) { s, str in
        let parts = str.components(separatedBy: "\t")
        guard parts.count == 2 else {
            return
        }
        guard let timeline = Timeline.init(rawValue: parts[0]) else {
            return
        }
        guard let relay_id = RelayURL(parts[1]) else {
            return
        }
        let filter = RelayFilter(timeline: timeline, relay_id: relay_id)
        s.insert(filter)
    }
}

func determine_to_relays(pool: RelayPool, filters: RelayFilters) -> [RelayURL] {
    return pool.our_descriptors
        .map { $0.url }
        .filter { !filters.is_filtered(timeline: .search, relay_id: $0) }
}
