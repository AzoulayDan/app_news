//
//  TextFieldManager.swift
//  App_news
//
//  Created by Dan Azoulay on 22/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit

class TextFieldManager: NSObject {
    
    /*
     Cette méthode permet de verifier si l'ensemble des textfields sont remplis.
     Valeurs de retour : 
        True si un (ou plusieurs) textfield est vide
        False si l'ensemble des textfiels sont remplis
     */
    static func isEmpty_textfields (textfields:[UITextField]) -> Bool {
        var empty : Bool = false
        
        for aTextfield in textfields {
            let text_tf : String = aTextfield.text!
            if ((text_tf as NSString).length == 0) {
                empty = true
            }
        }
        return empty
    }
    
    
    /*
     Cette méthode permet de vérifier si un textfields est vide ou pas.
     Valeur de retour:
        True si le textfield est vide
        False si le textfield est remplie
     */
    static func isEmpty_textfield (textfield:UITextField) -> Bool {
        let text_tf : String = textfield.text!
        
        if ((text_tf as NSString).length == 0) {
            return true
        }
        return false
    }
    
    
    /*
     Cette méthode permet de vérifier la validité de l'email dans le textfiled entré en paramètre
     Valeur de retour:
        True si l'email est valide
        False si l'email n'est pas valide
     */
    static func isValide_email (textfield:UITextField) -> Bool {
        let fewValideEmailDomain: [String] = ["imerir.com", "live.fr","free.fr","hotmail.fr", "hotmail.com", "ironfle.com", "yahoo.fr", "laposte.net", "orange.fr", "orange.fr", "sfr.com", "sfr.fr", "yahoo.com", "laposte.fr", "wanadfoo.fr", "neuf.fr", "ville-antibes.fr", "msn.com", "univ-lyon2.fr", "renault.com", "orange-ftgroup.com", "finance-etudiant.fr", "ac-reims.fr", "ena.fr", "francetv.fr", "epitech.eu", "dbmail.com", "univ-amu.fr", "worldonline.fr"]
        
        if (textfield.text?.contains("@") == false) {
            return false
        }
        
        var valide_mail:Bool = true
        
        if (textfield.text?.contains("@") == true) {
            var domain_valid: Bool = false;
            for adomain in fewValideEmailDomain {
                if (textfield.text?.contains(adomain) == true) {
                    domain_valid = true
                }
            }
            
            //Si le domaine n'est pas dans la liste
            if (domain_valid == false) {
                valide_mail = false
            }
        }
        return valide_mail
    }
    
    
    /*
     Cette méthode permet de mettre à vide l'ensemble des textfields entrés en paramètres
     */
    static func reset_textfields (textfields:[UITextField]) ->Void {
        for atextfield in textfields {
            atextfield.text = ""
        }
    }
    
}
