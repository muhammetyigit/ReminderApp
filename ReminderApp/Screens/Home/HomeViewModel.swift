//
//  HomeViewModel.swift
//  ReminderApp
//
//  Created by Muhammet Yiğit on 7.05.2025.
//

import Foundation

protocol HomeViewModelOutput {
    
    func generateNext30Days()
    func formattedDateString(from date: Date) -> String
    func formattedTimeString(from date: Date) -> String
}

class HomeViewModel: HomeViewModelOutput {
    
    var dates: [Date] = []
    
    func generateNext30Days() {
        let calendar = Calendar.current
        let today = Date()
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
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
    
}
