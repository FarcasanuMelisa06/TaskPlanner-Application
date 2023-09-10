//
//  TasksViewController.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 26.07.2023.
//

import Foundation
import UIKit
import UserNotifications
import CoreData


class TasksViewController: UIViewController, TaskCellDelegate{
    @IBOutlet weak var tableView: UITableView!
    var tasks: [TaskModel] = []
    
    var taskCompletionStatus: [Int: Bool] = [:]
    
    @IBAction func addNewTask(_ sender: Any) {
        
        performSegue(withIdentifier: "goToAddTaskSegue", sender: nil)
    }
    
    let cellHeight: CGFloat = 140.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
        tableView.delegate = self
        tableView.dataSource = self
        checkForPermission()
    }
    
    func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                if let taskToNotify = self.tasks.first {
                    self.dispatchNotification(for: taskToNotify)
                }
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) {
                    didAllow, error in
                    if didAllow, let taskToNotify = self.tasks.first {
                        self.dispatchNotification(for: taskToNotify)
                    }
                }
            default:
                return
            }
        }
    }

    
    func dispatchNotification(for task: TaskModel) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let identifier = "task-\(task.taskId)"
        let title = "Notification"
        let body = "The deadline for '\(task.title)' is today!"
        
        let calendar = Calendar.current
        let now = Date()

        // se converteste data limită a task-ului din șir într-un obiect Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let taskDueDate = dateFormatter.date(from: task.dueDate) {
            
            // se extrage ziua și luna din data curentă
            let currentComponents = calendar.dateComponents([.day, .month], from: now)
            
            // se extrage ziua și luna din data limită a task-ului
            let dueDateComponents = calendar.dateComponents([.day, .month], from: taskDueDate)
            
            // se compara dacă ziua și luna curentă coincid cu ziua și luna datei limită a task-ului
            if currentComponents.day == dueDateComponents.day && currentComponents.month == dueDateComponents.month {
                
                // Dacă coincide, se trimite notificarea
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default
                
                // setarea unui timer de notificare pentru a afișa notificarea imediat
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Eroare la adăugarea notificării: \(error)")
                    } else {
                        print("Notificarea a fost adăugată cu succes")
                    }
                }
            }
        }
    }



    func loadTasks() {
        taskCompletionStatus = Dictionary(uniqueKeysWithValues: tasks.map { ($0.taskId, false) })
        let service = AppService()
        Task(priority: .background) {
            let result = await service.getTasks()
            switch result {
            case .success(let response):
                print("Task-urile au fost aduse cu success \(response)")
                tasks = response
                for task in tasks {
                    dispatchNotification(for: task)
                }
                tableView.reloadData()
            case .failure(let error):
                print("Eroare \(error)")
            }
        }
    }
    
    
    func deleteTask(withId taskId: Int) {
        
        // Apelează funcția de ștergere a task-ului pe server sau implementează logica necesară
        // pentru ștergerea task-ului
        let service = AppService()
        Task(priority: .background) {
            let result = await service.deleteTask(taskId: taskId)
            switch result {
            case .success:
                print("Task șters cu succes")
            case .failure(let error):
                print("Eroare la ștergerea task-ului: \(error)")
            }
        }
    }
    
    @objc func deleteButtonTapped(cell: TaskCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let taskToDelete = tasks[indexPath.row]
            
            // Apelează funcția deleteTask(withId:) cu id-ul task-ului
            deleteTask(withId: taskToDelete.taskId)
            
            // Actualizează array-ul local și reîncarcă tabelul
            tasks.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    //    func taskCompletedButtonTapped(cell: TaskCell) {
    //        if let indexPath = tableView.indexPath(for: cell) {
    //            let taskId = tasks[indexPath.row].taskId
    //            let isCompleted = taskCompletionStatus[taskId] ?? false
    //            taskCompletionStatus[taskId] = !isCompleted
    //
    //            // Setează imaginea butonului în funcție de starea de finalizare
    //            let imageName: String = isCompleted ? "star.fill" : "star"
    //            let image = UIImage(systemName: imageName)
    //            cell.taskCompleted.setImage(image, for: .normal)
    //
    //            tableView.reloadRows(at: [indexPath], with: .automatic)
    //
    //
    //        }
    //    }
    
    func taskCompletedButtonTapped(cell: TaskCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let taskId = tasks[indexPath.row].taskId
            let isCompleted = taskCompletionStatus[taskId] ?? false
            taskCompletionStatus[taskId] = !isCompleted
            
            // Setează imaginea butonului în funcție de starea de finalizare
            let imageName: String = isCompleted ? "star.fill" : "star"
            let image = UIImage(systemName: imageName)
            cell.taskCompleted.setImage(image, for: .normal)
            
            // Salvează starea de finalizare în UserDefaults
            UserDefaults.standard.set(isCompleted, forKey: "taskCompleted-\(taskId)")
            
            // Test pentru a verifica salvarea în UserDefaults
            let savedCompletedState = UserDefaults.standard.bool(forKey: "taskCompleted-\(taskId)")
            print("Task \(taskId) saved state: \(savedCompletedState)")
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}
extension TasksViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell  = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell {
            
            cell.delegate = self
            let task = tasks[indexPath.row]
            
            cell.configure(titleTask: tasks[indexPath.row].title, descriptionTask: tasks[indexPath.row].description, priorityTask: tasks[indexPath.row].priority, dueDateTask: tasks[indexPath.row].dueDate)
            
            let taskId = task.taskId
            let isCompleted = UserDefaults.standard.bool(forKey: "taskCompleted-\(taskId)")
            let imageName: String = isCompleted ? "star.fill" : "star"
            let image = UIImage(systemName: imageName)
            cell.taskCompleted.setImage(image, for: .normal)
            
            // Setare delegat pentru celula curentă
            cell.delegate = self
            
            cell.layer.borderWidth = 0.1
            cell.layer.cornerRadius = 10
            
            
            
            return cell
        }
        return UITableViewCell()
    }
    
}
