//
//  SaveKeysView.swift
//  damus
//
//  Created by William Casarin on 2022-05-21.
//

import SwiftUI
import Security

struct SaveKeysView: View {
    let account: CreateAccountModel
    let pool: RelayPool = RelayPool(ndb: Ndb()!)
    @State var pub_copied: Bool = false
    @State var priv_copied: Bool = false
    @State var loading: Bool = false
    @State var error: String? = nil
    
    @State private var credential_handler = CredentialHandler()

    @FocusState var pubkey_focused: Bool
    @FocusState var privkey_focused: Bool
    
    let first_contact_event: NdbNote?
    
    init(account: CreateAccountModel) {
        self.account = account
        self.first_contact_event = make_first_contact_event(keypair: account.keypair)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center) {
                if account.rendered_name.isEmpty {
                    Text("Welcome!", comment: "Text to welcome user.")
                        .font(.title.bold())
                        .padding(.bottom, 10)
                } else {
                    Text("Welcome, \(account.rendered_name)!", comment: "Text to welcome user.")
                        .font(.title.bold())
                        .padding(.bottom, 10)
                }
                
                Text("Before we get started, you'll need to save your account info, otherwise you won't be able to login in the future if you ever uninstall Damus.", comment: "Reminder to user that they should save their account information.")
                    .padding(.bottom, 10)
                
                Text("Private Key", comment: "Label to indicate that the text below is the user's private key used by only the user themself as a secret to login to access their account.")
                    .font(.title2.bold())
                    .padding(.bottom, 10)
                
                Text("This is your secret account key. You need this to access your account. Don't share this with anyone! Save it in a password manager and keep it safe!", comment: "Label to describe that a private key is the user's secret account key and what they should do with it.")
                    .padding(.bottom, 10)
                
                SaveKeyView(text: account.privkey.nsec, textContentType: .newPassword, is_copied: $priv_copied, focus: $privkey_focused)
                    .padding(.bottom, 10)

                if priv_copied {
                    if loading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else if let err = error {
                        Text("Error: \(err)", comment: "Error message indicating why saving keys failed.")
                            .foregroundColor(.red)

                        Button(action: {
                            complete_account_creation(account)
                        }) {
                            HStack {
                                Text("Retry", comment:  "Button to retry completing account creation after an error occurred.")
                                    .fontWeight(.semibold)
                            }
                            .frame(minWidth: 300, maxWidth: .infinity, maxHeight: 12, alignment: .center)
                        }
                        .buttonStyle(GradientButtonStyle())
                        .padding(.top, 20)
                    } else {
                        Button(action: {
                            complete_account_creation(account)
                        }) {
                            HStack {
                                Text("Let's go!", comment:  "Button to complete account creation and start using the app.")
                                    .fontWeight(.semibold)
                            }
                            .frame(minWidth: 300, maxWidth: .infinity, maxHeight: 12, alignment: .center)
                        }
                        .buttonStyle(GradientButtonStyle())
                        .padding(.top, 20)
                    }
                }
            }
            .padding(20)
        }
        .background(
            Image("eula-bg", bundle: Bundle(for: DamusColors.self))
                .resizable()
                .blur(radius: 70)
                .ignoresSafeArea(),
            alignment: .top
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackNav())
        .onAppear {
            // Hack to force keyboard to show up for a short moment and then hiding it to register password autofill flow.
            pubkey_focused = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                pubkey_focused = false
            }
        }
    }
    
    func complete_account_creation(_ account: CreateAccountModel) {
        guard let first_contact_event else {
            error = NSLocalizedString("Could not create your initial contact list event. This is a software bug, please contact Damus support via support@damus.io or through our Nostr account for help.", comment: "Error message to the user indicating that the initial contact list failed to be created.")
            return
        }
        // Save contact list to storage right away so that we don't need to depend on the network to complete this important step
        self.save_to_storage(first_contact_event: first_contact_event, for: account)
        
        let bootstrap_relays = load_bootstrap_relays(pubkey: account.pubkey)
        for relay in bootstrap_relays {
            add_rw_relay(self.pool, relay)
        }

        self.pool.register_handler(sub_id: "signup", handler: handle_event)
        
        credential_handler.save_credential(pubkey: account.pubkey, privkey: account.privkey)

        self.loading = true
        
        self.pool.connect()
    }
    
    func save_to_storage(first_contact_event: NdbNote, for account: CreateAccountModel) {
        // Send to NostrDB so that we have a local copy in storage
        self.pool.send_raw_to_local_ndb(.typical(.event(first_contact_event)))
        
        // Save the ID to user settings so that we can easily find it later.
        let settings = UserSettingsStore.globally_load_for(pubkey: account.pubkey)
        settings.latest_contact_event_id_hex = first_contact_event.id.hex()
    }

    func handle_event(relay: RelayURL, ev: NostrConnectionEvent) {
        switch ev {
        case .ws_event(let wsev):
            switch wsev {
            case .connected:
                let metadata = create_account_to_metadata(account)
                make_first_post_event(name: "test_save", addressId: "test_save")
                if let keypair = account.keypair.to_full(),
                   let metadata_ev = make_metadata_event(keypair: keypair, metadata: metadata) {
                    self.pool.send(.event(metadata_ev))
                }
                
                if let first_contact_event {
                    self.pool.send(.event(first_contact_event))
                }
                
                do {
                    try save_keypair(pubkey: account.pubkey, privkey: account.privkey)
                    notify(.login(account.keypair))
                } catch {
                    self.error = "Failed to save keys"
                }
                
            case .error(let err):
                self.loading = false
                self.error = String(describing: err)
            default:
                break
            }
        case .nostr_event(let resp):
            switch resp {
            case .notice(let msg):
                // TODO handle message
                self.loading = false
                self.error = msg
                print(msg)
            case .event:
                print("event in signup?")
            case .eose:
                break
            case .ok:
                break
            case .auth:
                break
            }
        }
    }
}

struct SaveKeyView: View {
    let text: String
    let textContentType: UITextContentType
    @Binding var is_copied: Bool
    var focus: FocusState<Bool>.Binding
    
    func copy_text() {
        UIPasteboard.general.string = text
        is_copied = true
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                spacerBlock(width: 0, height: 0)
                Button(action: copy_text) {
                    Label("", image: is_copied ? "check-circle.fill" : "copy2")
                        .foregroundColor(is_copied ? .green : .gray)
                        .background {
                            if is_copied {
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25, alignment: .center)
                                    .padding(.leading, -8)
                                    .padding(.top, 1)
                            } else {
                                EmptyView()
                            }
                        }
                }
            }

            TextField("", text: .constant(text))
                .padding(5)
                .background {
                    RoundedRectangle(cornerRadius: 4.0).opacity(0.1)
                }
                .textSelection(.enabled)
                .font(.callout.monospaced())
                .onTapGesture {
                    copy_text()
                    // Hack to force keyboard to hide. Showing keyboard on text field is necessary to register password autofill flow but the text itself should not be modified.
                    DispatchQueue.main.async {
                        end_editing()
                    }
                }
                .textContentType(textContentType)
                .deleteDisabled(true)
                .focused(focus)
            
            spacerBlock(width: 0, height: 0) /// set a 'width' > 0 here to vary key Text's aspect ratio
        }
    }
    
    @ViewBuilder private func spacerBlock(width: CGFloat, height: CGFloat) -> some View {
        Color.orange.opacity(1)
            .frame(width: width, height: height)
    }
}

struct SaveKeysView_Previews: PreviewProvider {
    static var previews: some View {
        let model = CreateAccountModel(real: "William", nick: "jb55", about: "I'm me")
        SaveKeysView(account: model)
    }
}

public func create_account_to_metadata(_ model: CreateAccountModel) -> Profile {
    return Profile(name: model.nick_name, display_name: model.real_name, about: model.about, picture: model.profile_image?.absoluteString, banner: nil, website: nil, lud06: nil, lud16: nil, nip05: nil, damus_donation: nil)
}
