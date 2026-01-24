//
//  ExportableImage.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/23/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportableImage: Transferable {
    let uiImage: UIImage
    let fileName: String
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { exportableImage in
            exportableImage.uiImage.pngData() ?? Data()
        }
        .suggestedFileName { exportableImage in
            exportableImage.fileName
        }
    }
}
