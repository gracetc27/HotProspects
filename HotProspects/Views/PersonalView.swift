//
//  PersonalView.swift
//  HotProspects
//
//  Created by Grace couch on 27/11/2024.
//

import SwiftUI

struct PersonalView: View {
    @State private var viewModel = PersonalViewModel()
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var emailAddress = "you@yoursite.com"

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .font(.title)
                    .textContentType(.name)
                TextField("Email Address", text: $emailAddress)
                    .font(.title)
                    .textContentType(.emailAddress)
                Image(uiImage: viewModel.qrCode)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .contextMenu {
                        ShareLink(item: Image(uiImage: viewModel.qrCode), preview: SharePreview("My QR Code", image: Image(uiImage: viewModel.qrCode)))
                    }
            }
            .navigationTitle("Your QR Code")
            .onAppear {
                viewModel.updateQRCode(name: name, emailAddress: emailAddress)
            }
            .onChange(of: name, viewModel.updateQRCode)
            .onChange(of: emailAddress, viewModel.updateQRCode)
        }
    }

}

#Preview {
    PersonalView()
}
