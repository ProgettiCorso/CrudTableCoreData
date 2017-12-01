//
//  ListViewController.swift
//  EsSaveData
//
//  Created by Andrea Ceroli on 27/11/17.
//  Copyright © 2017 Aesys. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var oggetto: [NSManagedObject] = []
    var selezione: [NSManagedObject] = []
    var rigaObj: NSManagedObject? = nil
    
    @IBOutlet weak var elimina: UIButton!
    var nome = ""
    var desc = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var aggiungi: UIButton!
    @IBOutlet weak var confElimina: UIButton!
    
    
    func confirmDelete() {
        let alert = UIAlertController(title: "Elimina Oggetti Selezionati", message: "Sei Sicuro di voler eliminare gli oggetti selezionati?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Elimina", style: .destructive, handler: handleDeleteProdotto)
        
        let CancelAction = UIAlertAction(title: "Annulla", style: .cancel, handler: cancelDeleteProdotto)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:1.0, y:1.0, width:self.view.bounds.size.width / 2.0, height:self.view.bounds.size.height / 2.0)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancelDeleteProdotto(alertAction: UIAlertAction!) {
        confElimina.isHidden=true
        aggiungi.isHidden=false
        tableView.setEditing(false, animated: true)
        elimina.setTitle("Elimina",for: .normal)
        
    }
    
    func handleDeleteProdotto(alertAction: UIAlertAction!) -> Void {
        for objInArray in selezione {
            context.delete(objInArray)
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        do {
            oggetto = try context.fetch(Oggetto.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
        tableView.reloadData()
        elimina.sendActions(for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    @IBAction func seleziona(_ sender: Any) {
        
        if (elimina.currentTitle! == "Elimina")
        {
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: true)
            elimina.setTitle("Annulla",for: .normal)
            
            confElimina.isHidden=false
            aggiungi.isHidden=true
        }
        else{
            if (elimina.currentTitle! == "Annulla")
            {
                confElimina.isHidden=true
                aggiungi.isHidden=false
                tableView.setEditing(false, animated: true)
                elimina.setTitle("Elimina",for: .normal)
            }
        }
    }
    
     @IBAction func elimina(_ sender: Any) {
              confirmDelete()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Oggetto")
        do {
            oggetto = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(value: String, desc: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Oggetto",
                                                in: managedContext)!
        let entita = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        entita.setValue(value, forKeyPath: "nome")
        entita.setValue(desc, forKeyPath: "desc")
        do {
            try managedContext.save()
            oggetto.append(entita)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oggetto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tab = oggetto[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        cell.backgroundColor = UIColor.darkGray
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 23)
        cell.textLabel?.text = tab.value(forKeyPath: "nome") as? String
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rigaObj = oggetto[indexPath.row]
        selezione.append(rigaObj!)
        if ( tableView.isEditing == false)
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let NewCaricaViewController = storyBoard.instantiateViewController(withIdentifier: "ObjViewController") as! ObjViewController
            NewCaricaViewController.indice=self.tableView.indexPathForSelectedRow?.row
            NewCaricaViewController.oggetto = self.rigaObj
            self.present(NewCaricaViewController, animated: true, completion: nil)
        }
    }
    
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let riga = oggetto[indexPath.row]
        if let index = selezione.index(of:riga) {
            selezione.remove(at: index)
        }
        
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        var deleteProdottoIndexPath: IndexPath? = nil
        func confirmDelete() {
            let alert = UIAlertController(title: "Elimina Oggetto", message: "Sei Sicuro di voler eliminare l'oggetto selezionato?", preferredStyle: .actionSheet)
            let DeleteAction = UIAlertAction(title: "Elimina", style: .destructive, handler: handleDeleteProdotto)
            let CancelAction = UIAlertAction(title: "Annulla", style: .cancel, handler: cancelDeleteProdotto)
            alert.addAction(DeleteAction)
            alert.addAction(CancelAction)
            // Support display in iPad
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x:1.0, y:1.0, width:self.view.bounds.size.width / 2.0, height:self.view.bounds.size.height / 2.0)
            self.present(alert, animated: true, completion: nil)
        }
        
        func cancelDeleteProdotto(alertAction: UIAlertAction!) {
            deleteProdottoIndexPath = nil
        }
        
        func handleDeleteProdotto(alertAction: UIAlertAction!) -> Void {
            let riga = oggetto[indexPath.row]
            context.delete(riga)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                oggetto = try context.fetch(Oggetto.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
            tableView.reloadData()
        }
        
        if editingStyle == .delete {
            confirmDelete()
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "segueOggetto" {
            let openView = segue.destination as! ObjViewController
            openView.indice = self.tableView.indexPathForSelectedRow?.row
            openView.oggetto = rigaObj
        }

    }
}
