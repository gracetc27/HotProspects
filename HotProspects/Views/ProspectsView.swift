//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Grace couch on 27/11/2024.
//

import CodeScanner
import SwiftData
import SwiftUI

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @State private var viewModel = ProspectsViewModel()

    var body: some View {
        NavigationStack {
            List(prospects, selection: $viewModel.selectedProspects) { prospect in
                NavigationLink(destination: EditProspectView(prospect: prospect)) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(prospect.name)
                                .font(.headline)
                            if prospect.isContacted {
                                Spacer()
                                Image(systemName: "star.bubble")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }
                }
                .onAppear {
                    viewModel.selectedProspects = []
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)

                        Button("Remind me", systemImage: "bell") {
                            viewModel.addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect)
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        viewModel.isShowingScanner = true
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                if viewModel.selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete selected") {
                            viewModel.delete(modelContext: modelContext)
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Grace\ngracetcouch@gmail.com") {
                    viewModel.handleScan(result: $0, modelContext: modelContext)
                }
            }
        }
    }
    init(filter: ProspectsViewModel.Filter) {
        self.viewModel.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            
            
            _prospects = Query(filter: #Predicate { prospect in
                prospect.isContacted == showContactedOnly
            }, sort: [SortDescriptor(\Prospect.name)])
        }
    }
}


#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
