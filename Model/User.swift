//
//  User.swift
//  auth_app_test
//
//  Created by Jacob Hefele on 8/8/23.
//

import Foundation

struct User: Identifiable, Codable {
    
    //Codable protocol allows mapping raw JSON data to a data object
    
    let id: String
    let fullName: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id:NSUUID().uuidString, fullName: "Ryan Gosling", email: "jgosling@gmail.com")
}
