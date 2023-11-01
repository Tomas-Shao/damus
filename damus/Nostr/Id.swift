//
//  Id.swift
//  damus
//
//  Created by William Casarin on 2023-07-26.
//

import Foundation

struct TagRef<T>: Hashable, Equatable, Encodable {
    let elem: TagElem

    init(_ elem: TagElem) {
        self.elem = elem
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(elem.string())
    }
}

public protocol TagKey {
    var keychar: AsciiCharacter { get }
}

protocol TagKeys {
    associatedtype TagKeys: TagKey
    var key: TagKeys { get }
}

public protocol TagConvertible {
    var tag: [String] { get }
    static func from_tag(tag: TagSequence) -> Self?
}

public struct QuoteId: IdType, TagKey, TagConvertible {
    public let id: Data

    public init(_ data: Data) {
        self.id = data
    }
    
    /// Refer to this QuoteId as a NoteId
    var note_id: NoteId {
        NoteId(self.id)
    }

    public var keychar: AsciiCharacter { "q" }

    public var tag: [String] {
        ["q", self.hex()]
    }
    
    public static func from_tag(tag: TagSequence) -> QuoteId? {
        var i = tag.makeIterator()

        guard tag.count >= 2,
              let t0 = i.next(),
              let key = t0.single_char,
              key == "q",
              let t1 = i.next(),
              let quote_id = t1.id().map(QuoteId.init)
        else { return nil }

        return quote_id
    }
}


public struct Privkey: IdType {
    public let id: Data

    var nsec: String {
        bech32_privkey(self)
    }

    init?(hex: String) {
        guard let id = hex_decode_id(hex) else {
            return nil
        }
        self.init(id)
    }

    public init(_ data: Data) {
        self.id = data
    }
}


public struct Hashtag: TagConvertible, Hashable {
    let hashtag: String

    public static func from_tag(tag: TagSequence) -> Hashtag? {
        var i = tag.makeIterator()

        guard tag.count >= 2,
              let t0 = i.next(),
              let chr = t0.single_char,
              chr == "t",
              let t1 = i.next() else {
            return nil
        }

        return Hashtag(hashtag: t1.string())
    }

    public var tag: [String] { ["t", self.hashtag] }
    var keychar: AsciiCharacter { "t" }
}

public struct ReplaceableParam: TagConvertible {
    let param: TagElem

    public static func from_tag(tag: TagSequence) -> ReplaceableParam? {
        var i = tag.makeIterator()

        guard tag.count >= 2,
              let t0 = i.next(),
              let chr = t0.single_char,
              chr == "d",
              let t1 = i.next() else {
            return nil
        }

        return ReplaceableParam(param: t1)
    }

    public var tag: [String] { [self.keychar.description, self.param.string()] }
    var keychar: AsciiCharacter { "d" }
}

struct Signature: Hashable, Equatable {
    let data: Data

    init(_ p: Data) {
        self.data = p
    }
}
