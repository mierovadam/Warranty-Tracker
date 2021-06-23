import UIKit
import FirebaseAuth
import Firebase
import Toast_Swift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var utils:Utils!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
    }
    
    func setUI() {
        utils = Utils()
        utils.setTextFieldSideIcon(image: UIImage(named: "email_logo")!, textField: emailTextField)
        utils.setTextFieldSideIcon(image: UIImage(named: "password_logo")!, textField: passwordTextField)
        utils.setTextFieldSideIcon(image: UIImage(named: "password_logo")!, textField: repeatPasswordTextField)
        
        utils.roundButtonCorneres(button: signupButton)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        if emailTextField.text?.isEmpty == true {
            self.view.makeToast("Email field must be filled!")
            utils.shakeView(viewToShake: emailTextField)
            return
        } else if passwordTextField.text?.isEmpty == true {
            self.view.makeToast("Password field must be filled!")
            utils.shakeView(viewToShake: passwordTextField)
            return
        } else if repeatPasswordTextField.text?.isEmpty == true {
            self.view.makeToast("Password field must be filled!")
            utils.shakeView(viewToShake: repeatPasswordTextField)
            return
        } else if repeatPasswordTextField.text != passwordTextField.text {
            self.view.makeToast("Password are not matching!")
            utils.shakeView(viewToShake: repeatPasswordTextField)
            utils.shakeView(viewToShake: passwordTextField)
            return
        }
        signUp()
    }
    
    @IBAction func alreadyHaveAnAccountLoginButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (authResult,error) in guard let _ = authResult?.user, error == nil else {
                print("Error \(String(describing: error?.localizedDescription))")
                self.view.makeToast(String(describing: error?.localizedDescription))

                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "mainStoryboardID")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc,animated: true)
        }
        
    }
}
