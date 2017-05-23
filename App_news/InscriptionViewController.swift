//
//  InscriptionViewController.swift
//  App_news
//
//  Created by Dan Azoulay on 23/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit
import CoreData

class InscriptionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mNameTextField: UITextField!
    @IBOutlet weak var mLastNameTextField: UITextField!
    @IBOutlet weak var mMailTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    @IBOutlet weak var mPasswordVerifTextField: UITextField!
    
    let name_placeholder = "Nom"
    let lastname_placeholder = "Prénom"
    let mail_placeholder = "Mail : exmaple@example.com"
    let password_placeholer = "Mot de passe"
    let  verifPassword_placeholder = "Confirmation du mot de passe"
    var mIncorrect_verif : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Inscription"
        initialize_navBar()
        initialize_textfields_view()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Méthodes internes */
    internal func initialize_navBar () {
        self.navigationItem.hidesBackButton = true
        let cancel = UIBarButtonItem(title: "Annuler", style: .done, target: self, action: #selector(onPressedNextNavBarButton))
        let next = UIBarButtonItem(title: "Suivant", style: .done, target: self, action: #selector(onPressedNextNavBarButton))
        self.navigationItem.setLeftBarButton(cancel, animated: true)
        self.navigationItem.setRightBarButton(next, animated: true)
    }
    
    internal func initialize_textfields_view () {
        self.mMailTextField.placeholder = mail_placeholder
        self.mLastNameTextField.placeholder = lastname_placeholder
        self.mNameTextField.placeholder = name_placeholder
        self.mPasswordTextField.placeholder = password_placeholer
        self.mPasswordVerifTextField.placeholder = verifPassword_placeholder
        self.mPasswordTextField.isSecureTextEntry = true
        self.mPasswordVerifTextField.isSecureTextEntry = true
    }
    
    internal func reset_all_textfields () {
        TextFieldManager.reset_textfields(textfields: [self.mNameTextField, self.mLastNameTextField, self.mMailTextField,self.mPasswordTextField, self.mPasswordVerifTextField])
        self.initialize_textfields_view()
    }
    
    internal func display_alert_with_one_action (title:String?, message:String?, titleAction:String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alertVC.addAction(done)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    internal func areFill_correctly () -> Bool {
        //Tous sont-ils remplis?
        let all_filled : Bool = TextFieldManager.isEmpty_textfields(textfields: [self.mNameTextField, self.mLastNameTextField, self.mMailTextField, self.mPasswordTextField, self.mPasswordVerifTextField])
        
        //Les chmaps ne sont pas tous remplis
        if (all_filled == true) {
            self.display_alert_with_one_action(title: "Champs non remplis", message: "Tous les champs doivent être remplis pour continuer l'inscription", titleAction: "OK")
            return false
        }
        
        //Les champs sont tous remplis
        if (all_filled == false) {
            //L'adresse mail est-elle valide?
            let valide_email_adress = TextFieldManager.isValide_email(textfield: self.mMailTextField)
            
            //L'adresse email entrée n'est pas valide
            if (valide_email_adress == false) {
                self.display_alert_with_one_action(title: "Email invalide", message: "Adresse email invalide", titleAction: "Fermer")
                return false
            }
            
            //Si l'adresse email est valide
            if (valide_email_adress == true) {
                //Les mots de passe sont-ils identiques?
                //Les mots de passe entrés ne sont identiques
                if ((self.mPasswordTextField.text! as NSString).isEqual(to: self.mPasswordVerifTextField.text!) == false) {
                    self.display_alert_with_one_action(title: "Confirmation incorrecte", message: "La confirmation de votre mot de passe ne correspond pas à votre premier mot de passe", titleAction: "Fermer")
                    self.mIncorrect_verif = true
                    return false
                }
            }
        }
        return true
    }
    
    /* Actions buttons */
        //CancelButton in the left on the navBar
    internal func onPressedCancelNavBarButton () {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
        //NextButton in the right on the navBar
    internal func onPressedNextNavBarButton () {
        let correctly_filled_textfields = areFill_correctly()
        
        //Les textfields sont correctements remplis
        if (correctly_filled_textfields == true) {
            /* On enregistre crée une instance compte dans le core data, afin d'enregistrer l'utilisateur */
            let name = self.mNameTextField.text
            let lastname = self.mLastNameTextField.text
            let mail = self.mMailTextField.text
            let password = self.mPasswordTextField.text
            
            _ = ConcetCompte.create_account(user_name: name, user_lastname: lastname, user_email: mail, user_password: password, user_credit: nil, user_account_id: nil, user_favorite_sports: nil)
            
            print("Jute pour vérification: \(ConcetCompte.account_ID())")
            
            let choiceSportsVC = ChoiceSportsTableViewController(nibName: "ChoiceSportsTableViewController", bundle: nil)
            self.navigationController?.pushViewController(choiceSportsVC, animated: true)

        }
        //Les textFiels ne sont pas correctement remplis
        else {
            if (self.mIncorrect_verif == true) {
                TextFieldManager.reset_textfields(textfields: [self.mPasswordTextField, self.mPasswordVerifTextField])
                self.mPasswordTextField.placeholder = password_placeholer
                self.mPasswordVerifTextField.placeholder = verifPassword_placeholder
            }
            else {
                self.reset_all_textfields()
            }
        }
    }
    
        //Reset button at the buottom of the page
    @IBAction func onPressedResetButton(_ sender: UIButton) {
        self.reset_all_textfields()
    }
    
    /* Implementaiton du delegate */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (TextFieldManager.isEmpty_textfield(textfield: textField) == true) {
            textField.placeholder = ""
        }
        return true
    }
}
