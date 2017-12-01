//
//  ViewController.swift
//  EsSaveData
//
//  Created by Andrea Ceroli on 27/11/17.
//  Copyright © 2017 Aesys. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var btnSalva: UIButton!
    @IBOutlet weak var txtDesc: UITextView!
    
    let errColor = UIColor.red
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNome" {
            let openView = segue.destination as! ListViewController
            openView.nome = txtNome.text!
            openView.desc = txtDesc.text!
            if(openView.nome=="")
            {
                let alert = UIAlertController(title: "Errore", message: "Inserire nome Oggetto.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .`default`))
                self.present(alert, animated: true, completion: nil)
                txtNome.layer.borderColor = errColor.cgColor
                txtNome.layer.borderWidth = 2.0
            }
            else{
                openView.save(value: openView.nome, desc: openView.desc)
            }
        }
    }
}

