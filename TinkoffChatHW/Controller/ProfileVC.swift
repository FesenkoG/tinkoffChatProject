//
//  ViewController.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.02.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: TopAllignmentLabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var changeUserImgBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // В методе init не получится распечатать frame кнопки, т.к. кнопки попросту не существует на момент вызова метода init. Вместо кнопки nil. Кнопка появляется только в методе loadView(), в котором она инициализируется из .storyboard, а метод  loadView() вызывается после init.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        imagePicker.delegate = self
        print(editBtn.frame)
        
        if let profileImgDate = UserDefaults.standard.object(forKey: "profileImg") as? Data {
            if let image = UIImage(data: profileImgDate) {
                self.userImg.image = image
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Frame отличается, потому что в ViewDidLoad отображаются размеры кнопки, рассчитанные для девайса, выбранного в .storyboard, а в ViewDidAppear уже для девайса, на котором запущенно приложение. В методе viewDidAppear кнопка инициализируется уже не из .storuboard, а из запущенного приложения.
        print(editBtn.frame)
    }
    
    @IBAction func editBtnWasPressed(_ sender: Any) {
        
    }
    @IBAction func changeUserImgBtnWasPressed(_ sender: Any) {
        let changeUserImage = UIAlertController(title: "Выбрать фотографию", message: "Как бы вы хотели выбрать фотографию для своего профиля?", preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: "Взять из галереи", style: .default) { (buttonTapped) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let photoAction = UIAlertAction(title: "Сделать фото", style: .default) { (buttonTapped) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraCaptureMode = .photo
            self.imagePicker.modalPresentationStyle = .fullScreen
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        changeUserImage.addAction(galleryAction)
        changeUserImage.addAction(photoAction)
        present(changeUserImage, animated: true, completion: nil)
        
    }
    
    func configureView() {
        let radius = changeUserImgBtn.layer.frame.height / 2
        
        changeUserImgBtn.layer.cornerRadius = radius
        changeUserImgBtn.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.4705882353, blue: 0.9411764706, alpha: 1)
        changeUserImgBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
        userImg.layer.cornerRadius = radius
        editBtn.layer.cornerRadius = 15.0
        editBtn.layer.borderWidth = 2.5
        editBtn.layer.borderColor = UIColor.black.cgColor
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        let imgData = UIImageJPEGRepresentation(image, 1.0)
        UserDefaults.standard.set(imgData, forKey: "profileImg")
        userImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

