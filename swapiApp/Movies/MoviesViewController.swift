//
//  MoviesViewController.swift
//  swapiApp

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var moviesResult = [MoviesResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        let task = URLSession.shared.dataTask(with: URL.init(string: "https://swapi.co/api/films/")!) { (data, response, error) in
            
            if let actualData = data {
                do {
                    let result = try JSONDecoder().decode(Movies.self, from: actualData)
                    
                    DispatchQueue.main.async {
                        self.moviesResult = result.results
                        self.tableView.reloadData()
                    }
                } catch let error {
                    print(error)
                }
            }
        }
        task.resume()
        print("Movies view controller did load")
    }
    
    //MARK - tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // grouped vertical sections of the tableview
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MoviesTableViewCell
            
        cell.movieName.text = moviesResult[indexPath.row].title
        //cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            
        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect: \(indexPath)")
        
        let newViewController = storyboard!.instantiateViewController(withIdentifier: "InspectMovieVC") as! InspectMovieViewController
        
        newViewController.inspectResult = moviesResult[indexPath.row]
        newViewController.navigationItem.title = "Details"
        self.navigationController?.pushViewController(newViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
