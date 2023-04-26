//
//  DamusState.swift
//  damus
//
//  Created by William Casarin on 2022-04-30.
//

import Foundation
import LinkPresentation

public struct DamusState {
    public let pool: RelayPool
    public let keypair: Keypair
    public let likes: EventCounter
    public let boosts: EventCounter
    public let contacts: Contacts
    public let tips: TipCounter
    public let profiles: Profiles
    public let dms: DirectMessagesModel
    public let previews: PreviewCache
    public let zaps: Zaps
    public let lnurls: LNUrls
    public let settings: UserSettingsStore
    public let relay_filters: RelayFilters
    public let relay_metadata: RelayMetadatas
    public let drafts: Drafts
    public let events: EventCache
    public let bookmarks: BookmarksManager
    public let postbox: PostBox
    public let bootstrap_relays: [String]
    public let replies: ReplyCounter
    public let muted_threads: MutedThreadsManager
    
    var pubkey: String {
        return keypair.pubkey
    }
    
    var is_privkey_user: Bool {
        keypair.privkey != nil
    }
    
    static var settings_pubkey: String? = nil
    
    static var empty: DamusState {
        return DamusState.init(pool: RelayPool(), keypair: Keypair(pubkey: "", privkey: ""), likes: EventCounter(our_pubkey: ""), boosts: EventCounter(our_pubkey: ""), contacts: Contacts(our_pubkey: ""), tips: TipCounter(our_pubkey: ""), profiles: Profiles(), dms: DirectMessagesModel(our_pubkey: ""), previews: PreviewCache(), zaps: Zaps(our_pubkey: ""), lnurls: LNUrls(), settings: UserSettingsStore(), relay_filters: RelayFilters(our_pubkey: ""), relay_metadata: RelayMetadatas(), drafts: Drafts(), events: EventCache(), bookmarks: BookmarksManager(pubkey: ""), postbox: PostBox(pool: RelayPool()), bootstrap_relays: [], replies: ReplyCounter(our_pubkey: ""), muted_threads: MutedThreadsManager(keypair: Keypair(pubkey: "", privkey: nil))) }
}
