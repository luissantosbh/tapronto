//
//  FotoViewController.swift
//  OpiniAqui
//
//  Created by Luís Antônio de Oliveira Santos on 14/05/2018.
//  Copyright © 2018 Luís Antônio de Oliveira Santos. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //MARK: Outlets
    @IBOutlet weak var fotoSelecionada: UIImageView!
    @IBOutlet weak var nomeSelecionado: UITextField!
    @IBOutlet weak var botaoEnviarFoto: UIButton!
    
    
    let autenticacao = Auth.auth()
    let imagePicker = UIImagePickerController()
    
    //MARK: Criando um identificador único para cada imagem
    var idImagem = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        botaoEnviarFoto.isEnabled = false
        botaoEnviarFoto.backgroundColor = UIColor.gray
  }


    //MARK: Método para recuperar a foto que foi selecionada
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        let fotoRecuperada = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        fotoSelecionada.image = fotoRecuperada
        
        //MARK: Habilitar botão "botaoEnviarFoto"
        self.botaoEnviarFoto.isEnabled = true
        self.botaoEnviarFoto.backgroundColor = UIColor(red: 0.290, green: 0.569, blue: 0.886, alpha: 1)
        
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func enviarFoto(_ sender: Any) {
        self.botaoEnviarFoto.isEnabled = false
        self.botaoEnviarFoto.setTitle("Carregando...", for: .normal)
        
        
        //MARK: O ".reference" vai apontar para a raíz do armazenamento no Firebase (nó inicial)
        let armazenamento = Storage.storage().reference()
        
        //criar uma pasta chamada "imagens"
        let imagens = armazenamento.child("imagens")
        
        
        //Recuperar a imagem selecionada
         if let imagemSelecionada = fotoSelecionada.image{
            
            if  let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.1){
             
                imagens.child("\(self.idImagem)").putData(imagemDados, metadata: nil, completion: {(metaDados, erro) in
                    
                    if erro == nil {
                        print("Sucesso ao fazer upload do Arquivo")
                        
                        //MARK: Recuperar URL da image
                       // print(metaDados?.downloadURL()?.absoluteString)
                        
                        self.botaoEnviarFoto.isEnabled = true
                        self.botaoEnviarFoto.setTitle("Enviar foto", for: .normal)
                    }else{
                        print("Erro ao tentar fazer upload do Arquivo")
                    }
                })
            }
            
        }
        
        
    }
    
    @IBAction func sair(_ sender: Any) {
        
        do {
            try autenticacao.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Erro ao deslogar usuario")
        }
    }
    
    @IBAction func selecionarFoto(_ sender: Any) {
        
        //fonte do imagePicker
        imagePicker.sourceType = .photoLibrary
 
        
        //exibir imagePicker para o usuário
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
 
    
    // Método para ocultar o teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
