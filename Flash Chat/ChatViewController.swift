//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework


class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self

        
        
        //TODO: Set the tapGesture here:  when tap outside textField the height of it become 50 with animation
        
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(tableViewTapped))
        messageTableView.isUserInteractionEnabled = true
        messageTableView.addGestureRecognizer(tapGesture)

        
        //TODO: Register your MessageCell.xib file here:
      
        messageTableView.register(UINib(nibName : "MessageCell",bundle : nil), forCellReuseIdentifier: "customMessageCell")
        
        retrieveMessages()
        
        messageTableView.separatorStyle = .none

        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named : "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String!{
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }else{
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
 
    
    //TODO: Declare numberOfRowsInSection here:
    
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:  custom configure
    
   
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        
        messageTableView.rowHeight = UITableViewAutomaticDimension //read dimensions from constraint
        messageTableView.estimatedRowHeight = 120.0
        
        return messageTableView.rowHeight
        }
        
    
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()         //update the view in screen
        }
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
       
        messageTextfield.endEditing(true)
        //TODO: Send the message to Firebase and save it in our database
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messageDB = Database.database().reference().child("messeges")
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email , "messageBody" : messageTextfield.text!]
        
        messageDB.childByAutoId().setValue(messageDictionary){
            (error , reference) in
            
            if error != nil {
                print(error!)
            }else{
                print("message saveded successfully!")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
            }
        }
        
    }
    
    
    //TODO: Create the retrieveMessages method here:   retrive from firebase
    
    func retrieveMessages(){
        let messageDB = Database.database().reference().child("messeges")
        
        messageDB.observe(.childAdded) { (snapShot) in
            let snapShotValue = snapShot.value as! Dictionary<String,String>
            
            let text = snapShotValue["messageBody"]!
            let sender = snapShotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            
            self.messageTableView.reloadData()
            
            print(text,sender)
        }
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        }
        catch{
            print("there is problem may be internet connection")
        }
    }
    


}
