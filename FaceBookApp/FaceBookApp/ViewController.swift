//
//  ViewController.swift
//  FaceBookApp
//
//  Created by Louis Harris on 6/7/17.
//  Copyright © 2017 Louis Harris. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [.publicProfile, .email])
        loginButton.center = view.center
        
        
        
        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logEmailPressed(_ sender: UIButton) {
        
        //get logged in users email and print it to console with fbsdk
        if let accessToken = AccessToken.current{
            let graphRequest = GraphRequest.init(graphPath: "me", parameters:["fields":"email, name"], accessToken: accessToken, httpMethod: GraphRequestHTTPMethod.GET, apiVersion: GraphAPIVersion.defaultVersion)
            graphRequest.start({(response, result) in
            
                switch result{
                case .success(let graphResponse):
                var responseDictionary = graphResponse.dictionaryValue
                print("My Email is \(responseDictionary?["email"] as! String)")
                
                case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
                }
            })
        }
    }
    
    @IBAction func sharePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        else{
            return
        }
        
        let photo = Photo(image: chosenImage, userGenerated: true)
        let content = PhotoShareContent(photos: [photo])
        
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            
        }
        try! shareDialog.show()
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

