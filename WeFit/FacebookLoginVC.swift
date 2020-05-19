// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift

import UIKit
import Firebase
import FirebaseStorage
import FBSDKLoginKit

// Add this to the body
class FacebookLoginVC: UIViewController, LoginButtonDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        view.addSubview(loginButton)

        loginButton.delegate = self
        loginButton.permissions = ["email", "public_profile"]

    }

//    override func viewDidAppear(_ animated: Bool) {
//        if (AccessToken.isCurrentAccessTokenActive)
//        {
//            performSegue(withIdentifier: "goHome", sender: self)
//        }
//    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged out")
    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error ?? "")
            return
        }
        facebookSignIn()
    }
    
    func uploadImage(image: UIImage, uid: String) -> String {
        var meta_pp_url: String = ""
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return meta_pp_url
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://wefit-ios.appspot.com")
        let storageProfileRef = storageRef.child("profile").child(uid)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata, completion: {(storageMetaData, error) in
            if error != nil {
                print("Error: \(String(describing: error))")
                return
            }
            
            storageProfileRef.downloadURL(completion: {(url, error) in
                if let metaImageURL = url?.absoluteString {
                    meta_pp_url = metaImageURL
                    // Firestore.firestore().collection("users").document(uid).updateData(["profile_picture": metaImageURL])
                }
            })
        })
        return meta_pp_url
    }


    // This logins with facebook and passes the credential to firebase
    func facebookSignIn() {
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: {(user, error) in
            if error != nil {
                print("Something went wrong with our FB User: ", error ?? "")
                return
            }
            print("Successfully logged in with our user: ", user ?? "")
        })
        
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture"]).start {
            (connection, result, err) in

            if err != nil {
                print("Failed to start graph request", err ?? "")
                return
            }
            
            guard let json = result as? Dictionary<String, Any> else {return}
            print(json)
            // Check for user in system after 5 seconds to allow for previous
            // tasks to run
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.checkUserExist(json: json)
            }
        }

        // After successful login, sets new root controller at homepage
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let homePage = storyBoard.instantiateViewController(withIdentifier: "MainTabController") as! UITabBarController
            UIApplication.shared.windows.first?.rootViewController = homePage
        }
    }

    // TODO: TEST new user joining
    // Creates a user document in "users" collection in Firestore if it doesn't exist
    func checkUserExist(json: Dictionary<String, Any>) -> Void {
        let uid = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()

        let docRef = db.collection("users").document(uid)
        docRef.getDocument(completion: {(document, error) in
            if document!.exists {
                print("Document exists!")
            }
            else {
                // Add a new document with a generated ID
                print("Document doesn't exist!")
                var meta_pp_url: String = ""
                let email = json["email"] as! String
                let name = json["name"] as! String
                let profilePicture: Dictionary<String, Any> = json["picture"] as! Dictionary<String, Any>
                let data: Dictionary<String, Any>  = profilePicture["data"] as! Dictionary<String, Any>
                let url: String = data["url"] as! String
                if let pp_url = URL(string: url) {
                    do {
                        let pp_data = try Data(contentsOf: pp_url)
                        meta_pp_url = self.uploadImage(image: UIImage(data: pp_data)!, uid: uid)
                    } catch {
                        print ("error")
                    }
                }
                var name_components = name.components(separatedBy: " ")
                // Conditional for first and last name
                if name_components.count > 0 {
                    let firstName = name_components.removeFirst()
                    let lastName = name_components.joined(separator: " ")
                    db.collection("users").document(uid).setData([
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "profile_picture": meta_pp_url
                    ])
                }
                else {
                    db.collection("users").document(uid).setData([
                        "firstName": name,
                        "profile_picture": meta_pp_url,
                        "email": email
                    ])
                }
            }
        })
    }
}
