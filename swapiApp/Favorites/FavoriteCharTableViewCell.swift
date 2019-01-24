//
//  FavoriteCharTableViewCell.swift
//  swapiApp
//

import UIKit

class FavoriteCharTableViewCell: UITableViewCell {

    
    //@IBOutlet weak var favCharNameLabel: UILabel!
    @IBOutlet weak var nameOfCharLabel: UILabel!
    @IBOutlet weak var episodeWithCharLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
