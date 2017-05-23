//
//  ConnexionViewController.swift
//  App_news
//
//  Created by Dan Azoulay on 22/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit
import CoreData

let url_request = "http://localhost:5000/user/account"

class ConnexionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mEmailTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    
    let mail_placeholder = "examples@gmail.com"
    let password_placeholder = "your password"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Connexion"
        self.initialize_textfields_view()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Les actions des boutons */
        //Connexion
    @IBAction func onPressedLoginButton(_ sender: UIButton) {
        let correctly_fill : Bool = self.areFilled_correctly()
        
        if (correctly_fill == true) {
            let email_tf_text = self.mEmailTextField.text!
            let password_tf_text = self.mPasswordTextField.text!
            
            print(password_tf_text)
            
            //On regarde si l'utilisateur existe dans la base de données
            let result_request = RequestManager.do_post_request_account(atUrl: url_request, withData: ["mail":email_tf_text, "motdepasse":password_tf_text])
            print(result_request)
            
            //L'utilisateur n'existe pas dans la base de données
            if (result_request.count == 0) {
                display_alert_with_one_action(title: "Champs incorrects", message: "Email ou mot de passe incorrects", titleAction: "Fermer")
            }

            //L'utilisateur existe dans la base de données
            if (result_request.count > 0) {
                //Les informations sur lui sont enregistrés dans le coredata
                save_in_coredata(datas: result_request)
                
                //On le connecte (redirection vers la vue news)
                let newsVC = NewsTableViewController(nibName: "NewsTableViewController", bundle: nil)
                self.navigationController?.pushViewController(newsVC, animated: true)
            }
        }
        self.reset_textfields_view()
     }
    
        //Inscription
    @IBAction func onPressedRegisterButton(_ sender: UIButton) {
        let registerVC = InscriptionViewController(nibName: "InscriptionViewController", bundle: nil)
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    /* Methodes internes */
    internal func areFilled_correctly () -> Bool {
        let all_textfield_empty = TextFieldManager.isEmpty_textfields(textfields: [self.mEmailTextField, self.mPasswordTextField])
        
        //Un ou plusieurs textfiels sont vides
        if (all_textfield_empty == true) {
            self.display_alert_with_one_action(title: "Champs non remplis", message: "L'ensemble des champs doivent être remplis", titleAction: "OK")
            return false
        }
        
        //Les textfiels sont remplis
        if (all_textfield_empty == false) {
            let mail_valide = TextFieldManager.isValide_email(textfield: self.mEmailTextField)
            
            //Si le mail n'est pas valide alors on retourne false
            if (mail_valide == false) {
                self.display_alert_with_one_action(title: "Email invalide", message: "L'adresse mail saisie n'est pas valide", titleAction: "Fermer")
                return false
            }
        }
        return true
    }
    
    internal func display_alert_with_one_action (title:String?, message:String?, titleAction:String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alertVC.addAction(done)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    internal func reset_textfields_view () {
        TextFieldManager.reset_textfields(textfields: [self.mEmailTextField, self.mPasswordTextField])
        self.mEmailTextField.placeholder = mail_placeholder
        self.mPasswordTextField.placeholder = password_placeholder
    }
    
    internal func save_in_coredata(datas:[[String:Any]]) -> Void {
        let name = datas[0]["nom"] as! String
        let sports = datas[0]["sport"] as! [String]
        let lastname = datas[0]["prenom"] as! String
        let credit = datas[0]["montant"] as! String
        let mail = datas[0]["mail"] as! String
        let account_id = datas[0]["_id"] as! String
        let password = datas[0]["motdepasse"] as! String
        
        _ = ConcetCompte.create_account(user_name: name, user_lastname: lastname, user_email: mail, user_password: password, user_credit: credit, user_account_id: account_id, user_favorite_sports: sports)
        
        print("Juste pour la vérification de l'ajout : \(ConcetCompte.account_ID().count)")
    }
    
    internal func initialize_textfields_view () {
        self.mEmailTextField.placeholder = mail_placeholder
        self.mPasswordTextField.placeholder = password_placeholder
        self.mPasswordTextField.isSecureTextEntry = true
    }
    
    /* Implémentation des delegate */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (TextFieldManager.isEmpty_textfield(textfield: textField) == true) {
            textField.placeholder = ""
        }
        return true
    }
    
}
