//
//  SplashScreenViewController.swift
//  ReminderApp
//
//  Created by Muhammet Yiğit on 13.05.2025.
//

import UIKit

class SplashScreenViewController: UIViewController {

    var logoImageView: UIImageView!
    var reminderLabel: UILabel!
    var label1: UILabel!
    var label2: UILabel!
    var label3: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        logoImageView = UIImageView(image: UIImage(named: "app_logo"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        reminderLabel = UILabel()
        reminderLabel.text = "Reminder"
        reminderLabel.textColor = .white
        reminderLabel.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        reminderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reminderLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),

            reminderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reminderLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10)
        ])

        animateLogoAndText()

        let calendarImageView = UIImageView(image: UIImage(systemName: "calendar"))
        calendarImageView.tintColor = .white
        calendarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarImageView)
        
        NSLayoutConstraint.activate([
            calendarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            calendarImageView.widthAnchor.constraint(equalToConstant: 100),
            calendarImageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        label1 = createLabel(text: "Don’t Forget Your Daily Tasks")
        label2 = createLabel(text: "Save Your Tasks to Stay Organized")
        label3 = createLabel(text: "Delete Completed Tasks to Keep Your List Tidy")

        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)

        NSLayoutConstraint.activate([
            label1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label1.topAnchor.constraint(equalTo: calendarImageView.bottomAnchor, constant: 30),
            
            label2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 10),
            
            label3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10)
        ])

        animateLabels()

        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.transitionToMainScreen()
        }
    }

    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont(descriptor: UIFontDescriptor(name: "HelveticaNeue-BoldItalic", size: 17), size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }

    func animateCalendar(_ calendarImageView: UIImageView) {
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut, animations: {
            calendarImageView.center.y = self.view.center.y - 50
        })
    }

    func animateLogoAndText() {
        logoImageView.alpha = 0
        reminderLabel.alpha = 0
        
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) // Küçük başlasın
        reminderLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) // Küçük başlasın
        
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseOut, animations: {
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.reminderLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            self.logoImageView.alpha = 1
            self.reminderLabel.alpha = 1
        })
    }

    func animateLabels() {
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseInOut, animations: {
            self.label1.alpha = 1
            self.label1.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
                self.label2.alpha = 1
                self.label2.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { _ in
                UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
                    self.label3.alpha = 1
                    self.label3.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            }
        }
    }

    func transitionToMainScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainViewController") as? HomeViewController {
            let navigationController = UINavigationController(rootViewController: mainViewController)
            if let window = view.window {
                window.rootViewController = navigationController
            }
        }
    }
}
