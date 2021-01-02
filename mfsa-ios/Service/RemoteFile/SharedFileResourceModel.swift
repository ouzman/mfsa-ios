//
//  SharedFileResourceModel.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 2.01.2021.
//

struct SharedFileResourceModel: Decodable {
    let nativeKey: String
    let key: String
    var fileName: String {
        get {
            let startIndex = self.key.index(self.key.startIndex, offsetBy: 37)
            let endIndex = self.key.endIndex
            let temporaryFileName = self.key[startIndex..<endIndex]
            
            return String(temporaryFileName)
        }
    }
    let owner: String
}
