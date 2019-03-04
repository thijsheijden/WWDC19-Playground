import SpriteKit

struct BugDataStruct {
    
    var imageName: String
    var answerLabels: [String]
    var correctAnswer: [Bool]
    
    init(imageName: String, answerLabels: [String], correctAnswer: [Bool]) {
        self.imageName = imageName
        self.answerLabels = answerLabels
        self.correctAnswer = correctAnswer
    }
}
