//
//  MTKDelegate.swift
//  nudude
//
//  Created by Damon Kelley on 8/7/26.
//

import Foundation
import Metal
import MetalKit

class MTKDelegate: NSObject, MTKViewDelegate {
  let renderer: Metal4Renderer

  init(view: MTKView) {
    renderer = Metal4Renderer(view: view)
  }

  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

  }

  func draw(in view: MTKView) {
    let device = view.device

    guard let device else {
      return
    }

    if #available(macOS 26.0, *) {
      let renderPassDescriptor = view.currentMTL4RenderPassDescriptor
      guard let renderPassDescriptor else {
        return
      }
      setupRenderPipeline(renderPassDescriptor, device)
    } else {
      let renderPassDescriptor = view.currentRenderPassDescriptor
      let commandQueue = device.makeCommandQueue()
      let commandBuffer = commandQueue?.makeCommandBuffer()
    }
  }

  @available(macOS 26.0, *)
  private func setupRenderPipeline(
    _ renderPassDescriptor: MTL4RenderPassDescriptor,
    _ device: MTLDevice
  ) {
    guard let commandBuffer = device.makeCommandBuffer() else {
      return
    }
    commandBuffer.beginCommandBuffer(allocator: <#T##any MTL4CommandAllocator#>)
    commandEncoder.endEncoding()
    commandBuffer.endCommandBuffer()
  }
}
