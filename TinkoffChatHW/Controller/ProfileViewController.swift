//
//  ViewController.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.02.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    

    @IBOutlet var operationBtn: RoundedButton!
    @IBOutlet var gcdBtn: RoundedButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var saveBtnStack: UIStackView!
    @IBOutlet var userDescriptionTxtField: UITextView!
    @IBOutlet var usernameTxtField: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var changeUserImgBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    lazy var imagePicker = UIImagePickerController()
    var storageManager: StorageManager!
    
    private var currentUserName = ""
    private var currentUserDescription = ""
    private var currentUserImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        changeUserImgBtn.isHidden = true
        if let name = usernameTxtField.text, let descr = userDescriptionTxtField.text, let image = userImg.image {
            currentUserName = name
            currentUserDescription = descr
            currentUserImage = image
        }
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        self.spinner.isHidden = true
        storageManager.retrieveData { (result) in
            switch result {
            case .Success(let user):
                self.userImg.image = user.image
                self.usernameTxtField.text = user.name
                self.userDescriptionTxtField.text = user.descr
                
                self.currentUserName = user.name
                self.currentUserDescription = user.descr
                self.currentUserImage = user.image
            case .Failure(let message):
                print(message)
            }
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardHeight = keyboardFrame.height
        let newFrame = CGRect(x: 0, y: -keyboardHeight, width: self.view.frame.width, height: self.view.frame.height)
        UIView.animate(withDuration: animationDurarion) {
            self.view.frame = newFrame
        }
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        var userInfo = notification.userInfo!
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let newFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: animationDurarion) {
            self.view.frame = newFrame
        }
        
    }
    
    @IBAction func editBtnWasPressed(_ sender: Any) {
        enableInteraction()
    }
    
    @IBAction func saveBtnWasPressed(_ sender: RoundedButton) {
        
        if let name = usernameTxtField.text, let descr = userDescriptionTxtField.text, let image = userImg.image, (name != currentUserName || descr != currentUserDescription || image != currentUserImage) {
            spinner.isHidden = false
            spinner.startAnimating()
            //Выключить кнопки
            operationBtn.isEnabled = false
            gcdBtn.isEnabled = false
            changeUserImgBtn.isEnabled = false
            //
            let user = UserInApp(name: name, descr: descr, image: image)
            storageManager.saveData(user: user) { (success) in
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                //Включить кнопки
                self.operationBtn.isEnabled = true
                self.gcdBtn.isEnabled = true
                self.changeUserImgBtn.isEnabled = true

                if success {
                    self.dataHaveBeenSaved()
                    self.currentUserName = user.name
                    self.currentUserDescription = user.descr
                    self.currentUserImage = user.image
                } else {
                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: { (action) in
                        self.disableInteraction()
                    })
                    
                    let actionRepeat = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default, handler: { (action) in
                        self.spinner.isHidden = false
                        self.spinner.startAnimating()
                        self.storageManager.saveData(user: user, completionHandler: { (success) in
                            self.spinner.stopAnimating()
                            self.spinner.isHidden = true
                            if success {
                                self.dataHaveBeenSaved()
                            } else {
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    })
                    alert.addAction(actionOk)
                    alert.addAction(actionRepeat)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    @IBAction func changeUserImgBtnWasPressed(_ sender: Any) {
        imagePicker.delegate = self
        let changeUserImage = UIAlertController(title: "Выбрать фотографию", message: "Как бы вы хотели выбрать фотографию для своего профиля?", preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "Взять из галереи", style: .default) { (buttonTapped) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        }
        let photoAction = UIAlertAction(title: "Сделать фото", style: .default) { (buttonTapped) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        changeUserImage.addAction(galleryAction)
        changeUserImage.addAction(photoAction)
        present(changeUserImage, animated: true, completion: nil)
        
    }
    
    private func configureView() {
        let radius = changeUserImgBtn.layer.frame.height / 2
        
        changeUserImgBtn.layer.cornerRadius = radius
        changeUserImgBtn.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.4705882353, blue: 0.9411764706, alpha: 1)
        changeUserImgBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        userImg.layer.cornerRadius = radius
        
    }
    
    private func enableInteraction() {
        self.saveBtnStack.isHidden = false
        self.editBtn.isHidden = true
        self.usernameTxtField.isEnabled = true
        self.changeUserImgBtn.isHidden = false
        
        self.userDescriptionTxtField.isEditable = true
        self.userDescriptionTxtField.layer.borderWidth = 1.0
        self.userDescriptionTxtField.layer.borderColor = UIColor.black.cgColor
    }
    
    private func disableInteraction() {
        self.saveBtnStack.isHidden = true
        self.editBtn.isHidden = false
        self.usernameTxtField.isEnabled = false
        self.changeUserImgBtn.isHidden = true
        
        self.userDescriptionTxtField.isEditable = false
        self.userDescriptionTxtField.layer.borderWidth = 0.0
        self.userDescriptionTxtField.layer.borderColor = UIColor.white.cgColor
    }
    
    private func dataHaveBeenSaved() {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: { (action) in
            self.disableInteraction()
        })
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        userImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

