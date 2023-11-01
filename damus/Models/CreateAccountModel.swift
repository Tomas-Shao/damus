//
//  CreateAccountModel.swift
//  damus
//
//  Created by William Casarin on 2022-05-20.
//

import Foundation

public class CreateAccountModel: ObservableObject {
    @Published public var real_name: String = ""
    @Published public var nick_name: String = ""
    @Published public var about: String = ""
    @Published public var pubkey: Pubkey = .empty
    @Published public var privkey: Privkey = .empty
    @Published public var profile_image: URL? = nil

    public var rendered_name: String {
        if real_name.isEmpty {
            return nick_name
        }
        return real_name
    }
    
    public var keypair: Keypair {
        return Keypair(pubkey: self.pubkey, privkey: self.privkey)
    }
    
    public init(real: String = "", nick: String = "", about: String = "") {
        let keypair = generate_new_keypair()
        self.pubkey = keypair.pubkey
        self.privkey = keypair.privkey
        self.real_name = real
        self.nick_name = nick
        self.about = about
    }
}
