//
//  LocationListCellTableViewCell.swift
//  LocationBaseApp
//
//  Created by Pooja on 01/04/22.
//

import UIKit

class LocationListCellTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var placeName: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
