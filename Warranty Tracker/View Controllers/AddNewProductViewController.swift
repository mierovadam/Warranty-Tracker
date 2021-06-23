import UIKit
import VisionKit
import Firebase
import FirebaseDatabase

class AddNewProductViewController: UIViewController {
    @IBOutlet weak var addNewItemButton: UIButton!
    @IBOutlet weak var productNameTF: UITextField!
    @IBOutlet weak var storeNameTF: UITextField!
    @IBOutlet weak var warrantyMonthsTF: UITextField!
    @IBOutlet weak var serialNumber: UITextField!
    @IBOutlet weak var purchaseDatePicker: UIDatePicker!
    
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var scanReceiptButton: UIButton!
    @IBOutlet weak var scannerReceiptImageView: UIImageView!
    
    var userID:String!
    
    var utils: Utils!
    var receiptImage: UIImage?
    var newProduct: Product!
    var allProducts: AllProducts!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        setUI()
        userID = Auth.auth().currentUser?.uid

    }
        
    func setUI() {
        utils = Utils()
        utils.roundButtonCorneres(button: addNewItemButton)
    }

    @IBAction func scanReceipt(_ sender: Any) {
        let scanningDocumentVC = VNDocumentCameraViewController()
        scanningDocumentVC.delegate = self
        self.present(scanningDocumentVC, animated: true, completion: nil)
    }

    @IBAction func saveNewItem(_ sender: Any) {
        if !readTextFields() || receiptImage == nil {
            return
        }
            
        updateAllProductsDatabase()
        saveImage()
        
    }
    
    func saveImage(){
        var data = NSData()
        data = receiptImage!.jpegData(compressionQuality: 0.005)! as NSData
        
        // set upload path
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let imageIdentifier = newProduct.name+newProduct.storeName
        
        Storage.storage().reference().child(userID).child(imageIdentifier).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            self.dismiss(animated: true, completion: nil)

        }

    }
    
    
    
    func updateAllProductsDatabase(){
        //initialize Ref
        let ref = Database.database().reference().child(userID)
        
        ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
            //let value = snapshot.value as? NSDictionary

            self.allProducts = AllProducts(snapshot: snapshot)
            
            //self.allProducts.products.removeAll()

            //update
            self.allProducts.products.append(self.newProduct)
            ref.setValue(["products": self.allProducts.toDictionary()])
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

        func readTextFields() -> Bool {
            if productNameTF.text == "" {
                utils.shakeView(viewToShake: productNameTF)
                self.view.makeToast("You must enter a product name.")
                return false
            } else if storeNameTF.text == "" {
                utils.shakeView(viewToShake: storeNameTF)
                self.view.makeToast("You must enter a store name.")
                return false
            } else if warrantyMonthsTF.text == "" {
                utils.shakeView(viewToShake: warrantyMonthsTF)
                self.view.makeToast("You must enter a store name.")
                return false
            }
            else if receiptImage == nil {
                utils.shakeView(viewToShake: receiptImageView)
                self.view.makeToast("You must scan a receipt!")
                return false
            }

            //If everything nessecery filled, initialize product object
            newProduct = Product(name: productNameTF.text!
                                 , storeName: storeNameTF.text!
                                 , monthsOfWarranty: Int(warrantyMonthsTF.text!) ?? 0
                                 , serialNumber: serialNumber.text!
                                 , purchaseDate: purchaseDatePicker.date)
            
            return true
        }
        
}

extension AddNewProductViewController:VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller:VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        receiptImage = scan.imageOfPage(at: 0)
        scannerReceiptImageView.image = receiptImage
        controller.dismiss(animated: true, completion: nil)
    }
}
