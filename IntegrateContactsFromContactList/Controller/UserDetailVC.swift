//
//  UserDetailVC.swift
//  IntegrateContactsFromContactList
//
//  Created by Rahul Chopra on 22/08/18.
//  Copyright © 2018 AppSmall. All rights reserved.
//

import UIKit
import Contacts

class UserDetailVC: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var selectedContact: CNContact?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showUserDetails()
    }

    func showUserDetails() {
        if let contact = selectedContact {
            //Getting and show User Image, if available
            if let imageData = contact.imageData {
                userImageView.image = UIImage(data: imageData)
            }
            
            //Getting FirstName and LastName
            let fullName = "\(contact.givenName) \(contact.familyName)"
            
            //Getting Organization Name
            var organizationName = "N/A"
            if !contact.organizationName.isEmpty {
                organizationName = "\(contact.organizationName)"
            }
            
            //Getting Email Address
            var emailAddress = "N/A"
            if !contact.emailAddresses.isEmpty {
                let fullEmail = (((contact.emailAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value"))
                if let email = fullEmail as? String {
                    emailAddress = email
                }
            }
            
            //Getting Phone Number
            var phone = "N/A"
            if !contact.phoneNumbers.isEmpty {
                let phoneNumber = ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue"))
                if let phoneNumberString = phoneNumber as? String {
                    phone = phoneNumberString
                }
            }
            
            //Getting Street Address
            var postalAddress = "N/A"
            if !contact.postalAddresses.isEmpty {
                if let postalAddressPair = (((contact.postalAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value")) as? CNPostalAddress {
                    postalAddress = "\(postalAddressPair.street) \(postalAddressPair.city) \(postalAddressPair.state) \(postalAddressPair.postalCode)"
                    
                    print("Postal Adress: \(postalAddress)")
                }
                
            }
            
            nameLabel.text = fullName
            emailLabel.text = emailAddress
            organizationLabel.text = organizationName
            phoneLabel.text = phone
            addressLabel.text = postalAddress
        }
    }
    
}
