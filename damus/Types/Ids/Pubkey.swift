//
//  Pubkey.swift
//  damus
//
//  Created by William Casarin on 2023-07-28.
//

import Foundation

public struct Pubkey: IdType, TagKey, TagConvertible, Identifiable {
    public let id: Data

    public var tag: [String] {
        [keychar.description, self.hex()]
    }

    public init?(hex: String) {
        guard let id = hex_decode_pubkey(hex) else {
            return nil
        }
        self = id
    }

    public init(_ data: Data) {
        self.id = data
    }

    var npub: String {
        bech32_pubkey(self)
    }

    public var keychar: AsciiCharacter { "p" }

    public static func from_tag(tag: TagSequence) -> Pubkey? {
        var i = tag.makeIterator()
        guard tag.count >= 2,
              let t0 = i.next(),
              let key = t0.single_char,
              key == "p",
              let t1 = i.next(),
              let pubkey = t1.id().map(Pubkey.init)
        else { return nil }

        return pubkey
    }
    
}

