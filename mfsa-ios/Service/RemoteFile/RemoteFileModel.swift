//
//  RemoteFileModel.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 30.12.2020.
//

struct RemoteFileModel: Identifiable, Hashable {
    var id: String {
        get {
            return self.key
        }
    }
    
    let key: String
    let nativeFileKey: String
    let fileName: String
    let owner: String?
}
