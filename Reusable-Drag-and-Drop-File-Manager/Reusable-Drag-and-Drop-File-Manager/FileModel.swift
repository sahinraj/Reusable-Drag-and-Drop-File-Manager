//
//  FileModel.swift
//  Reusable-Drag-and-Drop-File-Manager
//
//  Created by sahin raj on 12/7/24.
//
import SwiftUI

struct FileModel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let type: String
    let size: Int64
    let url: URL
    var thumbnail: Image? = nil

    // Format file size as a readable string (e.g., KB, MB)
    var formattedSize: String {
        ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }

    // Determine file type for filtering
    var fileType: String {
        if type.starts(with: "image") {
            return "Image"
        } else if type.starts(with: "text") || type.starts(with: "application") {
            return "Document"
        } else {
            return "Other"
        }
    }

    // Explicitly conform to Hashable
    static func == (lhs: FileModel, rhs: FileModel) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.type == rhs.type && lhs.size == rhs.size && lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(size)
        hasher.combine(url)
    }
}

