//
//  GameEventTableViewCell.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/9/24.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit
import Kingfisher

class GameEventTableViewCell: UITableViewCell, TableViewCellProtocol {
    
    @IBOutlet weak var ivEvent: UIImageView!
    
    @IBOutlet weak var labTitles: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupInfo(with event: EventData) {
        ivEvent.kf.setImage(with: URL(string: event.url))
        labTitles.text = "\(event.date) - \(event.title)"
    }
}
