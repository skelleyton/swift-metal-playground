//
//  AppDelegate.swift
//  nudude
//
//  Created by Damon Kelley on 8/3/26.
//

import Foundation
import AppKit
import Metal
import MetalKit
import os

@main
public class AppDelegate: NSObject, NSApplicationDelegate {
  let logger = Logger(subsystem: "org.kelleynet.nudude", category: "AppDelegate")

  public static func main() {
    let delegate = AppDelegate()
    NSApplication.shared.delegate = delegate
    NSApp.run()
  }

  public func applicationDidFinishLaunching(_ notification: Notification) {
    logger.info("RUNNING")
    let windowFrame = CGRect(
      origin: CGPoint(x: 100, y: 100),
      size: CGSize(width: 200, height: 200)
    )
    let view = MTKView(frame: windowFrame)
    view.device = MTLCreateSystemDefaultDevice()

    view.clearColor = MTLClearColor(red: 0, green: 1, blue: 0, alpha: 1)
    view.enableSetNeedsDisplay = true

    let mtkDelegate = MTKDelegate()
    view.delegate = mtkDelegate

    let window = NSWindow(
      contentRect: windowFrame,
      styleMask: NSWindow.StyleMask(arrayLiteral: [.titled, .closable]),
      backing: .buffered,
      defer: false,
    )

    window.makeKeyAndOrderFront(nil)

    mtkDelegate.draw(in: view)
  }

  public func applicationWillFinishLaunching(_ notification: Notification) {


  }

  public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    false
  }
}
