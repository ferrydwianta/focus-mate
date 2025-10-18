//
//  FocusHistoryViewModel.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import SwiftUI

@Observable
class FocusHistoryViewModel {
    var storageService: StorageService
    var sessions = [FocusSession]()
    
    init(storageService: StorageService = StorageService()) {
        self.storageService = storageService
    }
    
    func loadSessions() {
        sessions = storageService.fetchSessions()
    }
}
