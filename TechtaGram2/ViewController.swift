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
    var imageNameArray: [String] = ["bear","panda","lion","pig","sheep","owl"]
    var imageIndex: Int = 0
    
    @IBOutlet weak var haikeiImageView: UIImageView!
    
    var imageView: UIImageView! //スタンプ画像が入るImageView
    
    var originalImage: UIImage!  //画像加工するための元となる画像
    var filter: CIFilter!  //画像加工するフィルターの宣言
    
    //サウンドファイルの設定
    var soundNameArray: [String] = ["drumSound","pianoSound","pianoSound","pianoSound","pianoSound","pianoSound"]
    
    var SoundPlayer: AVAudioPlayer!
    
    
    
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
            
            //音を鳴らす
            soundPlay()
        }
    }
    
    func soundPlay() {
        //サウンドファイルを読み込んで、プレイヤーを作る
        SoundPlayer = try! AVAudioPlayer(data: NSDataAsset(name: soundNameArray[imageIndex - 1])!.data)
        //ドラムの音を巻き戻す
        SoundPlayer.currentTime = 0
        
        //音を再生する
        SoundPlayer.play()
    }
    
    
    @IBAction func selectedFirst() {
        imageIndex = 1
    }
    
    @IBAction func selectedSecond() {
        imageIndex = 2
    }
    
    @IBAction func selectedThird() {
        imageIndex = 3
    }
    
    @IBAction func selectedForth() {
        imageIndex = 4
    }
    
    @IBAction func selectedFifth() {
        imageIndex = 5
    }
    
    @IBAction func selectedSixth() {
        imageIndex = 6
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
        
        //加工する前の画像をhaikeiimageに
        originalImage = haikeiImageView.image
        
        //フォトライブラリを閉じる
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func colorFilter() {

        let filterImage: CIImage = CIImage(image: originalImage)!
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)

        filter.setValue(1.0, forKey: "inputSaturation")
        filter.setValue(0.5, forKey: "inputBrightness")
        filter.setValue(2.5, forKey: "inputContrast")

        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        //haikeiImageViewに加工した画像を表示
        haikeiImageView.image = UIImage(cgImage: cgImage!)
    }
    
    @IBAction func sharePhoto() {
        //投稿する時に一緒に載せるコメント
        let shareText = "写真加工したよーーーーん"
        
        let capture = UIGraphicsGetImageFromCurrentImageContext()
        //投稿する画像の選択
        let shareImage = capture
        
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func savePhoto() {
        //画面上のスクリーンショットを取得
        let rect:CGRect = CGRect(x: 0, y: 30, width: 320, height: 380)
        UIGraphicsBeginImageContext(rect.size)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let capture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //フォトライブラリに保存
        UIImageWriteToSavedPhotosAlbum(capture!, nil, nil, nil)
    }


}

