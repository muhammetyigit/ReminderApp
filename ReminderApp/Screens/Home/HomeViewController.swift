//
//  HomeViewController.swift
//  ReminderApp
//
//  Created by Muhammet Yiğit on 7.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var todoCollectionView: UICollectionView!
    var newTodoField: UITextField!
    
    // MARK: - Properties
    var viewModel = HomeViewModel()
    var selectedIndexPath: IndexPath?
    var popupView: UIView!
    var backgroundView: UIView!
    var selectedDate: Date = Date()
    var filteredTasks: [TaskModel] = []
    var isEditingTasks = false
    var isSortedByDone: Bool?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.showsHorizontalScrollIndicator = false
        
        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
        todoCollectionView.showsVerticalScrollIndicator = false
        
        viewModel.generateNext30Days()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewDidScroll(dateCollectionView)
    }
    
    // MARK: - Functions
    @objc func dismissPopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            self.popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.backgroundView.removeFromSuperview()
        }
    }
    
    func showEmptyFieldWarning() {
        let alert = UIAlertController(title: "Warning", message: "This field cannot be left empty! Please enter a task.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func filterTask(sorted: Bool = true) {
        filteredTasks = TaskManager.shared.tasks.filter { task in
            return Calendar.current.isDate(task.date!, inSameDayAs: selectedDate)
        }
        
        if sorted {
            filteredTasks.sort { !$0.isDone && $1.isDone }
        }
    }
    
    // MARK: - Popup UI Design
    func showPopup() {
        backgroundView = UIView(frame: view.bounds)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(backgroundView)
        
        // Blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.addSubview(blurEffectView)
        
        blurEffectView.alpha = 0.6
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // Popup View
        popupView = UIView()
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.backgroundColor = .black
        popupView.layer.cornerRadius = 12
        popupView.layer.borderWidth = 0.6
        popupView.layer.borderColor = UIColor.white.cgColor
        backgroundView.addSubview(popupView)
        
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: 396),
            popupView.heightAnchor.constraint(equalToConstant: 353)
        ])
        
        // New Task Title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "New Task"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 33.75)
        popupView.addSubview(titleLabel)
        
        // Remind Title
        let remindLabel = UILabel()
        remindLabel.translatesAutoresizingMaskIntoConstraints = false
        remindLabel.text = "Remind"
        remindLabel.textColor = .white
        remindLabel.font = .systemFont(ofSize: 20, weight: .medium)
        popupView.addSubview(remindLabel)
        
        // Date Label
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .white
        dateLabel.font = .systemFont(ofSize: 18)
        dateLabel.text = "📅 " + viewModel.formattedDateString(from: Date())
        popupView.addSubview(dateLabel)
        
        // Time Label
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 18)
        timeLabel.text = "🕒 " + viewModel.formattedTimeString(from: Date())
        popupView.addSubview(timeLabel)
        
        // Text Field
        newTodoField = UITextField()
        newTodoField.translatesAutoresizingMaskIntoConstraints = false
        newTodoField.textColor = .white
        newTodoField.backgroundColor = UIColor.black
        newTodoField.font = .systemFont(ofSize: 16)
        newTodoField.layer.borderWidth = 0
        newTodoField.borderStyle = .roundedRect
        newTodoField.attributedPlaceholder = NSAttributedString(
            string: "Here will be the text of the new task.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        popupView.addSubview(newTodoField)
        
        // Save Button
        let saveButton = UIButton(type: .system)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = .white
        saveButton.layer.cornerRadius = 8
        popupView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            
            remindLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            remindLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            
            dateLabel.topAnchor.constraint(equalTo: remindLabel.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 21),
            timeLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            
            newTodoField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            newTodoField.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 16),
            newTodoField.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            newTodoField.heightAnchor.constraint(equalToConstant: 40),
            
            saveButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20),
            saveButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 70),
            saveButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        popupView.alpha = 0
        popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
            self.popupView.alpha = 1
            self.popupView.transform = .identity
        })
    }
    
    func updateTaskLabel(label: UILabel, text: String, isDone: Bool) {
        if isDone {
            let attrText = NSAttributedString(string: text, attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.gray
            ])
            label.attributedText = attrText
        } else {
            label.attributedText = NSAttributedString(string: text, attributes: [
                .foregroundColor: UIColor.white
            ])
        }
    }
    
    @IBAction func editButtonTapped() {
        isEditingTasks.toggle()
        
        todoCollectionView.visibleCells.forEach { cell in
            if let taskCell = cell as? TodoCollectionViewCell {
                print("GÖRÜNÜYOR: \(taskCell.taskLabel.text ?? "")")
                taskCell.setDeleteButtonVisible(isEditingTasks)
            } else {
                print("Dönüştürülemedi: \(cell)")
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func todoButtonTapped(_ sender: UIButton) {
        showPopup()
    }
    
    @objc func saveButtonTapped() {
        let text = newTodoField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if text.isEmpty {
            showEmptyFieldWarning()
            return
        }
        
        let newTask = TaskModel(text: text, date: selectedDate)
        TaskManager.shared.addTask(newTask)
        filterTask()
        todoCollectionView.reloadData()
        dismissPopup()
    }
}

// MARK: -  DateCollectionView & TodoCollectionView : UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView {
            return viewModel.dates.count
        }
        return filteredTasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM"
            return formatter
        }()
        
        if collectionView == dateCollectionView {
            let dateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "date", for: indexPath) as! DateCollectionViewCell
            dateCell.dateLabel.text = dateFormatter.string(from: viewModel.dates[indexPath.item])
            return dateCell
        }
        let taskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath) as! TodoCollectionViewCell
        
        let task = filteredTasks[indexPath.item]
        taskCell.delegate = self
        taskCell.buttonConfigure(isCheck: task.isDone)
        updateTaskLabel(label: taskCell.taskLabel, text: task.text ?? "", isDone: task.isDone)
        return taskCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollectionView {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.selectedDate = viewModel.dates[indexPath.row]
            filterTask()
            todoCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dateCollectionView {
            return CGSize(width: 50, height: 55)
        }
        return CGSize(width: 300, height: 52)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return collectionView != todoCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == dateCollectionView {
            let cellWidth: CGFloat = 50
            let inset = (collectionView.bounds.width - cellWidth) / 2
            return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
        return .zero
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = dateCollectionView.contentOffset.x + dateCollectionView.bounds.size.width / 2
        
        var closestIndexPath: IndexPath?
        var closestDistance: CGFloat = .greatestFiniteMagnitude
        
        for cell in dateCollectionView.visibleCells {
            guard let indexPath = dateCollectionView.indexPath(for: cell) else { continue }
            let cellCenterX = cell.center.x
            let distance = abs(cellCenterX - centerX)
            
            if distance < closestDistance {
                closestDistance = distance
                closestIndexPath = indexPath
            }
            
            if let dateCell = cell as? DateCollectionViewCell {
                let maxDistance = dateCollectionView.bounds.size.width / 2
                let ratio = min(distance / maxDistance, 1.0)
                let fontSize = 17 - (8 * ratio)
                let alpha = max(1 - ratio, 0.3)
                
                UIView.animate(withDuration: 0.2) {
                    dateCell.dateLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
                    dateCell.dateLabel.alpha = alpha
                }
            }
        }
        
        if let indexPath = closestIndexPath {
            let newDate = viewModel.dates[indexPath.item]
            
            if !Calendar.current.isDate(selectedDate, inSameDayAs: newDate) {
                selectedDate = newDate
                filterTask()
                todoCollectionView.reloadData()
            }
        }
    }
    
    
    
}

extension HomeViewController: TodoButtonInput {
    
    func congifureButton(cell: TodoCollectionViewCell) {
        guard let indexPath = todoCollectionView.indexPath(for: cell) else { return }
        
        let selectedTask = filteredTasks[indexPath.item]
        
        if let originalIndex = TaskManager.shared.tasks.firstIndex(where: { $0.id == selectedTask.id }) {
            TaskManager.shared.tasks[originalIndex].isDone.toggle()
            
            let newStatus = TaskManager.shared.tasks[originalIndex].isDone
            
            if newStatus {
                let alert = UIAlertController(title: "Mission Completed", message: "Move completed tasks to the bottom?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    self.filterTask(sorted: true)
                    self.todoCollectionView.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
                    self.filterTask(sorted: false)
                    self.todoCollectionView.reloadData()
                }))
                self.present(alert, animated: true)
            } else {
                self.filterTask(sorted: false)
                self.todoCollectionView.reloadData()
            }
        }
    }
        
    func deleteTask(cell: TodoCollectionViewCell) {
        guard let indexPath = todoCollectionView.indexPath(for: cell) else { return }
        
        let taskToDelete = filteredTasks[indexPath.item]
        
        if let originalIndex = TaskManager.shared.tasks.firstIndex(where: { $0.id == taskToDelete.id }) {
            TaskManager.shared.tasks.remove(at: originalIndex)
        }
        
        filterTask()
        
        todoCollectionView.deleteItems(at: [indexPath])
    }
}
