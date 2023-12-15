import Foundation
// MARK:  --- Day 3: Gear Ratios ---
// setup puzzle input
let filePath = Bundle.main.path(forResource:"day03input", ofType: "txt")
let contentData = FileManager.default.contents(atPath: filePath!)
let puzzleInput = String(data: contentData!, encoding: .utf8)?.components(separatedBy: "\n")
// MARK: --- Part One ---
/*
 You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the water source, but this is as far as he can bring you.
 You go inside.
 It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.
 "Aaah!"
 You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone!
 The gondola lift isn't working right now; it'll still be a while before I can fix it."
 You offer to help.
 
 The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one.
 If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.
 
 The engine schematic (your puzzle input) consists of a visual representation of the engine.
 There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum.
 (Periods (.) do not count as a symbol.)
 
 Here is an example engine schematic:
 
 467..114..
 ...*......
 ..35..633.
 ......#...
 617*......
 .....+.58.
 ..592.....
 ......755.
 ...$.*....
 .664.598..
 
 In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right).
 Every other number is adjacent to a symbol and so is a part number; their sum is 4361.
 
 Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?
 
 To begin, get your puzzle input.
 */
let partOneTestInput = [
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
    ".....+.58.",
    "..592.....",
    "......755.",
    "...$.*....",
    ".664.598.."
]

class Engine {
    var engineMap: [[Character]]
    
    init(puzzleInput: [String]?) {
        self.engineMap = Engine.initEngineMap(from: puzzleInput)
    }
    
    struct Direction {
        let horizontal: HorizontalInstruction
        let vertical: VerticalInstruction
        
        enum HorizontalInstruction: Int {
            case left = -1
            case stay = 0
            case right = 1
        }
        enum VerticalInstruction: Int {
            case up = -1
            case stay = 0
            case down = 1
        }
    }
    
    private static func initEngineMap(from puzzleInput: [String]?) -> [[Character]] {
        guard let puzzleInput = puzzleInput else { return [[]] }
        
        return puzzleInput.compactMap { line in
            guard !line.isEmpty else { return nil }
            return line.compactMap { character in
                return character
            }
        }
    }
    
    private func checkAjacentFieldsForPart(row: Int, column: Int) -> Bool {
        var currentRow = row
        var currentColumn = column
        let rows = engineMap.count
        let columns = engineMap.first!.count
        let movesToExecute: [Direction] = [
            Direction(horizontal: .left, vertical: .stay),
            Direction(horizontal: .stay, vertical: .up),
            Direction(horizontal: .right, vertical: .stay),
            Direction(horizontal: .right, vertical: .stay),
            Direction(horizontal: .stay, vertical: .down),
            Direction(horizontal: .stay, vertical: .down),
            Direction(horizontal: .left, vertical: .stay),
            Direction(horizontal: .left, vertical: .stay)
        ]
        for move in movesToExecute {
            currentRow += move.horizontal.rawValue
            currentColumn += move.vertical.rawValue
            guard
                currentRow >= 0 && currentRow < rows,
                currentColumn >= 0 && currentColumn < columns,
                !engineMap[currentRow][currentColumn].isWholeNumber && engineMap[currentRow][currentColumn] != "."
            else {
                continue
            }
            return true
        }
        return false
    }
}

extension Engine {
    func sumUpActiveNumbers() -> Int {
        var sum = 0
        var currentNumber = ""
        var isActive = false
        for (rowIndex, row) in engineMap.enumerated() {
            for (columnIndex, character) in row.enumerated() {
                switch character.isWholeNumber {
                case false:
                    if isActive {
                        sum += Int(currentNumber) ?? 0
                    }
                    currentNumber = ""
                    isActive = false
                case true:
                    currentNumber += String(character.wholeNumberValue!)
                    if !isActive {
                        isActive = checkAjacentFieldsForPart(row: rowIndex, column: columnIndex)
                    }
                }
            }
        }
        return sum
    }
}

assert(Engine(puzzleInput: partOneTestInput).sumUpActiveNumbers() == 4361)

let engine = Engine(puzzleInput: puzzleInput)
engine.sumUpActiveNumbers()
// Correct answer: 509 115
// MARK:  --- Part Two ---
/*
 The engineer finds the missing part and installs it in the engine!
 As the engine springs to life, you jump in the closest gondola, finally ready to ascend to the water source.
 You don't seem to be going very fast, though.
 Maybe something is still wrong? Fortunately, the gondola has a phone labeled "help", so you pick it up and the engineer answers.
 
 Before you can explain the situation, she suggests that you look out the window.
 There stands the engineer, holding a phone in one hand and waving with the other.
 You're going so slowly that you haven't even left the station.
 You exit the gondola.
 
 The missing part wasn't the only issue - one of the gears in the engine is wrong.
 A gear is any * symbol that is adjacent to exactly two part numbers.
 Its gear ratio is the result of multiplying those two numbers together.
 
 This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs to be replaced.
 
 Consider the same engine schematic again:
 
 467..114..
 ...*......
 ..35..633.
 ......#...
 617*......
 .....+.58.
 ..592.....
 ......755.
 ...$.*....
 .664.598..
 
 In this schematic, there are two gears.
 The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345.
 The second gear is in the lower right; its gear ratio is 451490.
 (The * adjacent to 617 is not a gear because it is only adjacent to one part number.)
 Adding up all of the gear ratios produces 467835.
 
 What is the sum of all of the gear ratios in your engine schematic?
 
 */
let partTwoTestInput = [
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
    ".....+.58.",
    "..592.....",
    "......755.",
    "...$.*....",
    ".664.598.."
]
extension Engine {
    func sumUpGearRatios() -> Int {
        var sum = 0
        for (rowIndex, row) in engineMap.enumerated() {
            for (columnIndex, character) in row.enumerated() {
                if character == "*" {
                    let numbers = findAdjacentNumbers(row: rowIndex, column: columnIndex)
                    sum += numbers.count == 2 ? numbers[0] * numbers[1] : 0
                }
            }
        }
        return sum
    }
    
    private func findAdjacentNumbers(row: Int, column: Int) -> [Int] {
        var currentRow = row
        var currentColumn = column
        let rows = engineMap.count
        let columns = engineMap.first!.count
        let movesToExecute: [Direction] = [
            Direction(horizontal: .left, vertical: .stay),
            Direction(horizontal: .stay, vertical: .up),
            Direction(horizontal: .right, vertical: .stay),
            Direction(horizontal: .right, vertical: .stay),
            Direction(horizontal: .stay, vertical: .down),
            Direction(horizontal: .stay, vertical: .down),
            Direction(horizontal: .left, vertical: .stay),
            Direction(horizontal: .left, vertical: .stay)
        ]
        var numbers: [Int] = []
        var visitedIndexes: [(Int, Int)] = []
        for move in movesToExecute {
            currentRow += move.horizontal.rawValue
            currentColumn += move.vertical.rawValue
            guard
                currentRow >= 0 && currentRow < rows,
                currentColumn >= 0 && currentColumn < columns,
                engineMap[currentRow][currentColumn].isWholeNumber,
                !visitedIndexes.contains(where: { (rowX, colY) in
                    rowX == currentRow && colY == currentColumn
                })
            else {
                continue
            }
            let outcome = findNumber(row: currentRow, column: currentColumn)
            numbers.append(outcome.0)
            visitedIndexes.append(contentsOf: outcome.1)
        }
        return numbers
    }
    
    private func findNumber(row: Int, column: Int) -> (Int, [(Int, Int)]) {
        var visitedIndexes: [(Int, Int)] = []
        var engineRow = engineMap[row]
        var number = "\(engineRow[column])"

        var currentSymbol = engineRow[column]
        var i = column
        
        while currentSymbol.isWholeNumber {
            i += 1
            guard i < engineRow.count else { break }
            currentSymbol = engineRow[i]
            guard currentSymbol.isWholeNumber else { break }
            number.insert(currentSymbol, at: number.endIndex)
            visitedIndexes.append((row, i))
        }
        currentSymbol = engineRow[column]
        i = column
        while currentSymbol.isWholeNumber {
            i -= 1
            guard i >= 0 else { break }
            currentSymbol = engineRow[i]
            guard currentSymbol.isWholeNumber else { break }
            number.insert(currentSymbol, at: number.startIndex)
            visitedIndexes.append((row, i))
        }
        return (Int(number)!, visitedIndexes)
    }
}

assert(Engine(puzzleInput: partTwoTestInput).sumUpGearRatios() == 467835)
engine.sumUpGearRatios()
// Correct answer: 75 220 503
