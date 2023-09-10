//
//  extensionButton.swift
//  ClientTaskManager
//
//  Created by Melisa Farcasanu on 25.07.2023.
//
import Foundation
import UIKit

extension UIButton {
    func customizeButton() {
        self.layer.cornerRadius = 20
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
}

