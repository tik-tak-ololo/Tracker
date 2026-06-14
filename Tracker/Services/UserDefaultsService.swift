//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 14.06.2026.
//

import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private let storage: UserDefaults = .standard
    
    private init() {}
    
    var hasSeenOnboarding: Bool {
        
        get {
            return storage.bool(forKey: Keys.hasSeenOnboarding.rawValue)
        }
        
        set {
            storage.set(newValue, forKey: Keys.hasSeenOnboarding.rawValue)
        }
    }
    
}

private enum Keys: String {
    case hasSeenOnboarding          // Onboarding был просмотрен
}
