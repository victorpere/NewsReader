//
//  NewsItemCell.swift
//  NewsReader
//
//  Created by Victor on 2017-03-22.
//  Copyright © 2017 Victorius Software Inc. All rights reserved.
//

import UIKit

class NewsItemCell: UITableViewCell
{
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var visitedLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
}
