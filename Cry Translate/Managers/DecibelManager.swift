//
//  DecibelManager.swift
//  Cry Translate
//
//  Created by Furkan BEYHAN on 14.08.2023.
//

import AVFoundation

class DecibelManager {
    var audioRecorder: AVAudioRecorder?

    func calculateDecibels(from audioFileURL: URL) -> Float? {
        do {
            let audioData = try Data(contentsOf: audioFileURL)

            var totalPower: Float = 0.0
            let frameCount = Float(audioData.count) / Float(MemoryLayout<Int16>.size)

            for i in 0..<audioData.count / MemoryLayout<Int16>.size {
                var frame: Int16 = 0
                _ = withUnsafeMutableBytes(of: &frame) { bufferPointer in
                    audioData.copyBytes(to: bufferPointer)
                }
                totalPower += powf(Float(frame), 2)
            }

            let meanPower = totalPower / frameCount
            let rms = sqrt(meanPower)

            let decibel = 20 * log10(rms)
            return decibel
        } catch {
            print("Error calculating decibels: \(error)")
            return 0
        }
    }
}
