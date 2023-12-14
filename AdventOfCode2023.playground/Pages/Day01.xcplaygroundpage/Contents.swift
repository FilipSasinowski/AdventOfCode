import Foundation
// MARK: --- Day 1: Trebuchet?! ---
// setup puzzle input
let filePath = Bundle.main.path(forResource:"day01input", ofType: "txt")
let contentData = FileManager.default.contents(atPath: filePath!)
let puzzleInput = String(data: contentData!, encoding: .utf8)?.components(separatedBy: "\n")
// MARK: --- Part One ---
/*
 Something is wrong with global snow production, and you've been selected to take a look. 
 The Elves have even given you a map; on it, they've used stars to mark the top fifty locations that are likely to be having problems.
 You've been doing this long enough to know that to restore snow operations, you need to check all fifty stars by December 25th.
 Collect stars by solving puzzles.
 Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!
 
 You try to ask why they can't just use a weather machine ("not powerful enough") and where they're even sending you ("the sky") and
 why your map looks mostly blank ("you sure ask a lot of questions") and hang on did you just say the sky ("of course, where do you think snow comes from")
 when you realize that the Elves are already loading you into a trebuchet ("please hold still, we need to strap you in").
 As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been amended by a very young Elf who 
 was apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.

 The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover. 
 On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.

 For example:

 1abc2
 pqr3stu8vwx
 a1b2c3d4e5f
 treb7uchet

 In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.

 Consider your entire calibration document. What is the sum of all of the calibration values?
 */
let partOneTestInput = [
    "1abc2",
    "pqr3stu8vwx",
    "a1b2c3d4e5f",
    "treb7uchet"
]

fileprivate extension String {
    func getCalibrationValue() -> Int? {
        guard
            let firstDigit = self.first(where: { $0.isWholeNumber })?.wholeNumberValue,
            let lastDigit = self.last(where: { $0.isWholeNumber })?.wholeNumberValue
        else {
            return nil
        }
        return firstDigit * 10 + lastDigit
    }
}
assert(partOneTestInput.reduce(into: 0, { result, line in result += line.getCalibrationValue() ?? 0 }) == 142)
let calibrationValueSum = puzzleInput?.reduce(into: 0, { result, line in result += line.getCalibrationValue() ?? 0 })
// Correct answer: 54927
// MARK: --- Part Two ---
/*
 Your calculation isn't quite right. It looks like some of the digits are actually spelled out with letters: one, two, three, four, five, six, seven, eight, and nine also count as valid "digits".

 Equipped with this new information, you now need to find the real first and last digit on each line. For example:

 two1nine
 eightwothree
 abcone2threexyz
 xtwone3four
 4nineeightseven2
 zoneight234
 7pqrstsixteen

 In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76. Adding these together produces 281.

 What is the sum of all of the calibration values?

 */
let testinput = [
    "two1nine",
    "eightwothree",
    "abcone2threexyz",
    "xtwone3four",
    "4nineeightseven2",
    "zoneight234",
    "7pqrstsixteen"
]

let digits = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

fileprivate extension String {
    func getCalibrationValue(accepting digits: [String]) -> Int? {
        guard
            let firstDigit = self.getFirstDigit(accepting: digits),
            let lastDigit = self.getLastDigit(accepting: digits)
        else {
            return nil
        }
        return firstDigit * 10 + lastDigit
    }
    
    private func getFirstDigit(accepting digits: [String]) -> Int? {
        var line = self
        while !line.isEmpty {
            if let numericalDigit = line.first?.wholeNumberValue {
                return numericalDigit
            }
            for (index, digit) in digits.enumerated() {
                if line.hasPrefix(digit) {
                    return index
                }
            }
            line.removeFirst()
        }
        return nil
    }
    
    private func getLastDigit(accepting digits: [String]) -> Int? {
        var line = self
        while !line.isEmpty {
            if let numericalDigit = line.last?.wholeNumberValue {
                return numericalDigit
            }
            for (index, digit) in digits.enumerated() {
                if line.hasSuffix(digit) {
                    return index
                }
            }
            line.removeLast()
        }
        return nil
    }
}

assert(testinput.reduce(into: 0, { result, line in result += line.getCalibrationValue(accepting: digits) ?? 0}) == 281)
let calibrationValueSumWithDigits = puzzleInput?.reduce(into: 0, { result, line in result += line.getCalibrationValue(accepting: digits) ?? 0})
// Correct answer: 54581
