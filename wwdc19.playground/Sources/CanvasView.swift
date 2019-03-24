import SpriteKit

class CanvasView: NSView {
    
    var drawLayer: CALayer?
    
    var startPoint: NSPoint?
    var touchPoint: NSPoint?
    var path: NSBezierPath?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupCanvasView()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    // Initial setup of the canvas view
    func setupCanvasView() {
        self.wantsLayer = true
        drawLayer = CALayer()
        drawLayer?.backgroundColor = CGColor.white
        self.layer = drawLayer
    }
    
    // Mouse button down event
    override func mouseDown(with event: NSEvent) {
        startPoint = NSPoint(x: event.locationInWindow.x - 350, y: event.locationInWindow.y - 160)
    }
    
    // Mouse dragged event
    override func mouseDragged(with event: NSEvent) {
        touchPoint = NSPoint(x: event.locationInWindow.x - 350, y: event.locationInWindow.y - 160)
        
        path = NSBezierPath()
        path?.move(to: startPoint!)
        path?.line(to: touchPoint!)
        startPoint = touchPoint
        
        drawShapeLayer()
    }
    
    // Creating new layer and adding the path to it
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path?.cgPath
        shapeLayer.strokeColor = CGColor.black
        shapeLayer.lineWidth = 5.0
        shapeLayer.fillColor = CGColor.clear
        self.drawLayer?.addSublayer(shapeLayer)
        self.layout()
    }
    
    // Method to clear the canvas
    func clearCanvas() {
        path?.removeAllPoints()
        self.drawLayer?.sublayers = nil
        self.layout()
    }
}
