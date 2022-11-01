//
//  Extensions.swift
//  ABB_TestCase_nzmasadov
//
//  Created by Test Test on 30.10.22.
//

import Foundation
import UIKit
import Combine

extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
    
    static let appBackGroundColor: UIColor = dynamicColor(light: UIColor(red: 255/255, green: 1, blue: 1, alpha: 1), dark: UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0))
}

extension UISearchTextField {
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: self).map { ($0.object as? UISearchTextField)?.text ?? "" }.eraseToAnyPublisher()
    }
}

extension UIView {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
       let mask = CAShapeLayer()
       mask.path = path.cgPath
       layer.mask = mask
   }
}
