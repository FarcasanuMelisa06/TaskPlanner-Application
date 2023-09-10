//
//  TaskCell.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 26.07.2023.
//

import Foundation
import UIKit

protocol TaskCellDelegate: AnyObject {
    func deleteButtonTapped(cell: TaskCell)
    func taskCompletedButtonTapped(cell: TaskCell)
}

class TaskCell: UITableViewCell{

    @IBOutlet weak var titleTask: UILabel!
    @IBOutlet weak var descriptionTask: UILabel!
    @IBOutlet weak var priorityTask: UILabel!

    @IBOutlet weak var taskCompleted: UIButton!
    
    @IBOutlet weak var dueDateTask: UILabel!
    weak var delegate: TaskCellDelegate?

       @IBAction func deleteButtonTapped(_ sender: UIButton) {
           delegate?.deleteButtonTapped(cell: self)
       }
    
    @IBAction func taskCompletedButtonTapped(_ sender: UIButton) {
        delegate?.taskCompletedButtonTapped(cell: self)
    }
    
    func configure(titleTask: String, descriptionTask: String, priorityTask: String, dueDateTask: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Alegeți formatul dorit pentru data

        self.titleTask.text = titleTask
        self.descriptionTask.text = descriptionTask
        self.priorityTask.text = priorityTask
        self.dueDateTask.text = dueDateTask
        
        //self.dueDataTask.text = dateFormatter.string(from: dueDataTask)
    
    }
    
}
