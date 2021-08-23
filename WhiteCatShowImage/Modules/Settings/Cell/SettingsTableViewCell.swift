//
//  SettingsTableViewCell.swift
//  WhiteCatShowImage
//
//  Created by 楊鎮齊 on 2021/8/20.
//  Copyright © 2021 楊鎮齊. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell, TableViewCellProtocol {

    @IBOutlet weak var ivSettings: UIImageView!
    @IBOutlet weak var labSettings: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupInfo(with item: SettingItem) {
        ivSettings.image = item.image
        ivSettings.tintColor = item.imageColor
        labSettings.text = item.type.localized
    }
    
}
