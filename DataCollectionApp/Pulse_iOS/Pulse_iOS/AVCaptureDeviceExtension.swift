import AVFoundation

extension AVCaptureDevice {

  /// <#Description#>
  ///
  /// - Parameter preferredFps: <#preferredFps description#>
  /// - Returns: <#return value description#>
  private func availableFormatsFor(preferredFps: Float64) -> [AVCaptureDevice.Format] {
    guard let formats = self.formats as? [AVCaptureDevice.Format] else { return [] }
    let availableFormats = formats.filter {
      guard let ranges = $0.videoSupportedFrameRateRanges as? [AVFrameRateRange] else { return false }
      let validRanges = ranges.filter({ $0.minFrameRate <= preferredFps && preferredFps <= $0.maxFrameRate })
      return validRanges.count > 0
    }
    return availableFormats
  }

  /// <#Description#>
  ///
  /// - Parameter availableFormats: <#availableFormats description#>
  /// - Returns: <#return value description#>
  private func formatWithHighestResolution(
    _ availableFormats: [AVCaptureDevice.Format]
  ) -> AVCaptureDevice.Format? {
    var maxWidth: Int32 = 0
    var selectedFormat: AVCaptureDevice.Format?
    for format in availableFormats {
      let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
      let width = dimensions.width
      if width >= maxWidth {
        maxWidth = width
        selectedFormat = format
      }
    }
    return selectedFormat
  }

  /// <#Description#>
  ///
  /// - Parameters:
  ///   - preferredSize: <#preferredSize description#>
  ///   - availableFormats: <#availableFormats description#>
  /// - Returns: <#return value description#>
  private func formatFor(
    preferredSize: CGSize,
    availableFormats: [AVCaptureDevice.Format]
  ) -> AVCaptureDevice.Format? {
    return availableFormats.filter({
      let size = CMVideoFormatDescriptionGetDimensions($0.formatDescription)
      return size.width >= Int32(preferredSize.width) && size.height >= Int32(preferredSize.height)
    }).first
  }

  /// <#Description#>
  ///
  /// - Parameter preferredSpec: <#preferredSpec description#>
  public func updateFormatWithPreferredCaptureSessionSpec(preferredSpec: CaptureSessionSpec) {
    let availableFormats: [AVCaptureDevice.Format]
    availableFormats = availableFormatsFor(preferredFps: Float64(preferredSpec.fps))

    var format: AVCaptureDevice.Format?
    format = formatFor(preferredSize: preferredSpec.size, availableFormats: availableFormats)

    guard let selectedFormat = format else {return}
    print("selected format: \(selectedFormat)")
    do {
      try lockForConfiguration()
    } catch {
      fatalError("")
    }
    activeFormat = selectedFormat

    activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: preferredSpec.fps)
    activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: preferredSpec.fps)
    unlockForConfiguration()
  }
}
