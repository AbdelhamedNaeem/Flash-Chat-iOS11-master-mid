//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        //TODO: Log in the user
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (usee, error) in
            
            SVProgressHUD.show()
            
            if error != nil{
                print(error!)
                  SVProgressHUD.dismiss()
            }else{
                print("running is successful :)")
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
                
                SVProgressHUD.dismiss()
            }
        
            
        }
        
        
    }
    


    
}  