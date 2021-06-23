import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    
    
    @IBOutlet weak var receiptImage: UIImageView!
    
    var product = Product()
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptImage.image = image

        productName.text = product.name
        storeNameLabel.text = product.storeName
        daysLeftLabel.text = String(product.warrantyDaysLeft)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        purchaseDateLabel.text = formatter.string(from: product.purchaseDate)
        serialNumberLabel.text = product.serialNumber
        
    }

}
