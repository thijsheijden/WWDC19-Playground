import SpriteKit

struct BugDataStruct {
    
    var image: NSImage
    var answerLabels: [String]
    var correctAnswer: String
    
    init(image: NSImage, answerLabels: [String], correctAnswer: String) {
        self.image = image
        self.answerLabels = answerLabels
        self.correctAnswer = correctAnswer
    }
    
}
