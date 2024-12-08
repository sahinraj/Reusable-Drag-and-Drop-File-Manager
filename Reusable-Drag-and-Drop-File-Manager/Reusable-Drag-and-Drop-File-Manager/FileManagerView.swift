//
//  FileManagerView.swift
//  Reusable-Drag-and-Drop-File-Manager
//
//  Created by sahin raj on 12/7/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileManagerView: View {
    @StateObject private var viewModel = FileManagerViewModel()

    var body: some View {
        VStack {
            // Drag-and-Drop Area
            FileDropArea()
                .onDrop(of: [UTType.fileURL], isTargeted: nil) { providers in
                    Task {
                        await viewModel.handleFileDrop(providers: providers)
                    }
                    return true
                }

            // Sorting and Filtering Options
            HStack {
                Picker("Sort By", selection: $viewModel.sortOption) {
                    ForEach(FileManagerViewModel.SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: viewModel.sortOption) { _ in
                    viewModel.sortFiles()
                }

                Picker("Filter", selection: $viewModel.filterOption) {
                    ForEach(FileManagerViewModel.FilterOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()

            // File List
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.filteredFiles) { file in
                        FilePreview(file: file)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
    }
}

struct FileDropArea: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .strokeBorder(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [10]))
            .frame(height: 150)
            .overlay(Text("Drag and drop files here").foregroundColor(.gray))
            .padding()
    }
}
