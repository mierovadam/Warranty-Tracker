import UIKit
import Firebase

class UserPropertiesViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func closeViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        try! Auth.auth().signOut()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "loginStoryboardID")
        vc.modalPresentationStyle = .overFullScreen
        present(vc,animated: true)
    }
    
}
