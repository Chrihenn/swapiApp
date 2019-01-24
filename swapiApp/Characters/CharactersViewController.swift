//
//  CharactersViewController.swift
//  swapiApp
//
//  Sources:
//  - Forelesing 10
//  - https://stackoverflow.com/questions/28325277/how-to-set-cell-spacing-and-uicollectionview-uicollectionviewflowlayout-size-r
//  - https://stackoverflow.com/questions/31109719/swift-how-to-check-coredata-exists
//  - https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext
//  - https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc


import UIKit
import CoreData

class CharactersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var peopleResult = [PeopleResult]()
    
    var URLString = "https://swapi.co/api/people/?page="
    var pageCounter = 1
    
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        fetchChars(loadFromString: URLString + String(pageCounter))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    // Fetching data from swapi.co/api/people.
    func fetchChars(loadFromString: String) {
        let task = URLSession.shared.dataTask(with: URL.init(string: loadFromString)!) { (data, response, error) in
            
            if let actualData = data {
                do {
                    let peopleResult = try JSONDecoder().decode(People.self, from: actualData)
                    
                    DispatchQueue.main.async {
                        
                        self.peopleResult.append(contentsOf: peopleResult.results)
                        self.collectionView.reloadData()
                    }
                    
                } catch let error {
                    print(error)
                }
                
            }
        }
        task.resume()
        pageCounter += 1
        print("Characters view controller did load")
        
        if pageCounter <= 3 {
            fetchChars(loadFromString: URLString + String(pageCounter))
        }
        
    }
    
    // Creating a object of the characters in Core Data.
    func createFavChar(indexPath: IndexPath) {
        let newFav = NSEntityDescription.insertNewObject(forEntityName: "FavChars", into: managedObjectContext)
        
        newFav.setValue(peopleResult[indexPath.row].name, forKey: "name")
        newFav.setValue(peopleResult[indexPath.row].films, forKey: "films")
        newFav.setValue(peopleResult[indexPath.row].url, forKey: "url")
        do {
            try managedObjectContext.save()
            print("Saved \(String(describing: peopleResult[indexPath.row].name))")
        } catch {
            fatalError()
        }
    }
    
    // Deleting a character from Core Data.
    func deleteFavChar(indexPath: IndexPath) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavChars")
        let predicate = NSPredicate(format: "name == %@", (peopleResult[indexPath.row].name)!)
        fetchRequest.predicate = predicate
        let context = getManagedObjectContext()
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [FavChars]
        
        for object in resultData {
            context.delete(object)
        }
        do {
            try context.save()
            print("Deleted and saved context!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

    // Checking if the character does exist in Core Data entity
    func charEntityExist(entity: String, name: String) -> Bool {
        print("check entity")
        print(entity)
        let context = getManagedObjectContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        
        var results: [NSManagedObject] = []
        
        print("Fetching")
        do {
            results = try context.fetch(fetchRequest)
            print(results.count)
            for result in results {
                let m = result as? FavChars
                
                let t = m?.name
                if t == name {
                    print("Found char name in core data")
                    return true
                }
                
                print(m?.name ?? "failed to fetch name from core data")
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
    
        return false
    }
    
    //MARK - collectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if charEntityExist(entity: "FavChars", name: peopleResult[indexPath.row].name!) {
            deleteFavChar(indexPath: indexPath)
        } else {
            createFavChar(indexPath: indexPath)
        }

        collectionView.reloadData()
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peopleResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CharactersCollectionViewCell

        if charEntityExist(entity: "FavChars", name: peopleResult[indexPath.row].name!) {
            cell.charImageView.backgroundColor = UIColor.gray
        } else {
            cell.charImageView.backgroundColor = UIColor.black
        }
        
        cell.charNameLabel.text = peopleResult[indexPath.row].name
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    // Retrieving context from delegate
    func getManagedObjectContext() -> NSManagedObjectContext{
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        return delegate!.persistentContainer.viewContext
    }
    
}

//MARK - extension
//arranging the cells in collectionView.
extension CharactersViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/3, height: collectionViewWidth/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

