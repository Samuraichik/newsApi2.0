//
//  ArticlesTableViewCell.swift
//  newsApiPecode
//
//  Created by oleksiy humenyuk on 08.08.2023.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell, Reusable {
    
    public var favouriteButtonAction: (() -> Void)?

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        self.selectionStyle = .none
        cellImage.contentMode = .scaleAspectFill
        favoriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc private func favouriteButtonPressed() {
        favouriteButtonAction?()
    }
}
