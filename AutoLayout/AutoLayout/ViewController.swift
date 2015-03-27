//
//  ViewController.swift
//  AutoLayout
//
//  Created by Alexandre THOMAS on 25/03/15.
//  Copyright (c) 2015 Alexandre THOMAS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    var loggedInUser: User? {didSet { updateUI() } }
    var secure: Bool = false { didSet { updateUI() } }
    
    private func updateUI() {
        passwordField.secureTextEntry = secure
        passwordLabel.text = secure ? "Secured Password" : "Password"
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        image = loggedInUser?.image
    }
    
    @IBAction func toggleSecurity() {
        secure = !secure
    }
    
    @IBAction func login() {
        loggedInUser = User.login(usernameField.text ?? "", password: passwordField.text ?? "")
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            if let constrainedView = imageView {
                if let newImage = newValue {
                    aspectRationContraint = NSLayoutConstraint(
                        item: constrainedView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constrainedView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                } else {
                    aspectRationContraint = nil
                }
            }
        }
    }
    
    var aspectRationContraint: NSLayoutConstraint? {
        willSet {
            if let existingContraint = aspectRationContraint {
                view.removeConstraint(existingContraint)
            }
            
        }
        didSet {
            if let newConstraint = aspectRationContraint {
                view.addConstraint(newConstraint)
            }
        }
    }
}

extension User
{
    var image: UIImage? {
        if let image = UIImage(named: company) {
            return image
        } else {
            return UIImage(named: "unknown")
        }
        
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}