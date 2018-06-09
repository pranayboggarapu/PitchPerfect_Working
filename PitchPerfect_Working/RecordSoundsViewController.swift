//
//  RecordSoundsViewController.swift
//  PitchPerfect_Working
//
//  Created by Sai Venkata Pranay Boggarapu on 5/20/18.
//  Copyright © 2018 Sai Venkata Pranay Boggarapu. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordLabel: UILabel!
    
    @IBOutlet weak var stopRecordButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordLabel.text = "Press here to record!!"
        
    }

    //MARK:- Function to record the audio
    @IBAction func recordAudio(_ sender: Any) {
        
        //MARK: changing the button states and the title
        configureUI(true)
        
        //MARK: creating the path URL to store the audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = URL(fileURLWithPath: pathArray.joined(separator: "/"))
        
        //MARK:  Creating AVAudioSession instance to do the recording
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        
        //MARK: in order to conform to AVAudioRecorderDelegate
        audioRecorder.delegate = self
        
        //MARK: calling the record functions
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    //MARK:- FUnction to stop recording
    @IBAction func stopRecording(_ sender: Any) {
        
        //MARK: Changing the button states and label
        configureUI(false)
        
        //MARK: Stopping the recorder
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    //MARK:- segue function for next screen
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            //print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(_ uiState: Bool) {
        if uiState {
            stopRecordButton.isEnabled = uiState
            recordLabel.text = "Recording in Progress"
            recordButton.isEnabled = !uiState
        } else {
            recordLabel.text = "Recording stopped"
            recordButton.isEnabled = !uiState
            stopRecordButton.isEnabled = uiState
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            
        }
    }
}

