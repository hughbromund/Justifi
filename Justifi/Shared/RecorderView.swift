//
//  RecorderView.swift
//  Justifi
//
//  Created by Hugh Bromund on 1/23/21.
//

import SwiftUI
import CameraManager
import Request
import Json

struct RecorderView: View {
    @Binding var postUsername : String
    @Binding  var accessToken: String
    
    @Binding var commentUploadSheet : Bool
    
    var commentVideoUID : String
    
    
    @State var cameraManager: CameraManager?
    @State var capturedImage: UIImage?
    @State var firstLoad: Bool = true
    @State var isRecording: Bool = false
    
    @State var showUpload : Bool = false
    @State var uploadURL : URL = URL(string: "https://hughbromund.com")!
    
    var body: some View {
        ZStack {
            if cameraManager !== nil {
                ZStack {
                    VStack {
                        CameraView(image: self.$capturedImage, cameraManager: self.cameraManager)
                    }.onTapGesture(count: 2) {
                        if (self.cameraManager?.cameraDevice == .front) {
                            print("Flipping Camera to BACK")
                            self.cameraManager?.cameraDevice = .back
                        } else {
                            print("Flipping Camera to FRONT")
                            self.cameraManager?.cameraDevice = .front
                        }
                    }
                    VStack {
                        Spacer()
                        Image(systemName: isRecording ? "record.circle.fill" : "record.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .foregroundColor(.red)
//                            .animation(.spring())
                            .onTapGesture {
                                print("isRecording \(isRecording)")
                                if (isRecording) {
                                    isRecording = false
                                    cameraManager?.stopVideoRecording({ (videoURL, recordError) -> Void in
                                        guard let videoURL = videoURL else {
                                            //Handle error of no recorded video URL
                                            return
                                        }
                                        do {
                                            print("Captured Video URL \(videoURL)")
                                            showUpload = true
                                            uploadURL = videoURL
                                            return
                                        }
                               
                                    })
                                } else {
                                    cameraManager?.startRecordingVideo()
                                    isRecording = true
                                }
                            }.sheet(isPresented: $showUpload, content: {
                                PostView(postURL: $uploadURL, postUsername: $postUsername, accessToken: $accessToken, showUpload: $showUpload, commentUploadSheet: $commentUploadSheet, commentVideoUID: commentVideoUID)
                            })
                            .padding()
                }
                }
            }
        }.onAppear{
            if (firstLoad) {
                self.cameraManager = CameraManager()
            }
            //
            
            self.cameraManager?.cameraDevice = .back
            cameraManager?.cameraOutputMode = .videoWithMic
            cameraManager?.shouldEnableTapToFocus = false
            cameraManager?.shouldEnablePinchToZoom = false
            cameraManager?.shouldEnableExposure = false
            cameraManager?.cameraOutputQuality = .high
            // self.cameraManager?.startRecordingVideo()
            //print(self.cameraManager?.currentCameraStatus())
            if (!firstLoad) {
                print("resuming capture session")
                cameraManager?.resumeCaptureSession()
            }
            firstLoad = false
        }.onDisappear{
            self.cameraManager?.stopCaptureSession()
            // self.cameraManager = nil
            // self.capturedImage = nil
        }
    }
}


struct CameraView : UIViewControllerRepresentable {
  
    @Binding var image : UIImage?
    let cameraManager : CameraManager?

    func makeUIViewController(context: Context) -> CMViewController {
        print("Making UI View Controller")
        let vc = CMViewController(camera: cameraManager!.cameraDevice, coordinator: context.coordinator)
        return vc
    }
    func updateUIViewController(_ uiViewController: CMViewController, context: Context) {
        print("Updated")
        // uiViewController.delete(nil)
        // uiViewController.setCamera(cameraManager!.cameraDevice)
        // uiViewController.viewDidLoad()
    }
    func makeCoordinator() -> Coordinator {
        //
        let coordinator = Coordinator(cameraManager : self.cameraManager ?? CameraManager())
         
        return coordinator
    }
    

    class Coordinator : NSObject {
        init(cameraManager: CameraManager) {
            self.cameraManager = cameraManager
        }
        
        let cameraManager : CameraManager
    }
    
    class CMViewController : UIViewController {

        let coordinator : Coordinator
        
        init(camera :  CameraDevice, coordinator : Coordinator) {
            self.coordinator = coordinator

            super.init(nibName: nil, bundle: nil)
            self.setCamera(camera)
        }
        func setCamera(_ camera : CameraDevice ){
            self.coordinator.cameraManager.cameraDevice = camera
            self.coordinator.cameraManager.writeFilesToPhoneLibrary = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            // self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

            self.coordinator.cameraManager.addLayerPreviewToView(self.view, newCameraOutputMode: .videoWithMic) {
                print("CMViewController DONE")
            }
        }
    }
    
}

struct RecorderView_Previews: PreviewProvider {
    @State static var tempUsername : String = "HughBromund"
    @State static var tempToken : String = "HughBromund"
    @State static var tempBool : Bool = false
    
    static var previews: some View {
        RecorderView(postUsername: $tempUsername, accessToken: $tempToken, commentUploadSheet: $tempBool, commentVideoUID: "hello")
    }
}
