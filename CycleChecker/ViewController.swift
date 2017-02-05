//
//  ViewController.swift
//  CycleChecker
//
//  Created by usr0600244 on 2017/01/04.
//  Copyright © 2017年 org.mo-fu. All rights reserved.
//

import UIKit
import konashi_ios_sdk
import APIKit
import AudioToolbox

class ViewController: UIViewController, UIScrollViewDelegate {
    var img: [UIImage] = []
    var imageView01: [UIImageView?] = []
    
    var level = 0

    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Konashi接続
        // http://konashi.ux-xu.com/documents/#base-findWithName
        // findWithName で名前を指定して、自動で設定
        Konashi.find(withName: "konashi2-f02774")

        // 画像配列を設定
        img = [UIImage(named:"LEVEL0")!,
               UIImage(named:"LEVEL1")!,
               UIImage(named:"LEVEL2")!,
               UIImage(named:"LEVEL3")!
            ]
        
        // UIImageViewにUIIimageを追加
        imageView01 = [UIImageView(image:img[0]),
                       UIImageView(image:img[1]),
                       UIImageView(image:img[2]),
                       UIImageView(image:img[3])
        ]

        // 全体のサイズ ScrollViewフレームサイズ取得
        let SVSize = scrView.frame.size
        // 画像サイズ x 3　高さ CGSizeMake(240*3, 240)
        scrView.contentSize =
            CGSize(width: SVSize.width * CGFloat(img.count), height: SVSize.height)
        
        //UIImageViewのサイズと位置を決める
        //左右に並べる
        for i in 0...3 {
            var x:CGFloat = 0
            let y:CGFloat = 0
            let width:CGFloat = 375
            let height:CGFloat = 667

            if i == 0 {
                //x = 0
            } else if i == 1 {
                x = 375
            } else if i == 2 {
                x = 375 * 2
            } else if i == 3 {
                x = 375 * 3
            } else if i == 4 {
                x = 375 * 4
            }
            
            // Scrollviewに追加
            imageView01[i]!.frame = CGRect(x: x, y: y, width: width, height: height)
            
            // Scrollviewに追加
            scrView.addSubview(imageView01[i]!)
        }
        
        // １ページ単位でスクロールさせる
        scrView.isPagingEnabled = true
        
        //scroll画面の初期位置
        scrView.contentOffset = CGPoint(x: 0, y: 0)

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // スワイプ
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(sender:)))
        // 2本指でスワイプ
        swipeGesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    override func viewDidAppear(_ amimated: Bool) {
        // 端末の向きがかわったらNotificationを呼ばす設定
        NotificationCenter.default.addObserver(self, selector: #selector(self.onOrientationChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // 端末の向きがかわったら呼び出される
    func onOrientationChange(notification: NSNotification){
        // 現在のデバイスの向きを取得
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.current.orientation
        if UIDeviceOrientationIsLandscape(deviceOrientation) {
            //横向きの判定、向きに従って位置を調整
            print("landscape!!")
            let soundId: SystemSoundID = 1000
            AudioServicesPlaySystemSound(soundId)
        }
    }
    
    func checkLevel(level: Int) {
        self.level = level
        
        // 参考: http://dev.classmethod.jp/smartphone/ios-systemsound/
        let soundId: SystemSoundID = 1001
        AudioServicesPlaySystemSound(soundId)
        
        Konashi.pinModeAll(0xFF)
        Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.low)

        if level == 0 {
            print("----- level 0 -----")
        } else if (level >= 1 && level < 4) {
            print("----- level 1 -----")
            scrView.setContentOffset(CGPoint(x: 375 * 1, y: 0), animated: true)
            Konashi.pinModeAll(0xFF)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.high)
        } else if (level >= 4 && level < 7) {
            print("----- level 2 -----")
            scrView.setContentOffset(CGPoint(x: 375 * 2, y: 0), animated: true)
            Konashi.pinModeAll(0xFF)
            
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO1, value: KonashiLevel.high)
        } else if level >= 7 {
            print("----- level 3 -----")
            scrView.setContentOffset(CGPoint(x: 375 * 3, y: 0), animated: true)
            Konashi.pinModeAll(0xFF)
            // Konashi.digitalWrite(KonashiDigitalIOPin.LED4, value: KonashiLevel.high)

            // konashi 0 をHIGH
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO1, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO2, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO3, value: KonashiLevel.high)
        }
    }

    // MARK: - Gesture Handlers
    func handleTap(sender: UITapGestureRecognizer) {
        print("Tapped! Level: \(level)")
        let request = CycleChangerApiRequest()

        Session.send(request) { result in
            switch result {
            case .success(let item):
                print("data: \(item)")
                self.checkLevel(level: item.level)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    // 2本指でスワイプすることで全てLowにする
    func swipeGesture(sender: UISwipeGestureRecognizer) {
        print("Swipe!!!!!")
        Konashi.pinModeAll(0xFF)
        Konashi.digitalWriteAll(0x00)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
