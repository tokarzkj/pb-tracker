import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var cameraManager = CameraManager()
    @Binding var capturedData: Data?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            CameraPreviewView(session: cameraManager.session)
                .onAppear { cameraManager.setup() }
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button("Cancel") { dismiss() }
                        .buttonStyle(.bordered)
                    Spacer()
                }
                .padding()

                Spacer()

                Button(action: { cameraManager.capture() }) {
                    Circle()
                        .strokeBorder(.white, lineWidth: 3)
                        .background(Circle().fill(.white.opacity(0.4)))
                        .frame(width: 70, height: 70)
                        .glassEffect()
                }
                .accessibilityLabel("Capture Photo")
                .padding(.bottom, 30)
            }
        }
        .onChange(of: cameraManager.capturedData) { oldValue, newData in
            if let newData {
                capturedData = newData
                dismiss()
            }
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.frame = uiView.bounds
        }
    }
}
