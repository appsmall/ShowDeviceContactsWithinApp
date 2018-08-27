//
//  ContactListVC.swift
//  IntegrateContactsFromContactList
//
//  Created by Rahul Chopra on 22/08/18.
//  Copyright © 2018 AppSmall. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactListVC: UIViewController {
    
    struct Storyboard {
        static let contactListVCToDetailedVC = "contactListVCToDetailedVC"
    }

    @IBOutlet weak var contactListTableView: UITableView!
    var allContacts = [CNContact]()    //Save all the device contacts in this array
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingAllContactsFromDevice()
    }

    func openContacts() {
        // CNContactPickerViewController :- This class allows the user to select one or more contacts (or their properties) from the list of contacts displayed in the contact
        // view controller (CNContactViewController).
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func gettingAllContactsFromDevice() {
        let contactStore = CNContactStore()       // CNContactStore :- It can fetch and save contacts, groups, and containers.
        
        // Predicate :- A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering.
        // predicateForContactsInContainer :- Returns a predicate to find the contacts in the specified container. A predicate that can be used to fetch contacts from CNContactStore.
        // defaultContainerIdentifier :- This identifier can be used to fetch a default container. A default container is where the user wants new contacts to be added implicitly.
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactStore.defaultContainerIdentifier())
        var contacts = [CNContact]()   // CNContact :- Only one user contact details
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey, CNContactOrganizationNameKey, CNContactImageDataKey]
        
        do{
            // unifiedContacts :- Fetches all unified contacts matching the specified predicate.
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as [CNKeyDescriptor])
            if contacts.count == 0{
                print("No contacts were found matching the given name.")
            }
        }catch{
            print("Unable to fetch contacts.")
        }
        
        for currentContact in contacts {
            allContacts.append(currentContact)
        }
    }
    
    //MARK:- IBACTIONS
    @IBAction func contactAccessFromDeviceContactListBtnPressed(_ sender: UIBarButtonItem) {
        let entityType = CNEntityType.contacts    //User can grant access to contacts
        
        /*** CNContactStore :- It can fetch and save contacts, groups, and containers. ***/
        //It can check the authorization status of user contact list.
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == CNAuthorizationStatus.notDetermined {
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entityType) { (sucess, error) in
                if sucess {
                    self.openContacts()
                }
                else {
                    print("You are not authorized using your contact list.")
                }
            }
        }
        else if authStatus == CNAuthorizationStatus.authorized {
            self.openContacts()
        }
    }
    
    //MARK:- NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.contactListVCToDetailedVC {
            if let destination = segue.destination as? UserDetailVC {
                if let indexPath = contactListTableView.indexPathForSelectedRow {
                    destination.selectedContact = allContacts[indexPath.row]
                }
            }
        }
    }
    
}

//MARK:- CONTACT PICKER DELEGATE METHODS
extension ContactListVC: CNContactPickerDelegate {
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }

    /*func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        self.allContacts = contacts
        contactListTableView.reloadData()
    }*/
}

//MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension ContactListVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactListCell
        
        let contact = allContacts[indexPath.row]
        cell.configureCell(contact: contact)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.contactListVCToDetailedVC, sender: nil)
    }
}
