//
//  ViewController.swift
//  TechtaGram2
//
//  Created by Yamamoto Miu on 2020/09/23.
//  Copyright © 2020 Yamamoto Miu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //スタンプボタンの設定
    var imageNameArray: [String] = ["drumImage","pianoImage"]
    var imageIndex: Int = 0
    
    @IBOutlet weak var haikeiImageView: UIImageView!
    
    var imageView: UIImageView! //スタンプ画像が入るImageView
    
    var filter: CIFilter!  //画像加工するフィルターの宣言
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //タッチされた位置を取得
        let touch: UITouch = touches.first!
        let location: CGPoint = touch.location(in: self.view)
        
        if imageIndex != 0 {
            //スタンプサイズの設定
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            
            //押されたスタンプの画像を設定
            let image: UIImage = UIImage(named: imageNameArray[imageIndex - 1])!
            imageView.image = image
            
            //タッチされた位置に画像をおく
            imageView.center = CGPoint(x: location.x, y: location.y)
            
            //画像を表示する
            self.view.addSubview(imageView)
        }
    }
    
    func soundPlay() {
        //サウンドファイルを読み込んでプレイヤーを作る
        var soundNameArray: [String] = ["drumSound","pianoSound"]
        let SoundPlayer = try!AVAudioPlayer(data: NSDataAsset(name: soundNameArray[imageIndex - 1 ])!.data)

        SoundPlayer.currentTime = 0
        SoundPlayer.play()
    }
    
    @IBAction func selectedFirst() {
        imageIndex = 1
        soundPlay()
    }
    
    @IBAction func selectedSecond() {
        imageIndex = 2
    }


    @IBAction func openAlbum() {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        //フォトライブラリを使う設定をする
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        //フォトライブラリを呼び出す
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //haikeiImageに選んだ画像を設定する
        let haikeiImage = info[.originalImage] as? UIImage
        
        //haikeiImageを背景に設定する
        haikeiImageView.image = haikeiImage
        
        //フォトライブラリを閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func colorFilter() {
//
//        //フィルターの設定
//        filter = CIFilter(name: <#T##String#>)
//        filter.setValue(<#T##value: Any?##Any?#>, forKey: kCIInputImageKey)
//
//        filter.setValue(1.0, forKey: "inputSaturation")
//        filter.setValue(0.5, forKey: "inputBrightness")
//        filter.setValue(2.5, forKey: "inputContrast")
//
//        let ctx = CIContext(options: nil)
//        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
//        heikeiImageView.image = UIImage(cgImage: cgImage!)
//
//
//    }
    
    @IBAction func sharePhoto() {
        
    }
    
    @IBAction func savePhoto() {
        
    }


}

