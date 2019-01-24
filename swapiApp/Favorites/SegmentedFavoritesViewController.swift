//
//  FavoritesViewController.swift
//  swapiApp
//

import UIKit

class SegmentedFavoritesViewController: UIViewController {

    @IBOutlet weak var favMoviesView:UIView!
    @IBOutlet weak var favCharsView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            favMoviesView.alpha = 0
            favCharsView.alpha = 1
        } else {
            favMoviesView.alpha = 1
            favCharsView.alpha = 0
        }
    }

}
