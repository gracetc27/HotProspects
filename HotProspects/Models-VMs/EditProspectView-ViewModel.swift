//
//  EditProspectView-ViewModel.swift
//  HotProspects
//
//  Created by Grace couch on 29/11/2024.
//
import SwiftData
import SwiftUI

@Observable
class EditProspectViewModel {
    private let prospect: Prospect
    var name: String
    var emailAddress: String
    var isContacted: Bool

    init(prospect: Prospect) {
        self.prospect = prospect
        self.name = prospect.name
        self.emailAddress = prospect.emailAddress
        self.isContacted = prospect.isContacted
    }

    func save() {
        prospect.name = name
        prospect.emailAddress = emailAddress
        prospect.isContacted = isContacted
    }
}
