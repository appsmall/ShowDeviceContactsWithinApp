//
//  ContactListCell.swift
//  IntegrateContactsFromContactList
//
//  Created by Rahul Chopra on 22/08/18.
//  Copyright © 2018 AppSmall. All rights reserved.
//

import UIKit
import Contacts

class ContactListCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(contact: CNContact) {
        print("Contact : \(contact)")
        
        //Getting FirstName and LastName
        let fullName = "\(contact.givenName) \(contact.familyName)"
        
        //Getting Email Address
        var emailAddress = "N/A"
        if !contact.emailAddresses.isEmpty {
            let fullEmail = (((contact.emailAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value"))
            if let email = fullEmail as? String {
                emailAddress = email
            }
        }
        
        //Getting and show User Image, if available
        if let imageData = contact.imageData {
            userImageView.image = UIImage(data: imageData)
        }
        
        userNameLabel.text = fullName
        emailLabel.text = emailAddress
    }
    
}
