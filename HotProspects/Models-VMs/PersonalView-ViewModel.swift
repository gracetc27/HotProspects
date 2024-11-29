//
//  PersonalView-ViewModel.swift
//  HotProspects
//
//  Created by Grace couch on 27/11/2024.
//
import CoreImage.CIFilterBuiltins
import SwiftUI
import Combine

@Observable
class PersonalViewModel {

    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var qrCode = UIImage()

    func generateQR(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

    func updateQRCode(name: String, emailAddress: String) {
        qrCode = generateQR(from: "\(name)\n\(emailAddress)")
    }
}

