import UIKit
import Firebase
import FirebaseStorage

class mainListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //initialize Ref
    var ref:DatabaseReference!
    var userID:String!
    
    var allCells = [productCell]()
        
    //OBJECTS
    var utils:Utils!
    var allProducts:AllProducts!

    //VARIABLES
    var firstReadFlag = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reload data after adding new item
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child(userID)
        
        readAllProductsDatabast()
        setUI()
    }
    
    //Called when adding new product finished
    @objc func loadList(notification: NSNotification){
        allCells = [productCell]()
        allProducts = nil
        firstReadFlag = 0
        
        readAllProductsDatabast()
    }
    
    func setUI() {
        utils = Utils()
        utils.roundedButton(button: addItemButton)
        
        //adds space at botom to allow a bit more scroll
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.contentInset = insets
    }
    
    //ON CELL SELECTED
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ProductViewControllerID") as! ProductViewController
        viewController.product = allProducts.products[indexPath.row]
        viewController.image = allCells[indexPath.row].cellImageView.image!
        
        self.present(viewController,animated:true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //DEFINE TABLEVIEW LENGTH
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allProducts == nil {
            return 0
        } else {
            return allProducts.products.count
        }
    }
    
    //INITIALIZE TABLEVIEW CELLS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! productCell
        
        if allProducts != nil {
            cell.productNameCell.text = allProducts.products[indexPath.row].name
            cell.storeNameCell.text = allProducts.products[indexPath.row].storeName
            cell.daysLeftCell.text = String(allProducts.products[indexPath.row].warrantyDaysLeft)
            
            allCells.append(cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                if allCells.count != 0{
                    var i = 0
                    for cell in allCells{
                        if cell.cellImageView.image == UIImage(systemName: "photo") {   //if image hasnt been loaded yet
                            loadPhoto(cell: cell,index: i)
                        }
                        i+=1
                    }
                }
            }
        }
    }
    
    
    func readAllProductsDatabast(){
        ref.child("products").observeSingleEvent(of: .value, with: { (snapshot) in
            //let value = snapshot.value as? NSDictionary
            self.allProducts = AllProducts(snapshot: snapshot)
            
            if self.firstReadFlag == 0{
                self.tableView.delegate = self
                self.tableView.dataSource = self
                DispatchQueue.main.async(execute: { () -> Void in self.tableView.reloadData()})
                self.firstReadFlag = 1
            } else {
                DispatchQueue.main.async(execute: { () -> Void in self.tableView.reloadData()})
                //self.tableView.reloadData()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func loadPhoto(cell:productCell, index:Int) {
        if allProducts.products.count == 0 {
            return
        }
        
        let photoIdentifier = allProducts.products[index].name + allProducts.products[index].storeName
        let storageRef = Storage.storage().reference().child(userID).child(photoIdentifier)
            
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
            print(error)
            } else {
            cell.cellImageView.image = UIImage(data: data!)!
            }
        }
    }
    
    //SLIDE CELL TO DELETE RELATED FUNCTIONS
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteImageFromStorage(product:allProducts.products[indexPath.row])
            allProducts.products.remove(at: indexPath.row)
            allCells.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            //tableView.reloadData()
            ref.setValue(["products": self.allProducts.toDictionary()])
                        
            
            //firstReadFlag = 0
            readAllProductsDatabast()
        }
    }
    
    func deleteImageFromStorage(product:Product) {
        let photoIdentifier = product.name + product.storeName
        let storageRef = Storage.storage().reference().child(userID).child(photoIdentifier)
        
        //Removes image from storage
        storageRef.delete { error in
            if let error = error {
                print(error)
            } else {
                // File deleted successfully
            }
        }
    }
}

class productCell: UITableViewCell {
    @IBOutlet weak var productNameCell: UILabel!
    @IBOutlet weak var storeNameCell: UILabel!
    @IBOutlet weak var daysLeftCell: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
}
