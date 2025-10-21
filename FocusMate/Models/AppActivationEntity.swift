//
//  AppActivationEntity.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 21/10/25.
//

import Foundation
import SwiftData

@Model
final class AppActivationEntity {
    @Attribute(.unique) var id: UUID
    var bundleID: String?
    var appName: String
    var timestamp: Date

    @Relationship(inverse: \FocusSessionEntity.activations) var session: FocusSessionEntity?

    init(id: UUID = UUID(),
         bundleID: String?,
         appName: String,
         timestamp: Date) {
        self.id = id
        self.bundleID = bundleID
        self.appName = appName
        self.timestamp = timestamp
    }
}
