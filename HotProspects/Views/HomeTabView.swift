//
//  HomeTabView.swift
//  HotProspects
//
//  Created by Grace couch on 27/11/2024.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.message")
                }
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "plus.message")
                }
            PersonalView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    HomeTabView()
}
