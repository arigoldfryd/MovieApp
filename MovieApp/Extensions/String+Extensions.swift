//
//  String+Extensions.swift
//  MovieApp
//
//  Created by Ariel on 31/07/2023.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = dateFormatter.date(from: self) else {
            print("Error: Unable to convert the string to a Date.")
            return nil
        }
        
        return date
    }
}
