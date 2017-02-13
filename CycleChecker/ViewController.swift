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
    
    var tapCounter: Int = 0
    
    var timer: Timer!

    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Konashi接続
        // http://konashi.ux-xu.com/documents/#base-findWithName
        // findWithName で名前を指定して、自動で設定
        Konashi.find(withName: "konashi2-f02774")

        // 画像配列を設定
        img = [UIImage(named:"level-0")!,
               UIImage(named:"level-1")!,
               UIImage(named:"level-2")!,
               UIImage(named:"level-3")!,
               UIImage(named:"level-21")!
            ]
        
        // UIImageViewにUIIimageを追加
        imageView01 = [UIImageView(image:img[0]),
                       UIImageView(image:img[1]),
                       UIImageView(image:img[2]),
                       UIImageView(image:img[3]),
                       UIImageView(image:img[4])
        ]

        // 全体のサイズ ScrollViewフレームサイズ取得
        let SVSize = scrView.frame.size

        // 画像サイズ x 3　高さ CGSizeMake(240*3, 240)
        scrView.contentSize =
            CGSize(width: SVSize.width * CGFloat(img.count), height: SVSize.height)
        
        //UIImageViewのサイズと位置を決める
        //左右に並べる
        for i in 0...4 {
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
            } else if i == 5 {
                x = 375 * 5
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
        
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture(sender:)))
        // 2本指でスワイプ
        swipeGesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(swipeGesture)
        
        let twoTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTwoTap(sender:)))
        twoTapGesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(twoTapGesture)

        // 4本指でスワイプ
        let swipeFourGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeFourGesture(sender:)))
        swipeFourGesture.numberOfTouchesRequired = 4
        self.view.addGestureRecognizer(swipeFourGesture)
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
            
            if level == 0 {
                // level 0
            } else if (level >= 1 && level < 4) {
                Konashi.pinModeAll(0xFF)
                Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.high)
            } else if (level >= 4 && level < 7) {
                Konashi.pinModeAll(0xFF)
                Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.high)
                Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO1, value: KonashiLevel.high)
            } else if level >= 7 {
                Konashi.pinModeAll(0xFF)
                Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.high)
                Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO1, value: KonashiLevel.high)
                Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO2, value: KonashiLevel.high)
                Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO3, value: KonashiLevel.high)
            }
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
        } else if (level >= 4 && level < 7) {
            print("----- level 2 -----")
            scrView.setContentOffset(CGPoint(x: 375 * 2, y: 0), animated: true)
        } else if level >= 7 {
            print("----- level 3 -----")
            scrView.setContentOffset(CGPoint(x: 375 * 3, y: 0), animated: true)
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
        if timer != nil {
            if timer.isValid == true {
                timer.invalidate()
            }
        }
    }
    
    // 4本指でスワイプすることでLevel21
    func swipeFourGesture(sender: UISwipeGestureRecognizer) {
        print("Swipe four fingers!!!!!")
        print("----- level 21 !!! -----")
        scrView.setContentOffset(CGPoint(x: 375 * 4, y: 0), animated: true)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.lightning), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    // 2本指でタップ
    func handleTwoTap(sender: UITapGestureRecognizer) {
        print("two Tapped!!!")
        Konashi.pinModeAll(0xFF)
        Konashi.digitalWriteAll(0x00)
        lightning()
    }
    
    func lightning() {
        if tapCounter % 4 == 0 {
            print("----- % 4 == 0 -----")
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO1, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO2, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO3, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO4, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO5, value: KonashiLevel.high)
        } else if tapCounter % 4 == 1 {
            print("----- % 4 == 1 -----")
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO1, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO2, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO3, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO4, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO5, value: KonashiLevel.low)
            
        } else if tapCounter % 4 == 2 {
            print("----- % 4 == 2 -----")
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO1, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO2, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO3, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO4, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO5, value: KonashiLevel.high)
        } else if tapCounter % 4 == 3 {
            print("----- % 4 == 3 -----")
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO0, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO1, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO2, value: KonashiLevel.high)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO3, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO4, value: KonashiLevel.low)
            Konashi.digitalWrite(KonashiDigitalIOPin.digitalIO5, value: KonashiLevel.high)
        }
        tapCounter = tapCounter + 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
