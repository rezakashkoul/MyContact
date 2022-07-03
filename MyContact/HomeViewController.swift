//
//  HomeViewController.swift
//  MyContact
//
//  Created by Reza Kashkoul on 11/4/1401 AP.
//

import UIKit
import Contacts

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contacts = [Contact]()
    var selectedContacts: [Contact] = []
    var isSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        setupUI()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.contacts.append(Contact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? "", isPicked: false))
                        self.contacts = self.contacts.sorted(by: {$0.firstName < $1.firstName})
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath)
        cell.selectionStyle = .none
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.firstName + " " + contact.lastName
        cell.detailTextLabel?.text = contacts[indexPath.row].telephone
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let currentContact = contacts[indexPath.row]
        if selectedContacts.filter({$0 == currentContact}).isEmpty {
            cell.accessoryType = .checkmark
            selectedContacts.append(currentContact)
        } else {
            selectedContacts = selectedContacts.filter({$0 != currentContact})
            cell.accessoryType = .none
        }
    }
}
