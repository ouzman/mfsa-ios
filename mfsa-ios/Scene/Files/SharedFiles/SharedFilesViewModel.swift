//
//  MyFilesViewModel.swift
//  mfsa-ios
//
//  Created by Oguzhan Uzman on 30.12.2020.
//

import Combine
import Foundation

final class SharedFilesViewModel : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorAlertDetails: ErrorAlertDetails? = nil

}
