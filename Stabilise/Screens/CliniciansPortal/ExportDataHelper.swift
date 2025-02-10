//
//  ExportDataHelper.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 09.02.25.
//

import Foundation
import PDFKit
import UIKit

class ExportDataHelper {
    
    static let shared = ExportDataHelper()
    private init() {}

    func getDatesInRange(startDate: Date, endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }

    /// ✅ FIX: Added this function to get all stored dates from UserDefaults
    func getAvailableDates() -> [Date] {
        let storedKeys = UserDefaults.standard.dictionaryRepresentation().keys
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        var extractedDates: [Date] = []
        
        for key in storedKeys {
            if key.starts(with: "Falls_diary-") || key.starts(with: "SubmittedAnswer-") || key.starts(with: "Exercise-") {
                let dateString = key.components(separatedBy: "-").last ?? ""
                if let date = dateFormatter.date(from: dateString) {
                    extractedDates.append(date)
                }
            }
        }
        
        return extractedDates.sorted()
    }
    
    func collectData(allTimeSelected: Bool, startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

        var collectedData = "Exported Data\n\n"

        let dateRange = allTimeSelected ? getAvailableDates() : getDatesInRange(startDate: startDate, endDate: endDate)

        for date in dateRange {
            let dateString = date.formatted(date: .numeric, time: .omitted)
            
            let fallsDiary = UserDefaults.standard.dictionary(forKey: "Falls_diary-\(dateString)") ?? [:]
            let questionnaire = UserDefaults.standard.dictionary(forKey: "SubmittedAnswer-\(dateString)") ?? [:]
            let exercises = UserDefaults.standard.array(forKey: "Exercise-\(dateString)") as? [Int] ?? []

            if !fallsDiary.isEmpty || !questionnaire.isEmpty || !exercises.isEmpty {
                collectedData += "📅 Date: \(dateString)\n"
                collectedData += "📝 Falls Diary: \(fallsDiary)\n"
                collectedData += "📊 Questionnaire: \(questionnaire)\n"
                collectedData += "💪 Exercises: \(exercises)\n"
                collectedData += "\n----------------------\n"
            }
        }

        if collectedData == "Exported Data\n\n" {
            collectedData += "❌ No data found for the selected period."
        }

        return collectedData
    }

    func generatePDF(from text: String) -> URL? {
        guard !text.isEmpty else {
            print("❌ PDF content is empty!")
            return nil
        }

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("ExportedData.pdf")

        do {
            try pdfRenderer.writePDF(to: url, withActions: { context in
                context.beginPage()
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left

                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12),
                    .paragraphStyle: paragraphStyle
                ]

                let attributedText = NSAttributedString(string: text, attributes: attributes)
                attributedText.draw(in: CGRect(x: 20, y: 20, width: 572, height: 752))
            })

            return url
        } catch {
            print("❌ Failed to create PDF: \(error.localizedDescription)")
            return nil
        }
    }
}
