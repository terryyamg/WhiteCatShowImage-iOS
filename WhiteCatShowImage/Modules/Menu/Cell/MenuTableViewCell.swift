//
//  MenuTableViewCell.swift
//  WhiteCatShowImage
//
//  Created by Terry Yang on 2021/4/24.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell, TableViewCellProtocol {

    @IBOutlet weak var labTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupInfo(with menuItem: String) {
        labTitle.text = menuItem
    }

}
