//
//  Report.swift
//  damus
//
//  Created by William Casarin on 2023-01-24.
//

import Foundation

public enum ReportType: String, CustomStringConvertible, CaseIterable {
    case spam
    case nudity
    case profanity
    case illegal
    case impersonation

    var description: String {
        switch self {
        case .spam:
            return NSLocalizedString("Spam", comment: "Description of report type for spam.")
        case .nudity:
            return NSLocalizedString("Nudity", comment: "Description of report type for nudity.")
        case .profanity:
            return NSLocalizedString("Profanity", comment: "Description of report type for profanity.")
        case .illegal:
            return NSLocalizedString("Illegal Content", comment: "Description of report type for illegal content.")
        case .impersonation:
            return NSLocalizedString("Impersonation", comment: "Description of report type for impersonation.")
        }
    }
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
    switch target {
    case .user(let pubkey):
        return [["p", pubkey, type.rawValue]]
    case .note(let notet):
        return [["e", notet.note_id, type.rawValue], ["p", notet.pubkey]]
    }
}

func create_report_event(keypair: FullKeypair, report: Report) -> NostrEvent? {
    let kind: UInt32 = 1984
    let tags = create_report_tags(target: report.target, type: report.type)
    return NostrEvent(content: report.message, keypair: keypair.to_keypair(), kind: kind, tags: tags)
}
