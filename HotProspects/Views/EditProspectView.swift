//
//  EditProspectView.swift
//  HotProspects
//
//  Created by Grace couch on 29/11/2024.
//

import SwiftUI

struct EditProspectView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: EditProspectViewModel

    init(prospect: Prospect) {
        self._viewModel = State(initialValue: EditProspectViewModel(prospect: prospect))
    }
    var body: some View {
        NavigationStack {
            Form {
                TextField("prospect.name", text: $viewModel.name)

                TextField("prospect.email", text: $viewModel.emailAddress)

                Toggle("Contacted", isOn: $viewModel.isContacted)
            }
            .navigationTitle("Edit prospect")
            .toolbar {
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
            }
        }
    }

}

#Preview {
    EditProspectView(prospect: Prospect(name: "grace", emailAddress: "gtc@gnail.com", isContacted: false))
}
