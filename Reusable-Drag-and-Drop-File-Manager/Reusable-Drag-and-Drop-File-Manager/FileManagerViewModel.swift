//
//  FileManagerViewModel.swift
//  Reusable-Drag-and-Drop-File-Manager
//
//  Created by sahin raj on 12/7/24.
//

import SwiftUI
import UniformTypeIdentifiers

@MainActor
class FileManagerViewModel: ObservableObject {
    @Published var files: [FileModel] = []
    @Published var sortOption: SortOption = .name
    @Published var filterOption: FilterOption = .all

    enum SortOption: String, CaseIterable {
        case name = "Name"
        case size = "Size"
        case type = "Type"
    }

    enum FilterOption: String, CaseIterable {
        case all = "All"
        case images = "Images"
        case documents = "Documents"
    }

    // Drag-and-drop handling
    func handleFileDrop(providers: [NSItemProvider]) async {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                    guard let data = item as? Data,
                          let fileURL = URL(dataRepresentation: data, relativeTo: nil) else {
                        print("Failed to load file URL")
                        return
                    }

                    do {
                        let resourceValues = try fileURL.resourceValues(forKeys: [.fileSizeKey, .typeIdentifierKey])
                        let size = resourceValues.fileSize ?? 0
                        let type = resourceValues.typeIdentifier ?? "unknown"

                        let file = FileModel(
                            name: fileURL.lastPathComponent,
                            type: type,
                            size: Int64(size),
                            url: fileURL,
                            thumbnail: self.generateThumbnail(for: fileURL)
                        )

                        DispatchQueue.main.async {
                            self.files.append(file)
                            self.sortFiles()
                        }
                    } catch {
                        print("Failed to process file: \(error)")
                    }
                }
            }
        }
    }

    // Generate thumbnails for image files
    private func generateThumbnail(for url: URL) -> Image? {
        guard let uiImage = UIImage(contentsOfFile: url.path) else { return nil }
        return Image(uiImage: uiImage)
    }

    // Sort files based on user selection
    func sortFiles() {
        switch sortOption {
        case .name:
            files.sort { $0.name < $1.name }
        case .size:
            files.sort { $0.size < $1.size }
        case .type:
            files.sort { $0.type < $1.type }
        }
    }

    // Filter files based on user selection
    var filteredFiles: [FileModel] {
        switch filterOption {
        case .all:
            return files
        case .images:
            return files.filter { $0.fileType == "Image" }
        case .documents:
            return files.filter { $0.fileType == "Document" }
        }
    }
}
