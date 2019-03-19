import SpriteKit

class CanvasView: NSView {
    
    var drawLayer: CALayer?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupCanvasView()
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func setupCanvasView() {
        self.wantsLayer = true
        drawLayer = CALayer()
        drawLayer?.backgroundColor = CGColor.white
        self.layer = drawLayer
    }
    
    override func mouseDown(with event: NSEvent) {
        draw(NSRect(x: event.absoluteX, y: event.absoluteY, width: 10, height: 10))
        self.needsDisplay = true
    }
    
    override func mouseMoved(with event: NSEvent) {
        draw(NSRect(x: event.absoluteX, y: event.absoluteY, width: 10, height: 10))
        self.needsDisplay = true 
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        print("Printing")
        
        let context = NSGraphicsContext.current?.cgContext
        
        context?.setFillColor(CGColor.black)
        
        
    }
    
}
