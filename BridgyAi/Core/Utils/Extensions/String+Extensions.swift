//
//  String+Extensions.swift
//  BridgyAi
//
//  Created by Роман Главацкий on 13.12.2025.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func removingWhitespaces() -> String {
        self.replacingOccurrences(of: " ", with: "")
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func fuzzyMatch(_ other: String) -> Bool {
        let normalizedSelf = self.removingWhitespaces()
        let normalizedOther = other.removingWhitespaces()
        
        // Точное совпадение
        if normalizedSelf == normalizedOther {
            return true
        }
        
        // Проверка на включение
        if normalizedSelf.contains(normalizedOther) || normalizedOther.contains(normalizedSelf) {
            return true
        }
        
        // Простая проверка на схожесть (можно улучшить алгоритмом Левенштейна)
        let similarity = calculateSimilarity(normalizedSelf, normalizedOther)
        return similarity > 0.7
    }
    
    private func calculateSimilarity(_ s1: String, _ s2: String) -> Double {
        let longer = s1.count > s2.count ? s1 : s2
        let shorter = s1.count > s2.count ? s2 : s1
        
        if longer.count == 0 {
            return 1.0
        }
        
        let distance = levenshteinDistance(shorter, longer)
        return (Double(longer.count) - Double(distance)) / Double(longer.count)
    }
    
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let s1Array = Array(s1)
        let s2Array = Array(s2)
        var matrix = Array(repeating: Array(repeating: 0, count: s2.count + 1), count: s1.count + 1)
        
        for i in 0...s1.count {
            matrix[i][0] = i
        }
        
        for j in 0...s2.count {
            matrix[0][j] = j
        }
        
        for i in 1...s1.count {
            for j in 1...s2.count {
                let cost = s1Array[i-1] == s2Array[j-1] ? 0 : 1
                matrix[i][j] = Swift.min(
                    matrix[i-1][j] + 1,
                    matrix[i][j-1] + 1,
                    matrix[i-1][j-1] + cost
                )
            }
        }
        
        return matrix[s1.count][s2.count]
    }
}


