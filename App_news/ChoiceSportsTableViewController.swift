//
//  ChoiceSportsTableViewController.swift
//  App_news
//
//  Created by Dan Azoulay on 23/05/2017.
//  Copyright © 2017 Dan Azoulay. All rights reserved.
//

import UIKit
import CoreData

class ChoiceSportsTableViewController: UITableViewController {
    
    let url_creation_account = "http://lcoalhost:5000/creation"
    
    @IBOutlet var mTableView: UITableView!
    var mSelected_sports = [IndexPath]() //Contient les indexPaths des sports selectionnés dans la tableview
    
    let m_all_sports = ["Athetisme", "Badminton", "Basketball", "Boxe", "Cyclisme sur route", "Equestre", "Escrime", "Football", "Gymnastique", "Halterophilie", "Handball", "Judo", "Natation", "Rugby", "Taekwondo", "Tennis de table", "Tennis", "Tir à l'arc","Tir", "VolleyBall", "Waterpolo"]
    let message_header:String = "Suivez l'actualité des sports sélectionnés"
    var mtous : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choix sports"
        self.initialize_navBar()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.message_header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.m_all_sports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        let reuseIdentifier = "cell"
        tableView.register(UINib.init(nibName: "ChoiceSportsTableViewCell", bundle: nil) , forCellReuseIdentifier: reuseIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChoiceSportsTableViewCell
        
        if (mtous == true ){
            cell.mSelectedImage.image = UIImage(named: "selectedGreen.png")
            self.mSelected_sports.append(indexPath)
        }
        else {
            if (mSelected_sports.count > 0) {
                if (self.isInArray(indexPath: indexPath, array: self.mSelected_sports) == true) {
                    cell.mSelectedImage.image = UIImage(named: "selectedGreen.png")
                }
                else {
                    let checkbox_img = UIImage(named: "selectedWhite.png")
                    cell.mSelectedImage.image = checkbox_img
                }
            }
            
            if (self.mSelected_sports.count == 0) {
                let checkbox_img = UIImage(named: "selectedWhite.png")
                cell.mSelectedImage.image = checkbox_img
            }
        }
        cell.mSportLabel.text = self.m_all_sports[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChoiceSportsTableViewCell
        
        let image_cell = cell.mSelectedImage.image
        let image_white = UIImage(named:"selectedWhite.png")
        let image_green = UIImage(named:"selectedGreen.png")
        
        if (image_cell?.isEqual(image_white) == true) {
            cell.mSelectedImage.image = image_green
            self.mSelected_sports.append(indexPath)
        }
        else {
            cell.mSelectedImage.image = image_white
            let index_element_to_remmove = self.mSelected_sports.index(of: indexPath)
            self.mSelected_sports.remove(at: index_element_to_remmove!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /* Les actions sur les boutons */
    internal func onPressedFinishedRegisterNavBarButton () {
        /* L'utilisateur n'a sélectionné aucune sport */
        if (self.mSelected_sports.count == 0) {
            self.display_alert_with_one_action(title: "Pas de sports sélectionné", message: "Indiquez les spoets que vous désirez suivre", titleAction: "Fermer")
        }
        
        /* L'utilisateur a sélectionné des sports */
        if (self.mSelected_sports.count  > 0) {
            //A partir des indexPath, on récupère un tableau de sport ([String])
            let sports_choosen : [String] = self.get_string_sports_selected(sport_selected_indexPath: self.mSelected_sports)
            print(sports_choosen)
            
            //On les enregistre les sports dans le corps data
                //On récupère l'id du compte (pas difficile il n'y en a qu'un seul)
            let id_compte = ConcetCompte.account_ID().first
            ConcetCompte.edit_datas_in_coreData(account_id: id_compte!, user_name: nil, user_lastname: nil, user_email: nil, user_password: nil, user_credit: nil, user_account_id: nil, user_favorite_sports: sports_choosen)
            
            print("enfin mise dans le core data")
            
            print("Juste par vérification, on affiche l'élément dans le Core data mais avec les sports; ")
            print(ConcetCompte.get_account_with_ID(account_id: id_compte!))

            
            //On fait une requête post pour enregistrer un nouveau compte sur la base de données
                //On met en place le document qui va être inséré en base de données mangoDB (récupération isntance dans coredata + mise en place du document a insérer dans la base de dnnées MongoDB
            let infos_account = ConcetCompte.get_account_with_ID(account_id: id_compte!) 
            let name = infos_account.compte_username
            let lastname = infos_account.compte_user_lastname
            let mail = infos_account.compte_mail
            let password = infos_account.compte_password
            let montant = "0"
            let sports = sports_choosen
            let date = Date().description
            
            let document_to_insert : [String:Any] = ["nom":name!, "sport":sports, "proenom":lastname!, "montant":montant, "date":date, "mail":mail!, "type":"punlic", "motdepasse":password!]
            
            //ajout ds la bdd
            print("avant la requete")
            let account_creation_request = RequestManager.do_post_request_creation(atUrl:"http://localhost:5000/brouillon/creation", withData: document_to_insert)
            
            print("apres la requete")
            print(account_creation_request)
            //On met a jour le core data en faisant une requete permettant de récupérer uniquement le compte nouvellemet créé
            if (account_creation_request.characters.count > 0) {
                //Si le compte a correctement été crée en base
                print("compte bien cré en base de données")
                ConcetCompte.edit_datas_in_coreData(account_id: ConcetCompte.account_ID().first!, user_name: nil, user_lastname: nil, user_email: nil, user_password: nil, user_credit: "0", user_account_id: account_creation_request, user_favorite_sports: sports_choosen)
                
                //On connecte l'utilisateur
                let sportChoosenVC = SportsChoosenTableViewController(nibName: "SportsChoosenTableViewController", bundle: nil)
                self.navigationController?.pushViewController(sportChoosenVC, animated: true)
            }
        }
    }
    
    internal func onPressedAllSelectedNavBarButton () {
        if (self.mtous == true){
            self.mtous = false
        } else {
            self.mtous = true
        }
        self.mSelected_sports.removeAll()
        self.mTableView.reloadData()
    }
    
    /* Les méthdoes internes */
    internal func initialize_navBar () -> Void {
        self.navigationItem.hidesBackButton = true
        let next = UIBarButtonItem(title: "Terminer", style: .done, target: self, action: #selector(onPressedFinishedRegisterNavBarButton))
        let select_all = UIBarButtonItem(title: "Tous", style: .done, target: self, action: #selector(onPressedAllSelectedNavBarButton))
        self.navigationItem.setLeftBarButton(select_all, animated: true)
        self.navigationItem.setRightBarButton(next, animated: true)
    }
    
    //Return true si l'index est dans array, et false sinon.
    internal func isInArray (indexPath:IndexPath, array:[IndexPath]) -> Bool {
        var isInTab = false
        for index in array {
            if (indexPath == index) {
                isInTab = true
            }
        }
        return isInTab
    }
    
    //Retourne un tableau contenant l'ensemble des sports sélectionées à partir du tbaleau des indexpaths des sports selectionnés
    internal func get_string_sports_selected (sport_selected_indexPath: [IndexPath]) -> [String] {
        var sports_selected = [String]()
        for anIndexPath in sport_selected_indexPath {
            sports_selected.append(self.m_all_sports[anIndexPath.row])
        }
        return sports_selected
    }
    
    internal func display_alert_with_one_action (title:String?, message:String?, titleAction:String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: titleAction, style: .default, handler: nil)
        alertVC.addAction(done)
        self.present(alertVC, animated: true, completion: nil)
    }

}
