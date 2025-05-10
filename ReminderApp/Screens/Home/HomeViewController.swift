//
//  HomeViewController.swift
//  ReminderApp
//
//  Created by Muhammet Yiğit on 7.05.2025.
//

import UIKit

protocol HomeViewControllerInput {
    func todoButtonTapped()
}

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var todoCollectionView: UICollectionView!
    var newTodoField: UITextField!
    
    // MARK: - Properties
    var dates: [Date] = []
    var selectedIndexPath: IndexPath?
    var popupView: UIView!
    var backgroundView: UIView!
    var allTask = [TaskModel]()
    var selectedDate: Date = Date()
    var filteredTasks: [TaskModel] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.showsHorizontalScrollIndicator = false
        
        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
        todoCollectionView.showsVerticalScrollIndicator = false
        
        generateNext30Days()
        filterTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewDidScroll(dateCollectionView)
        
    }
    
    // MARK: - Functions
    func generateNext30Days() {
        let calendar = Calendar.current
        let today = Date()
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
    }
    
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
        dateLabel.text = "📅 " + formattedDateString(from: Date())
        popupView.addSubview(dateLabel)
        
        // Time Label
        let timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 18)
        timeLabel.text = "🕒 " + formattedTimeString(from: Date())
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
    
    
    func formattedDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "E, dd MMMM"
        return formatter.string(from: date)
    }
    
    func formattedTimeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
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
    
    func filterTasks() {
        filteredTasks = allTask.filter {
            Calendar.current.isDate($0.date!, inSameDayAs: selectedDate)
        }
        todoCollectionView.reloadData()
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
        allTask.append(newTask)
        todoCollectionView.reloadData()
        filterTasks()
        dismissPopup()
    }
}

// MARK: -  DateCollectionView & TodoCollectionView : UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView {
            return dates.count
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "date", for: indexPath) as! DateCollectionViewCell
            cell.dateLabel.text = dateFormatter.string(from: dates[indexPath.item])
            return cell
        }
        let item = filteredTasks[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todo", for: indexPath) as! TodoCollectionViewCell
        cell.taskLabel.text = item.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollectionView {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.selectedDate = dates[indexPath.row]
            print(selectedDate)
            filterTasks()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dateCollectionView {
            return CGSize(width: 50, height: 55)
        } else {
            return CGSize(width: 373, height: 52)
        }
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
            selectedDate = dates[indexPath.item]
            filterTasks()
        }
    }
}
