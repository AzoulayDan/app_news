//
//  ConcetCompte.swift
//  News_application
//
//  Created by Developpeur on 21/05/2017.
//  Copyright © 2017 Developpeur. All rights reserved.
//

import UIKit
import CoreData

class ConcetCompte: Compte {
    static func create_account(user_name:String?, user_lastname:String?, user_email:String?, user_password:String?, user_credit:String?, user_account_id:String?, user_favorite_sports:[String]?) -> Compte {
        let new_account = NSEntityDescription.insertNewObject(forEntityName: "Compte", into: CoreDataManager.sharedManager.managedObjectContext) as! Compte
        
        new_account.compte_username = user_name
        new_account.compte_user_lastname = user_lastname
        new_account.compte_mail = user_email
        new_account.compte_password = user_password
        new_account.compte_montant = user_credit
        new_account.compte_id_in_Mongo_BDD = user_account_id
        
        if (user_favorite_sports == nil) {
            new_account.compte_sports = nil
        }
        else {
            new_account.compte_sports = NSKeyedArchiver.archivedData(withRootObject: user_favorite_sports!) as NSData
        }
        
        /*
         let desarchive = NSKeyedUnarchiver.unarchiveObject(with: archiveddatas) as? [String] pour désarchiver la données qui représente le tableau des sports
         **/
        
        
        do {
            try CoreDataManager.sharedManager.managedObjectContext.save()
        }
        catch{
            fatalError("Failure to save context \(error)")
        }
        return new_account
    }
    
    static func account_ID() -> [NSManagedObjectID] {
        let requestAccountEntity:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Compte")
        var tasksID =  [NSManagedObjectID]()
        do{
            let moc = CoreDataManager.sharedManager.managedObjectContext
            let tasksObject = try moc.fetch(requestAccountEntity) as! [Compte]
            tasksID = (tasksObject as AnyObject).value(forKey: "objectID") as! Array<NSManagedObjectID>
        } catch {
            fatalError("Failed to fetch Task \(error)")
        }
        return tasksID
    }
    
    static func get_account_with_ID (account_id : NSManagedObjectID) -> Compte {
        return CoreDataManager.sharedManager.managedObjectContext.object(with: account_id) as! Compte
    }
    
    /*Faire une fonction permettant de modifier des données dans le core data*/
    static func edit_datas_in_coreData (account_id:NSManagedObjectID, user_name:String?, user_lastname:String?, user_email:String?, user_password:String?, user_credit:String?, user_account_id:String?, user_favorite_sports:[String]?) {
        let the_account:Compte = ConcetCompte.get_account_with_ID(account_id: account_id) 
        
        if (user_name != nil) {
            the_account.compte_username = user_name
        }
        
        if (user_lastname != nil) {
            the_account.compte_user_lastname = user_lastname
        }
        
        if (user_email != nil) {
            the_account.compte_mail = user_email
        }
        
        if (user_password != nil) {
            the_account.compte_password = user_password
        }
        
        if (user_credit != nil) {
            the_account.compte_montant = user_credit
        }
        
        if (user_account_id != nil) {
            the_account.compte_id_in_Mongo_BDD = user_account_id
        }
        
        if (user_favorite_sports != nil) {
            the_account.compte_sports = NSKeyedArchiver.archivedData(withRootObject: user_favorite_sports!) as NSData
        }
        
        do {
            try CoreDataManager.sharedManager.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context \(error)")
        }
    }
    
}
