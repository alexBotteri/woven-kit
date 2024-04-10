import Foundation
import AVFoundation

public final class MicrophoneLevels: ObservableObject {
    @Published public var currentLevel: Double = 0
    private var audioRecorder: AVAudioRecorder!
    
    public init() {}
    
    public func setUp() {
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    fatalError("You must allow audio recording for this demo to work")
                }
            }
        }
        
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func start() {
        guard audioRecorder != nil else { return }
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
    }
    
    public func updateLevels() {
        guard audioRecorder != nil else { return }
        audioRecorder.updateMeters()
        currentLevel = min(Double(audioRecorder.averagePower(forChannel: 0))/80.0, 1.0)
    }
    
    deinit {
        audioRecorder.stop()
    }
}


