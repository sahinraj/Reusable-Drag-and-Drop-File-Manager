//
//  FilePreview.swift
//  Reusable-Drag-and-Drop-File-Manager
//
//  Created by sahin raj on 12/7/24.
//

import SwiftUI

struct FilePreview: View {
    let file: FileModel

    var body: some View {
        HStack(spacing: 10) {
            // File Thumbnail
            if let thumbnail = file.thumbnail {
                thumbnail
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(Text(file.type.prefix(1)).bold())
            }

            // File Metadata
            VStack(alignment: .leading) {
                Text(file.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(file.formattedSize)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(file.fileType)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        .shadow(radius: 2)
    }
}
