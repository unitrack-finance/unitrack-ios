//
//  ExportService.swift
//  Unitrack
//
//  Created by Sylus Abel on 10/02/2026.
//

import Foundation
import SwiftUI

@MainActor
class ExportService {
    static let shared = ExportService()
    
    private init() {}
    
    func generateCSV(from data: [ChartPoint]) -> URL? {
        var csvString = "Date,Value\n"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        for point in data {
            let date = dateFormatter.string(from: point.date)
            csvString += "\(date),\(String(format: "%.2f", point.value))\n"
        }
        
        let fileName = "Unitrack_Portfolio_\(Date().timeIntervalSince1970).csv"
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            return path
        } catch {
            print("Failed to save CSV: \(error)")
            return nil
        }
    }
    
    // PDF generation would typically involve UIGraphicsPDFRenderer or similar
    func generatePDF() -> URL? {
        // Placeholder for PDF generation logic
        return nil
    }
}
