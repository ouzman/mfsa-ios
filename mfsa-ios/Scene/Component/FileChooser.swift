//
//  FileChooser.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 31.12.2020.
//

import UIKit
import Combine

class FileChooser {
    static let instance = FileChooser()
    
    private init() { }
    
    func openDownloadFileLocationPicker(delegate: PickDownloadFileLocationDelegate) -> AnyPublisher<URL, Never> {
        
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        picker.allowsMultipleSelection = false
        picker.delegate = delegate
        
        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)
        return delegate.publisher
    }
    
    class PickDownloadFileLocationDelegate: NSObject, UIDocumentPickerDelegate {
        private let subject = PassthroughSubject<URL, Never>()
        
        var publisher: AnyPublisher<URL, Never> {
            get {
                return subject.eraseToAnyPublisher()
            }
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            subject.send(urls.first!)
        }
    }
}
