//
//  RecommendationsControl.swift
//  swapiApp
//
//  KILDER:
//  - https://medium.com/@brianclouser/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960
//  - https://pixabay.com/en/millenium-falcon-falcon-star-wars-1627322/
//

import UIKit

class RecommendationsControl: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recTitle: UILabel!
    @IBOutlet weak var filmTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("RecommendationsCustomView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
