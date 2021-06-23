import Foundation
import Firebase
import FirebaseDatabase


class AllProducts: Codable {
    var products: [Product] = []
    
    init() {}
    
    init(snapshot: DataSnapshot) {
        if !snapshot.exists() {
            return
        }
        let snapshotValue = snapshot.value as! [String: Any]
        let productsDictionary = snapshotValue["products"] as! [Dictionary<String, Any>]

        for arD in productsDictionary {
            products.append(Product(dict: arD))
        }
    }
    
    
    // All products to dictionary
    func toDictionary() -> Dictionary<String, Any> {
        var productsDictionary = [Dictionary<String, Any>]()
        
        for ar in products {
            productsDictionary.append(ar.toDictionary())
        }
        
        return [
            "products": productsDictionary,
        ]
    }
}

class Product: Codable {
    var name:String = ""
    var storeName:String = ""
    var monthsOfWarranty:Int = 0
    var serialNumber:String = ""
    var purchaseDate:Date = Date()
    var warrantyDaysLeft:Int = 0
    
    init() {}
    
    init(name:String, storeName:String, monthsOfWarranty:Int, serialNumber:String, purchaseDate:Date) {
        self.name = name
        self.storeName = storeName
        self.monthsOfWarranty = monthsOfWarranty
        self.serialNumber = serialNumber
        self.purchaseDate = purchaseDate

        let endOfWarrantyDate = addMonthsToDate(daysToAdd: monthsOfWarranty, dateToAdd: purchaseDate)
        warrantyDaysLeft = numberOfDaysBetween(firstDate: Date(), secondDate: endOfWarrantyDate)
    }
    
    init(dict: Dictionary<String, Any>) {
        guard let _name = dict["name"] as? String,
              let _storeName = dict["storeName"] as? String,
              let _monthsOfWarranty = dict["monthsOfWarranty"] as? Int,
              let _serialNumber = dict["serialNumber"] as? String,
              let _purchaseDate = (dict["purchaseDate"] as? Int)
        else {
            print("Something is not well")
            return
        }
        
        name = _name
        storeName = _storeName
        monthsOfWarranty = _monthsOfWarranty
        serialNumber = _serialNumber
        purchaseDate = intToDate(interval: _purchaseDate)
        
        let endOfWarrantyDate = addMonthsToDate(daysToAdd: monthsOfWarranty, dateToAdd: purchaseDate)
        warrantyDaysLeft = numberOfDaysBetween(firstDate: Date(), secondDate: endOfWarrantyDate)
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        name = snapshotValue["title"] as! String
        storeName = snapshotValue["content"] as! String
        monthsOfWarranty = snapshotValue["image"] as! Int
        serialNumber = snapshotValue["date"] as! String
        purchaseDate = intToDate(interval: (snapshotValue["purchaseDate"] as? Int)!)
        warrantyDaysLeft = snapshotValue["warrantyDaysLeft"] as! Int
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        return [
            "name": name,
            "storeName": storeName,
            "monthsOfWarranty": monthsOfWarranty,
            "serialNumber": serialNumber,
            "purchaseDate": dateToInt(someDate: purchaseDate),
            "warrantyDaysLeft": warrantyDaysLeft,
        ]
    }
    
    
    
    func numberOfDaysBetween(firstDate: Date, secondDate: Date) -> Int {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: firstDate, to: secondDate)
        return components.day!
    }
    
    func addMonthsToDate(daysToAdd:Int, dateToAdd:Date) -> Date {
        var dateComponent = DateComponents()
        dateComponent.month = daysToAdd
        return Calendar.current.date(byAdding: dateComponent, to: dateToAdd)!
    }
    
    func dateToInt(someDate:Date) -> Int {
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970

        // convert to Integer
        return Int(timeInterval)
    }
    
    func intToDate(interval:Int) -> Date {
        // convert Int to TimeInterval (typealias for Double)
        let timeInterval = TimeInterval(interval)

        // create NSDate from Double (NSTimeInterval)
        return Date(timeIntervalSince1970: timeInterval)
    }
}

