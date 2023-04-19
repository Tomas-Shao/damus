//
//  Report.swift
//  damus
//
//  Created by William Casarin on 2023-01-24.
//

import Foundation

public enum ReportType: String {
    case explicit
    case illegal
    case spam
    case impersonation
}

public struct ReportNoteTarget {
    public let pubkey: String
    public let note_id: String
}

public enum ReportTarget {
    case user(String)
    case note(ReportNoteTarget)
}

public struct Report {
    public let type: ReportType
    public let target: ReportTarget
    public let message: String
}

func create_report_tags(target: ReportTarget, type: ReportType) -> [[String]] {
    var tags: [[String]]
    switch target {
    case .user(let pubkey):
        tags = [["p", pubkey]]
    case .note(let notet):
        tags = [["e", notet.note_id], ["p", notet.pubkey]]
    }
    
    tags.append(["report", type.rawValue])
    return tags
}

func create_report_event(privkey: String, report: Report) -> NostrEvent? {
    guard let pubkey = privkey_to_pubkey(privkey: privkey) else {
        return nil
    }
    
    let kind = 1984
    let tags = create_report_tags(target: report.target, type: report.type)
    let ev = NostrEvent(content: report.message, pubkey: pubkey, kind: kind, tags: tags)
    
    ev.id = calculate_event_id(ev: ev)
    ev.sig = sign_event(privkey: privkey, ev: ev)
    
    return ev
}
