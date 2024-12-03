//
//  Extension.swift
//  Tracker
//
//  Created by Олег Кор on 03.12.2024.
//


import UIKit

extension UIColor {
    // Преобразование UIColor в HEX строку
    func toHexString() -> String {
        let components = self.cgColor.components
        
        // Если цвет прозрачный или некорректный
        guard let r = components?[0], let g = components?[1], let b = components?[2] else {
            return "#000000"
        }
        
        let red = Int(r * 255)
        let green = Int(g * 255)
        let blue = Int(b * 255)
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}

extension UIColor {
    // Функция для преобразования строки HEX в UIColor
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Убираем префикс #, если он есть
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        // Если строка не соответствует правильному формату HEX
        guard hexSanitized.count == 6 else {
            return nil
        }

        // Разбиваем строку на компоненты RGB
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        // Извлекаем компоненты цвета
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        // Инициализация UIColor
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}



