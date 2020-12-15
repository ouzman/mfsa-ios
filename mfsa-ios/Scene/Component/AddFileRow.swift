//
//  AddFileRow.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 15.12.2020.
//

import UniformTypeIdentifiers
import SwiftUI

struct AddFileRow: View {
    private let pickerDelegate : UIDocumentPickerDelegate
    
    init(onFilesAdded: @escaping (URL) -> Void) {
        self.pickerDelegate = UIDocumentPickerDelegateImpl(onItemSelection: onFilesAdded)
    }
    
    var body: some View {
        Button(action: { openFileChooser() }) {
            HStack {
                Image(systemName: "plus.circle")
                Text("Add")
            }
        }
    }
    
    private func openFileChooser() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        picker.allowsMultipleSelection = false
        picker.delegate = self.pickerDelegate
        
        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
    }
}

struct AddFileRow_Previews: PreviewProvider {
    static var previews: some View {
        AddFileRow() { url in print(url) }
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

class UIDocumentPickerDelegateImpl: NSObject, UIDocumentPickerDelegate {
    let onItemSelection : (URL) -> Void
    
    init(onItemSelection : @escaping (URL) -> Void) {
        self.onItemSelection = onItemSelection
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        onItemSelection(urls.first!)
    }
}
