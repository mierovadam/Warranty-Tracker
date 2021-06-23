import UIKit
import FirebaseAuth
import Toast_Swift

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var utils:Utils!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //signOut()
        checkIfLoggedIn()
    }
        
    func setUI() {
        utils = Utils()
        utils.setTextFieldSideIcon(image: UIImage(named: "email_logo")!, textField: emailTextField)
        utils.setTextFieldSideIcon(image: UIImage(named: "password_logo")!, textField: passwordTextField)
        
        utils.roundButtonCorneres(button: signInButton)
    }
    
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    @IBAction func loginButton(_ sender: Any) {
        if emailTextField.text?.isEmpty == true {
            self.view.makeToast("Email field must be filled!")
            utils.shakeView(viewToShake: emailTextField)
            return
        } else if passwordTextField.text?.isEmpty == true {
            self.view.makeToast("Password field must be filled!")
            utils.shakeView(viewToShake: passwordTextField)
            return
        }
        login()
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        //open signUp view conroller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "signupStoryboardID")
        vc.modalPresentationStyle = .overFullScreen
        present(vc,animated: true)
    }
    
    
    func login(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            [weak self] authResult,err in guard self != nil else {return}
            if let err = err {
                print(err.localizedDescription)
                self?.view.makeToast("Details incorrect")
                return
            }
            self!.checkIfLoggedIn()
        }
    }
    
    func checkIfLoggedIn() {
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser?.uid ?? " no current user ")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "mainStoryboardID")
            vc.modalPresentationStyle = .overFullScreen
            present(vc,animated: true)
        }
    }
}

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

