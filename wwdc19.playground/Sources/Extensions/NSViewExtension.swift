import SpriteKit

extension NSView {
    var snapshot: NSImage {
        guard let bitmapRep = bitmapImageRepForCachingDisplay(in: bounds) else { return NSImage() }
        cacheDisplay(in: bounds, to: bitmapRep)
        let image = NSImage()
        image.addRepresentation(bitmapRep)
        bitmapRep.size = bounds.size.doubleScale()
        return image
    }
}

extension CGSize {
    func doubleScale() -> CGSize {
        return CGSize(width: width * 2, height: height * 2)
    }
}

extension NSImage {
    var cgImage: CGImage {
        let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil)
        return cgImage!
    }
}

extension CGImage {
    func resize() -> CGImage? {
        
        let width = 250.0
        let height = 250.0
        
        guard let colorSpace = self.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: self.bitsPerComponent, bytesPerRow: self.bytesPerRow, space: colorSpace, bitmapInfo: self.alphaInfo.rawValue) else { return nil }
        
        // draw image to context (resizing it)
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))
        
        // extract resulting image from context
        return context.makeImage()
    }
}

