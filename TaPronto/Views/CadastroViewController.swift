//
//  CadastroViewController.swift
//  TaPronto
//
//  Created by Luís Antônio de Oliveira Santos on 18/07/19.
//  Copyright © 2018 Luís Antônio de Oliveira Santos. All rights reserved.
//


import UIKit
import FirebaseAuth


class CadastroViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var senha: UITextField!
    
    @IBOutlet weak var senhaConfirmacao: UITextField!
    
    func exibirMensagem(titulo: String, mensagem: String){
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction( acaoCancelar )
        present(alerta, animated: true, completion: nil)
        
    }
    
    
    @IBAction func criarConta(_ sender: Any) {
        
        
        //Recuperar dados digitados
        if let emailR = self.email.text {
            if let senhaR = self.senha.text {
                if let senhaConfirmcaoR = self.senhaConfirmacao.text {
                    
                    //Validar senha
                    if senhaR == senhaConfirmcaoR {
                        
                        //Criar conta no Firebase
                        let autenticacao = Auth.auth()
                        autenticacao.createUser(withEmail: emailR, password: senhaR, completion: { (usuario, erro) in
                            
                            if erro == nil {
                                
                                if usuario == nil {
                                    self.exibirMensagem(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticação, tente novamente.")
                                }else{
                                    //redireciona usuario para tela principal
                                    self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                                }
                                
                            }else{
                                
                                /*
                                 ERROR_INVALID_EMAIL
                                 ERROR_WEAK_PASSWORD
                                 ERROR_EMAIL_ALREADY_IN_USE
                                 */
                                
                                let erroR = erro! as NSError
                                
                                if let codigoErro = erroR.userInfo["error_name"] {
                                    
                                    let erroTexto = codigoErro as! String
                                    var mensagemErro = ""
                                    
                                    switch erroTexto {
                                        
                                    case "ERROR_INVALID_EMAIL" :
                                        mensagemErro = "E-mail inválido, digite um e-mail válido!"
                                        break
                                    case "ERROR_WEAK_PASSWORD" :
                                        mensagemErro = "Senha precisa ter no mínimo 6 caracteres, com letras e números."
                                        break
                                    case "ERROR_EMAIL_ALREADY_IN_USE" :
                                        mensagemErro = "Esse e-mail já está sendo utilizado, crie sua conta com outro e-mail."
                                        break
                                    default:
                                        mensagemErro = "Dados digitados estão incorretos."
                                        
                                    }
                                    
                                    self.exibirMensagem(titulo: "Dados inválidos", mensagem: mensagemErro)
                                    
                                    
                                }
                                
                            }/*Fim validacao erro Firebase*/
                            
                        })
                        
                        
                    }else{
                        self.exibirMensagem(titulo: "Dados incorretos.", mensagem: "As senhas não estão iguais, digite novamente.")
                    }/*Fim validacao senha*/
                    
                }
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // Método para ocultar o teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

