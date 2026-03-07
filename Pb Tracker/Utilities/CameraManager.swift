import AVFoundation
import Observation

@Observable
final class CameraManager: NSObject {
    var session = AVCaptureSession()
    var capturedData: Data?
    var isConfigured = false
    
    private let output = AVCapturePhotoOutput()
    private let sessionQueue = DispatchQueue(label: "com.pb-tracker.camera-queue")

    func setup() {
        guard !isConfigured else { return }
        
        sessionQueue.async {
            self.session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device) else { return }
            
            if self.session.canAddInput(input) { self.session.addInput(input) }
            if self.session.canAddOutput(self.output) { self.session.addOutput(self.output) }
            
            self.session.sessionPreset = .photo
            self.session.commitConfiguration()
            
            self.session.startRunning()
            self.isConfigured = true
        }
    }

    func capture() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { return }
        self.capturedData = photo.fileDataRepresentation()
    }
}
