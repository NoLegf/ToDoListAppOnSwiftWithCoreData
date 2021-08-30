//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Олег Дементьев on 10.08.2021.
//

import UIKit

class TaskRowTableViewCell: UITableViewCell {

    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var timeDate: UILabel!
    @IBOutlet weak var star: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
