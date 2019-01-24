//
//  InspectMovieViewController.swift
//  swapiApp
//
//  KIlDER:
//  - https://developer.apple.com/documentation/coredata/nsmanagedobjectcontext
//  - https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc

import UIKit
import CoreData

class InspectMovieViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var crawlTextView: UITextView!
    @IBOutlet weak var favButtonOutlet: UIButton!
    
    var inspectResult: MoviesResult?
    
    var managedObjectContext:NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        crawlTextView!.layer.borderWidth = 1
        crawlTextView!.layer.borderColor = UIColor.white.cgColor
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        crawlTextView.text = inspectResult?.opening_crawl
        
            if let title = inspectResult?.title {
                titleLabel.text = "Title: \(title)"
            }
        
            if let dir = inspectResult?.director {
                directorLabel.text = "Director: \(dir)"
            }
        
            if let prod = inspectResult?.producer {
                producerLabel.text = "Producer: \(prod)"
            }
        
            if let rd = inspectResult?.release_date {
                releaseDateLabel.text = "Release Date: \(rd)"
            }
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if movieEntityExists(entity: "FavMovies", title: (inspectResult?.title)!) {
            favButtonOutlet.setTitle("Remove favorite", for: .normal)
            print("Found item, button is 'remove'")
        } else {
            favButtonOutlet.setTitle("Add favorite", for: .normal)
            print("Found item, button is 'add'")
        }
    }
 
    
    @IBAction func makeFav(_ sender: Any) {
        if !movieEntityExists(entity: "FavMovies", title: (inspectResult?.title)!) {
            createFavMovie()
            print("Added to favorites")
        } else {
            deleteFavMovie()
            print("Removed from favorites")
        }
    }
    
    func createFavMovie() {
        let newFav = NSEntityDescription.insertNewObject(forEntityName: "FavMovies", into: managedObjectContext)
        
        newFav.setValue(inspectResult?.title, forKey: "title")
        newFav.setValue(inspectResult?.release_date, forKey: "release_date")
        newFav.setValue(inspectResult?.producer, forKey: "producer")
        newFav.setValue(inspectResult?.director, forKey: "director")
        newFav.setValue(inspectResult?.opening_crawl, forKey: "opening_crawl")
        do {
            try managedObjectContext.save()
            
            if movieEntityExists(entity: "FavMovies", title: (inspectResult?.title)!) {
                favButtonOutlet.setTitle("Remove favorite", for: .normal)
            }
            
            print("Saved \(String(describing: inspectResult?.title))")
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    func movieEntityExists(entity: String, title: String) -> Bool {
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
                let m = result as? FavMovies
                
                let t = m?.title
                if t == title {
                    print("Found movie title")
                    return true
                }
                
                print(m?.title ?? "failed to fetch title")
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return false
    }
  
    func deleteFavMovie() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMovies")
        let predicate = NSPredicate(format: "title == %@", (inspectResult?.title)!)
        fetchRequest.predicate = predicate
        let context = getManagedObjectContext()
        let result = try? context.fetch(fetchRequest)
        let resultData = result as! [FavMovies]
        
        for object in resultData {
            context.delete(object)
        }
        do {
            try context.save()
            
            if !movieEntityExists(entity: "FavMovies", title: (inspectResult?.title)!) {
                favButtonOutlet.setTitle("Add favorite", for: .normal)
            }
            
            print("saved and changed button title!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    func getManagedObjectContext() -> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as? AppDelegate
        return delegate!.persistentContainer.viewContext
    }
}
