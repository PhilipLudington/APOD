// Draws the 1024-pixel app icon: a rounded dark-sky tile with a nebula glow and stars.
// Usage: swift icon.swift <out.png>
import AppKit

let size = 1024.0
let image = NSImage(size: NSSize(width: size, height: size))
image.lockFocus()
let ctx = NSGraphicsContext.current!.cgContext

// macOS icon grid: the tile is 824 points inside the 1024 canvas.
let tile = CGRect(x: 100, y: 100, width: 824, height: 824)
let shape = CGPath(roundedRect: tile, cornerWidth: 185, cornerHeight: 185, transform: nil)
ctx.addPath(shape)
ctx.clip()

let space = CGColorSpaceCreateDeviceRGB()
let sky = CGGradient(colorsSpace: space, colors: [
    CGColor(red: 0.02, green: 0.03, blue: 0.10, alpha: 1),
    CGColor(red: 0.08, green: 0.04, blue: 0.20, alpha: 1),
] as CFArray, locations: [0, 1])!
ctx.drawLinearGradient(sky, start: CGPoint(x: 512, y: 100), end: CGPoint(x: 512, y: 924), options: [])

func glow(_ x: Double, _ y: Double, _ r: Double, _ red: Double, _ green: Double, _ blue: Double, _ a: Double) {
    let g = CGGradient(colorsSpace: space, colors: [
        CGColor(red: red, green: green, blue: blue, alpha: a),
        CGColor(red: red, green: green, blue: blue, alpha: 0),
    ] as CFArray, locations: [0, 1])!
    ctx.drawRadialGradient(g, startCenter: CGPoint(x: x, y: y), startRadius: 0,
                           endCenter: CGPoint(x: x, y: y), endRadius: r, options: [])
}
glow(470, 470, 380, 0.85, 0.15, 0.35, 0.75)
glow(600, 560, 300, 0.35, 0.30, 0.95, 0.65)
glow(430, 400, 180, 1.00, 0.55, 0.70, 0.70)

// A fixed scatter of small stars, so every build draws the same icon.
var seed: UInt64 = 42
func rand() -> Double {
    seed = seed &* 6364136223846793005 &+ 1442695040888963407
    return Double(seed >> 33) / Double(1 << 31)
}
for _ in 0..<140 {
    let x = 100 + rand() * 824, y = 100 + rand() * 824, r = 1.5 + rand() * 3.5
    ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.4 + rand() * 0.6))
    ctx.fillEllipse(in: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
}

// One bright star with diffraction spikes.
let star = CGPoint(x: 640, y: 640)
glow(star.x, star.y, 120, 0.75, 0.85, 1.0, 0.9)
ctx.setStrokeColor(CGColor(red: 0.9, green: 0.95, blue: 1, alpha: 0.9))
ctx.setLineCap(.round)
for (dx, dy, len) in [(1.0, 0.0, 230.0), (0.0, 1.0, 230.0)] {
    ctx.setLineWidth(6)
    ctx.move(to: CGPoint(x: star.x - dx * len, y: star.y - dy * len))
    ctx.addLine(to: CGPoint(x: star.x + dx * len, y: star.y + dy * len))
    ctx.strokePath()
}
ctx.setFillColor(.white)
ctx.fillEllipse(in: CGRect(x: star.x - 22, y: star.y - 22, width: 44, height: 44))

image.unlockFocus()
let rep = NSBitmapImageRep(data: image.tiffRepresentation!)!
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
