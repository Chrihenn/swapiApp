//
//  FavoriteMoviesViewController.swift
//  swapiApp
//
//  KILDER:
//  - https://cocoacasts.com/populate-a-table-view-with-nsfetchedresultscontroller-and-swift-3
//  - https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html
//  - https://pixabay.com/en/millenium-falcon-falcon-star-wars-1627322/
//

import UIKit
import CoreData

class FavoriteCharsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recommendationView: RecommendationsControl!

    private var currentfavChars = [FavChars]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try frcChars.performFetch()
            print(frcChars.sections?[0].numberOfObjects ?? "error, failed to get the number of objects")
        }
        catch {
            print(error.localizedDescription)
            fatalError()
        }
        
        tableView.reloadData()
        getRecommendation()
    }
    
    // MARK: - FetchedResultsController
    lazy var frcChars: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavChars")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)] // Sorting the favorite movies
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        print("Fetched fav chars!")
        return frc
    }()
    
    // MARK: - tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // grouped vertical sections of the tableview
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = frcChars.sections?[0].numberOfObjects {
            print("number of rows in movies section \(count)")
            return count
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCharCell", for: indexPath) as! FavoriteCharTableViewCell
        let char = frcChars.object(at: indexPath) as! FavChars
        let movieController = self.tabBarController?.viewControllers![0] as! MoviesViewController

        let elements = [char.films]
        var ids = [Int]()
        for d in elements {
            for m in movieController.moviesResult {
                if ((d?.contains(m.url as Any))! ) {
                    let id = m.episode_id
                    ids.append(id!)
                }
            }
        }
        
        print("id's for this character: ")
        print(ids)
        
        cell.nameOfCharLabel.text = char.name
        cell.episodeWithCharLabel.text = "Episodes: \(ids)"
        //cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    // DidSelectRowAt - Alert view and option to remove from favorites.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChar = frcChars.object(at: indexPath) as! FavChars
        let favCharName = selectedChar.name
        let movieController = self.tabBarController?.viewControllers![0] as! MoviesViewController

        let elements = [selectedChar.films]
        var ids = [Int]()
        for d in elements {
            for m in movieController.moviesResult {
                if ((d?.contains(m.url as Any))! ) {
                    let id = m.episode_id
                    ids.append(id!)
                }
            }
        }
        //debug messages
        print("id's for this character: ")
        print(ids)
 
        var movieTitles = [String]()
        var message = "\(favCharName ?? "[]") was seen in: "
        
        for m in movieController.moviesResult {
            for id in ids {
                if (id == m.episode_id) {
                    movieTitles.append(m.title!)
                    message.append("\(m.title!), ")
                }
            }
        }
        //debug messages
        print("Movietitles for this character: ")
        print(movieTitles)
        
        print("")
        print("")

        let alert = UIAlertController(title: favCharName, message: message,
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: UIAlertAction.Style.default, handler: { action in
            
            let objectToDelete = self.frcChars.object(at: indexPath) as! NSManagedObject
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            context.delete(objectToDelete)
            do {
                try context.save()
                try self.frcChars.performFetch()
                self.getRecommendation()
                print("Removed from core data")
            }
            catch {
                print("Could not save new favourite movie")
                fatalError()
            }
            
            tableView.reloadData()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getRecommendation() {
        
        let characters = frcChars.fetchedObjects as! [FavChars]
        let size = characters.count
        
        if (size < 1) {
            let image: UIImage = UIImage(named: "millFalcon")! // Bilde uten copyright
            recommendationView.imageView.image = image
            recommendationView.filmTitle.text = "Add favorites first"
            recommendationView.recTitle.text = "No recommendations!"
        }
        
        if (currentfavChars == frcChars.fetchedObjects as! [FavChars]) {
            return
        }
        
        currentfavChars = frcChars.fetchedObjects as! [FavChars]
        

        
        let recommendationArr = ["Leia & Chill", "Solo's Steal:", "Chewies favorite!!", "Vader's Breathtakers:", "R2D2 loves this!"]
        //var title : String = ""
        
        print("loop?")//debug
        let found = 0

        let movieController = self.tabBarController?.viewControllers![0] as! MoviesViewController
        
        for movie in movieController.moviesResult {
            print("----MOVIE LOOP-----")//debug
                        
            var newFound = 0
  
            for favs in frcChars.fetchedObjects! as! [FavChars] {
                
                if movie.characters!.contains(favs.url!) {
                    print(".....rec found...")//debug
                    newFound += 1
                } else {
                    print("not found")//debug
                }
            }
            
            if newFound > found {
                print("movietitle in recommendation changed")
                recommendationView.filmTitle.text = movie.title!
                recommendationView.recTitle.text = recommendationArr.randomElement()!
            }
        }
    }
    

}



