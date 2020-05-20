// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift

import UIKit
import Firebase
import FirebaseStorage
import FBSDKLoginKit

// Add this to the body
class FacebookLoginVC: UIViewController, LoginButtonDelegate {

    
    var myGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.center = self.view.center
        view.addSubview(loginButton)

        loginButton.delegate = self
        loginButton.permissions = ["email", "public_profile"]

    }


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
    
    func uploadImage(image: UIImage, uid: String) {
        self.myGroup.enter()
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        print("SETTING REFERENCE")
        let storageRef = Storage.storage().reference(forURL: "gs://wefit-ios.appspot.com")
        let child = uid + ".jpg"
        let storageProfileRef = storageRef.child("profile").child(child)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata, completion: {(storageMetaData, error) in
            print("PUTTING DATA")
            if error != nil {
                print("Error: \(String(describing: error))")
                return
            }
            self.myGroup.leave()
        })
    }


    // This logins with facebook and passes the credential to firebase
    func facebookSignIn() {
        self.myGroup.enter()
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
            // Check for user in system after 2 seconds to allow for previous
            // tasks to run
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.checkUserExist(json: json) {
                    let user = User.sharedGlobal
                    user.getFirebaseUser {
                        self.myGroup.leave()
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let homePage = storyBoard.instantiateViewController(withIdentifier: "MainTabController") as! UITabBarController
                        UIApplication.shared.windows.first?.rootViewController = homePage
                    }
                }
            }
        }

//        // After successful login, sets new root controller at homepage
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            let user = User.sharedGlobal
//            user.getFirebaseUser {
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let homePage = storyBoard.instantiateViewController(withIdentifier: "MainTabController") as! UITabBarController
//                UIApplication.shared.windows.first?.rootViewController = homePage
//            }
//        }
    }
    // Creates a user document in "users" collection in Firestore if it doesn't exist
    func checkUserExist(json: Dictionary<String, Any>, completion: @escaping () -> ()){
        let uid = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        self.myGroup.enter()
        let docRef = db.collection("users").document(uid)
        docRef.getDocument(completion: {(document, error) in
            if document!.exists {
                print("Document exists!")
            }
            else {
                // Add a new document with a generated ID
                print("Document doesn't exist!")
                let email = json["email"] as! String
                let name = json["name"] as! String
                var name_components = name.components(separatedBy: " ")
                // Conditional for first and last name
                if name_components.count > 0 {
                    let firstName = name_components.removeFirst()
                    let lastName = name_components.joined(separator: " ")
                    let profilePicture: Dictionary<String, Any> = json["picture"] as! Dictionary<String, Any>
                    let data: Dictionary<String, Any> = profilePicture["data"] as! Dictionary<String, Any>
                    let url: String = data["url"] as! String
                    if let pp_url = URL(string: url) {
                        do {
                            let pp_data = try Data(contentsOf: pp_url)
                            self.uploadImage(image: UIImage(data: pp_data)!, uid: uid)
                        } catch {
                            print("error")
                        }
                    }
                    
                    db.collection("users").document(uid).setData([
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email
                    ])
                }
                else {
                    db.collection("users").document(uid).setData([
                        "firstName": name,
                        "email": email
                    ])
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.myGroup.leave()
                completion()
            }
        })
    }
}
