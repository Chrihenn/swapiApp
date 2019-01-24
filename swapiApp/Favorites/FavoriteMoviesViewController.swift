//
//  FavoriteMoviesViewController.swift
//  swapiApp
//
//  KILDER:
//  - https://cocoacasts.com/populate-a-table-view-with-nsfetchedresultscontroller-and-swift-3
//  - https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html
//

import UIKit
import CoreData

class FavoriteMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try frcMovies.performFetch()
            print(frcMovies.sections?[0].numberOfObjects ?? "error, failed to get the number of objects")
        }
        catch {
            print(error.localizedDescription)
            fatalError()
        }
        
        tableView.reloadData()
    }
    
    // MARK: - FetchedResultsController
    lazy var frcMovies: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavMovies")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // Sorting the favorite movies
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        print("Fetched fav movies!")
        return frc
    }()
    
    // MARK: - tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // grouped vertical sections of the tableview
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = frcMovies.sections?[0].numberOfObjects {
            print("number of rows in movies section \(count)")
            return count
        } else {
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavMovieCell", for: indexPath) as! FavoriteMovieTableViewCell
        let movie = frcMovies.object(at: indexPath) as! FavMovies

        cell.favMovieNameLabel.text = movie.title
        //cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = frcMovies.object(at: indexPath) as! FavMovies
        let newViewController = storyboard!.instantiateViewController(withIdentifier: "InspectMovieVC") as! InspectMovieViewController
        
        var movieToInspect: MoviesResult?
        
        let movieController = self.tabBarController?.viewControllers![0] as! MoviesViewController
        
        for m in movieController.moviesResult {
            if (selectedMovie.title == m.title) {
                // Found movie
                movieToInspect = m
            }
        }
        
        newViewController.inspectResult = movieToInspect
        newViewController.navigationItem.title = "Info"
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}

