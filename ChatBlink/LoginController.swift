//
//  LoginController.swift
//  ChatBlink
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UIImagePickerControllerDelegate {
    
/////// UI Elements
    //Container
    let inputsContanierView:UIView = {
        let view = UIView()
            view.backgroundColor = UIColor.white
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
        return view
    }()
    
    //Register button
    lazy var loginRegisterButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    //Textfields "Name" "Email" and "Pass"
    let nameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = UIReturnKeyType.done
        return tf
    }()
    
    let emailTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = UIReturnKeyType.done
        return tf
    }()
    
    let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = UIReturnKeyType.done
        tf.isSecureTextEntry = true
        return tf
    }()
    
    //Separators
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //image
    lazy var profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ChatLogonew")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    //Segment Control
    lazy var loginRegisterSegmentedControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
///////end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(r: CGFloat(61), g: CGFloat(91), b: CGFloat(151))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.dismissKeyboard))
        

        
        view.addSubview(inputsContanierView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addGestureRecognizer(tap)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        present(picker, animated: true, completion: nil)
    }
    
    func handleLoginRegisterChange(){
        //changing register button
        let title  = loginRegisterSegmentedControl.titleForSegment(at: (loginRegisterSegmentedControl.selectedSegmentIndex))
        loginRegisterButton.setTitle(title, for: .normal)
        
        //changing inputContainerView
        inputsConstrainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            nameTextField.placeholder = " "
            nameTextField.text = " "
        } else {
            
            nameTextField.placeholder = "Name"
        }
        
        //changing nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContanierView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //changing emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContanierView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //changing passwordTextField
        passwordTextFieldHeightAchor?.isActive = false
        passwordTextFieldHeightAchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContanierView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAchor?.isActive = true
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleRegister() {
        
        self.view.endEditing(true)
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("ffff")
        return
        }
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            //Sucsessful auth
            
            guard let uid = user?.uid else {
                return
            }
           
                let ref = FIRDatabase.database().reference(fromURL: "https://chatblink-aabcf.firebaseio.com/")
                let usersRef = ref.child("users").child(uid)
                let values = ["name": name, "email": email]
                usersRef.updateChildValues(values, withCompletionBlock: {(err, ref ) in
                    
                    if err != nil {
                        print(err!)
                        return
                    }
                
                    //sucsessful saving into database
                    print("Saved user sucsessfuly")
                })

            
            })
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("ffff")
            return
        }

        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {
            (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            //sucsessfully logged in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.centerYAnchor.constraint(equalTo: inputsContanierView.topAnchor, constant: -30).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContanierView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -24).isActive = true
        
       // profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }

    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContanierView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContanierView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    var inputsConstrainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        // Constrains of the container
        inputsContanierView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContanierView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContanierView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsConstrainerViewHeightAnchor = inputsContanierView.heightAnchor.constraint(equalToConstant: 150)
        inputsConstrainerViewHeightAnchor?.isActive = true
        ////
        
        inputsContanierView.addSubview(nameTextField)
        inputsContanierView.addSubview(nameSeparatorView)
        inputsContanierView.addSubview(emailTextField)
        inputsContanierView.addSubview(emailSeparatorView)
        inputsContanierView.addSubview(passwordTextField)
        


        
        //Constrains of the textField "Name"
        nameTextField.leftAnchor.constraint(equalTo: inputsContanierView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContanierView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContanierView.widthAnchor).isActive = true
        
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContanierView.heightAnchor, multiplier: 1/3)
            nameTextFieldHeightAnchor?.isActive = true
        ////
        //Constrains of the textField "Email"
        emailTextField.leftAnchor.constraint(equalTo: inputsContanierView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContanierView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContanierView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        ////
        //Constrains of the textField "Password"
        passwordTextField.leftAnchor.constraint(equalTo: inputsContanierView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContanierView.widthAnchor).isActive = true
        passwordTextFieldHeightAchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContanierView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAchor?.isActive = true
        ////

        //Constrains of the separator lines
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContanierView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContanierView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContanierView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContanierView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        ////
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
