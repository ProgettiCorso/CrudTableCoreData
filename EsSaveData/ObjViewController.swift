//
//  ObjViewController.swift
//  EsSaveData
//
//  Created by Andrea Ceroli on 29/11/17.
//  Copyright © 2017 Aesys. All rights reserved.
//

import UIKit
import CoreData

class ObjViewController: UIViewController {
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblDesc: UITextView!
    
        var indice:Int!
        var oggetto: NSManagedObject? = nil
    
    override func viewDidLoad() {

        lblNome.text = oggetto?.value(forKeyPath: "nome") as? String
        lblDesc.text = oggetto?.value(forKeyPath: "desc") as? String
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
