//
//  Contact.swift
//  MyContact
//
//  Created by Reza Kashkoul on 11/4/1401 AP.
//

import Foundation
import Contacts

struct Contact: Equatable {
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.telephone == rhs.telephone
    }
    
    var firstName: String
    var lastName: String
    var telephone: String
    var isPicked: Bool
}
