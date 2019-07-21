//
//  ViewController.swift
//  TaPronto
//
//  Created by Luís Antônio de Oliveira Santos on 20/07/19.
//  Copyright © 2019 Luís Antônio de Oliveira Santos. All rights reserved.
//

import UIKit
import FirebaseAuth
//import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autenticacao = Auth.auth()
          
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            
            if let usuarioLogado = usuario {
                self.performSegue(withIdentifier: "loginAutomaticoSegue", sender: nil)
            }
            
        }
        
        
    }
    
    @IBOutlet weak var simbolo_taPronto: UIImageView!
    
    //Ocultar barra de navegação
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        simbolo_taPronto.layer.cornerRadius = 50
        simbolo_taPronto.clipsToBounds = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



