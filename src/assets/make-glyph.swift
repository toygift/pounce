import AppKit

// Draws the Pounce glyph into glyph-source.png (black on transparent, 512 px), the drawing
// make-icon.swift turns into the app icon and the menu bar mask.
// A notification card leaps along an arc from where the system put it to where you want it:
// a ghost card where it was, the arc it travels, the card where it lands.
// Usage: swift make-glyph.swift

let here = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let px = 512

let image = NSImage(size: NSSize(width: px, height: px), flipped: false) { _ in
  NSColor.black.setFill()
  NSColor.black.setStroke()

  // Where it was: an outlined card, bottom left.
  let ghost = NSBezierPath(roundedRect: NSRect(x: 30, y: 46, width: 206, height: 136), xRadius: 34, yRadius: 34)
  ghost.lineWidth = 32
  ghost.setLineDash([62, 34], count: 2, phase: 20)
  ghost.stroke()

  // The leap: an arc rising from the ghost and dropping onto the card, ending in a head.
  let arc = NSBezierPath()
  arc.move(to: NSPoint(x: 132, y: 222))
  arc.curve(to: NSPoint(x: 268, y: 318), controlPoint1: NSPoint(x: 136, y: 340), controlPoint2: NSPoint(x: 206, y: 372))
  arc.lineWidth = 36
  arc.lineCapStyle = .round
  arc.stroke()
  let head = NSBezierPath()
  head.move(to: NSPoint(x: 300, y: 278))
  head.line(to: NSPoint(x: 224, y: 300))
  head.line(to: NSPoint(x: 284, y: 356))
  head.close()
  head.lineJoinStyle = .round
  head.lineWidth = 14
  head.fill()
  head.stroke()

  // Where it lands: a solid card, top right, with two lines of text cut out of it.
  let card = NSRect(x: 236, y: 298, width: 252, height: 174)
  NSBezierPath(roundedRect: card, xRadius: 42, yRadius: 42).fill()
  NSGraphicsContext.current!.compositingOperation = .clear
  NSBezierPath(roundedRect: NSRect(x: card.minX + 34, y: card.minY + 100, width: 164, height: 30), xRadius: 15, yRadius: 15).fill()
  NSBezierPath(roundedRect: NSRect(x: card.minX + 34, y: card.minY + 46, width: 112, height: 30), xRadius: 15, yRadius: 15).fill()
  return true
}

let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: px, pixelsHigh: px, bitsPerSample: 8,
                           samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
                           bytesPerRow: 0, bitsPerPixel: 0)!
rep.size = NSSize(width: px, height: px)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
image.draw(in: NSRect(x: 0, y: 0, width: px, height: px))
NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: here.appendingPathComponent("glyph-source.png"))
print("glyph-source.png written")
