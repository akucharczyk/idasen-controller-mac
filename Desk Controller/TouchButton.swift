import Cocoa

class TouchButton: NSButton {
    
    var isPressed = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    func setup() {
        sendAction(on: [.leftMouseDown, .leftMouseUp])
    }
    
    override func mouseDown(with event: NSEvent) {
        isPressed = true
        super.mouseDown(with: event)
        isPressed = false
        let _ = target?.perform(action, with: self)
    }
}
