//
//  MotionManager.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 01.04.25.
//

import Foundation
import CoreMotion

class MotionManager {
    static let shared = MotionManager()
    private let motionManager = CMMotionManager()
    private var imuData: [[String: Any]] = []

    func startIMUUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion not available")
            return
        }

        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let data = motion else { return }

            let acc = data.userAcceleration
            let rot = data.rotationRate
            let timestamp = Date().timeIntervalSince1970
            let entry: [String: Any] = [
                "timestamp": timestamp,
                "acc": ["x": acc.x, "y": acc.y, "z": acc.z],
                "gyro": ["x": rot.x, "y": rot.y, "z": rot.z]
            ]
            
            self.imuData.append(entry)

            // flush to disk every 100 entries
            if self.imuData.count >= 100 {
                self.saveIMUDataToLocalStorage()
                self.imuData.removeAll()
            }

            print(String(format: "[%.3f] Acc -> x: %.5f, y: %.5f, z: %.5f | Gyro -> x: %.5f, y: %.5f, z: %.5f",
                         timestamp, acc.x, acc.y, acc.z, rot.x, rot.y, rot.z))
        }
    }
    
    func stopIMUUpdates() {
        motionManager.stopDeviceMotionUpdates()
        saveIMUDataToLocalStorage()
    }

    private func saveIMUDataToLocalStorage() {
        let dateKey = "IMU-\(FirestoreService.shared.getCurrentDate())"
        let existing = UserDefaults.standard.array(forKey: dateKey) as? [[String: Any]] ?? []
        UserDefaults.standard.set(existing + imuData, forKey: dateKey)
        print("Saved IMU data locally with key \(dateKey)")
    }
}
