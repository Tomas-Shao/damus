//
//  NostrFilter.swift
//  damus
//
//  Created by William Casarin on 2022-04-11.
//

import Foundation

public struct NostrFilter: Codable, Equatable {
    public var ids: [String]?
    public var kinds: [NostrKind]?
    public var referenced_ids: [String]?
    public var pubkeys: [String]?
    public var since: Int64?
    public var until: Int64?
    public var limit: UInt32?
    public var authors: [String]?
    public var hashtag: [String]?
    public var parameter: [String]?

    private enum CodingKeys : String, CodingKey {
        case ids
        case kinds
        case referenced_ids = "#e"
        case pubkeys = "#p"
        case hashtag = "#t"
        case parameter = "#d"
        case since
        case until
        case authors
        case limit
    }
    
    public init(ids: [String]? = nil, kinds: [NostrKind]? = nil, referenced_ids: [String]? = nil, pubkeys: [String]? = nil, since: Int64? = nil, until: Int64? = nil, limit: UInt32? = nil, authors: [String]? = nil, hashtag: [String]? = nil) {
        self.ids = ids
        self.kinds = kinds
        self.referenced_ids = referenced_ids
        self.pubkeys = pubkeys
        self.since = since
        self.until = until
        self.limit = limit
        self.authors = authors
        self.hashtag = hashtag
    }
    
    public static func copy(from: NostrFilter) -> NostrFilter {
        NostrFilter(ids: from.ids, kinds: from.kinds, referenced_ids: from.referenced_ids, pubkeys: from.pubkeys, since: from.since, until: from.until, authors: from.authors, hashtag: from.hashtag)
    }
    
    public static func filter_hashtag(_ htags: [String]) -> NostrFilter {
        NostrFilter(hashtag: htags.map { $0.lowercased() })
    }
}
