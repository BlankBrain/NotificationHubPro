//
//  NotificationManager.swift
//  
//
//  Created by Md. Mehedi Hasan on 27/3/24.
//


import UIKit
import UserNotifications

struct LocalNotificationManager {
    static func showNotification(title: String, message: String, image: UIImage? = nil, after timeInterval: TimeInterval? = nil) {
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default
        
        // Attach image if provided
        if let image = image, let attachment = createAttachment(with: image) {
            content.attachments = [attachment]
        }

        // Create notification trigger (based on time interval if provided)
        var trigger: UNNotificationTrigger?
        if let timeInterval = timeInterval {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }

        // Create notification request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Schedule notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    private static func createAttachment(with image: UIImage) -> UNNotificationAttachment? {
        guard let imageData = image.pngData() else { return nil }
        
        let uniqueIdentifier = UUID().uuidString
        let fileName = "\(uniqueIdentifier).png"
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let fileURL = temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return try UNNotificationAttachment(identifier: uniqueIdentifier, url: fileURL, options: nil)
        } catch {
            print("Error creating notification attachment: \(error)")
            return nil
        }
    }
}



