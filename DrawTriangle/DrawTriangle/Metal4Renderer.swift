//
//  Metal4Renderer.swift
//  nudude
//
//  Created by Damon Kelley on 8/7/26.
//

import Foundation
import Metal
import MetalKit
import OSLog

@available(macOS 26.0, *)
class Metal4Renderer {
  var device: MTLDevice
  var commandQueue: MTL4CommandQueue
  var commandBuffer: MTL4CommandBuffer
  var defaultLibrary: MTLLibrary

  let kMaxFramesInFlight: Int = 3

  var triangleVertexBuffers: [MTLBuffer]

  @MainActor
  init(view: MTKView) {
    self.device = view.device!
    commandQueue = device.makeMTL4CommandQueue()!
    commandBuffer = device.makeCommandBuffer()!

    defaultLibrary = device.makeDefaultLibrary()!

    triangleVertexBuffers = self.makeTriangleDataBuffers(kMaxFramesInFlight)
    let argumentTable = self.makeArgumentTable()
    let residencySet = self.makeResidencySet(device)!
    let commandAllocators = self.makeCommandAllocators(kMaxFramesInFlight)

    let viewportSizeBuffer = self.device.makeBuffer(
      length: 10,
      options: .storageModeShared
    )

    let frameNumber: UInt64 = 0

    let sharedEvent = device.makeSharedEvent()!
    sharedEvent.signaledValue = frameNumber

    residencySet.addAllocation(viewportSizeBuffer!)

    for buffer in triangleVertexBuffers {
      residencySet.addAllocation(buffer)
    }

    residencySet.commit()
    commandQueue.addResidencySet(residencySet)
    if let layer = view.layer as? CAMetalLayer {
      commandQueue.addResidencySet(layer.residencySet)
    }

    updateViewportSize(view.drawableSize)
  }

  private func makeTriangleDataBuffers(_ count: Int) -> [MTLBuffer] {
    var bufferArray: [MTLBuffer] = []

    for index in 0..<count {
      var buffer: MTLBuffer

      buffer = self.device.makeBuffer(length: 10, options: .storageModeShared)!

//      self.check:buffer(name: buffer, number: bufferArray.count, error:nil)
      bufferArray.append(buffer)
    }

    return bufferArray
  }

  private func makeArgumentTable() -> MTL4ArgumentTable {
    var localError: NSError? = nil;

    let argumentTableDescriptor = MTL4ArgumentTableDescriptor()
    argumentTableDescriptor.maxBufferBindCount = 2

    var argumentTable: MTL4ArgumentTable

    do {
     argumentTable = try device.makeArgumentTable(
        descriptor: argumentTableDescriptor
      )
      return argumentTable
    } catch {
      localError = error as NSError
      Logger().error("\(localError)")
    }

//    self check:argumentTable( name: "argument table" number: -1 error: localError)

    return argumentTable
  }

  private func makeResidencySet(_ device: MTLDevice) -> MTLResidencySet? {
    let descriptor = MTLResidencySetDescriptor()
    do {
      try device.makeResidencySet(descriptor: descriptor)
    } catch {
      Logger().info("We made an error")
    }

  }

  private func makeCommandAllocators(_ kMaxFramesInFlight: Int) {}

  private func updateViewportSize(_ size: CGSize) {}

  private func compileRenderPipeline(_ colorPixelFormat: MTLPixelFormat) -> MTLRenderPipelineState {
  }
}

@available(macOS 26.0, *)
final class M4Compiler: NSObject, MTL4Compiler {
  let device: MTLDevice
  let label: String?
  let pipelineDataSetSerializer: (any MTL4PipelineDataSetSerializer)?

  init(device: MTLDevice, label: String?) {
    self.device = device
    self.label = label
  }

  func makeLibrary(descriptor: MTL4LibraryDescriptor) throws -> any MTLLibrary {
    // Unused
  }
  func makeDynamicLibrary(url: URL) throws -> any MTLDynamicLibrary {
    // Unused
  }

  func makeDynamicLibrary(library: any MTLLibrary) throws -> any MTLDynamicLibrary {
    // Unused
  }

  func makeRenderPipelineState(
    descriptor: MTL4RenderPipelineDescriptor,
    compilerTaskOptions: MTL4CompilerTaskOptions
  ) throws -> MTLRenderPipelineState {

  }
}

@available(macOS 26.0, *)
extension M4Compiler {
}
