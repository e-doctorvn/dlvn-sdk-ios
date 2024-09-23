//
//  CountDownManager.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 29/08/2023.
//

import Foundation

@available(iOS 13.0, *)
public class CountDownManager: ObservableObject {
    
    static let shared = CountDownManager()
    
    @Published var remainingTime: TimeInterval = 1800
    
    private var timer: Timer?
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    public func stopTimer() {
        timer?.invalidate()
        remainingTime = 1800
        timer = nil
    }
    
    public func startCountDown(remainingTime : TimeInterval) {
        stopTimer()
        self.remainingTime = remainingTime
        startTimer()
    }
}
