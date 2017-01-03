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

class ViewController: UIViewController, UIScrollViewDelegate {
    var img: [UIImage] = []
    var imageView01: [UIImageView?] = []
    
    var level = 0

    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // コナシ接続
        // http://konashi.ux-xu.com/documents/#base-findWithName
        // findWithName で名前を指定して、自動で設定
        Konashi.find(withName: "konashi2-f02774")
        
        // LED OFF
        Konashi.pinMode(KonashiDigitalIOPin.LED2, mode: KonashiPinMode.output)
        Konashi.digitalWrite(KonashiDigitalIOPin.LED2, value: KonashiLevel.low)
        Konashi.pinMode(KonashiDigitalIOPin.LED3, mode: KonashiPinMode.output)
        Konashi.digitalWrite(KonashiDigitalIOPin.LED3, value: KonashiLevel.low)
        Konashi.pinMode(KonashiDigitalIOPin.LED4, mode: KonashiPinMode.output)
        Konashi.digitalWrite(KonashiDigitalIOPin.LED4, value: KonashiLevel.low)

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
        
        //UIImageViewのサイズと位置を決めます
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
    }
    
    
    func checkLevel(level: Int) {
        self.level = level
        if level == 0 {
            // level 0
            print("----- level 0 -----")
        } else if (level > 1 && level < 10) {
            print("----- level 1 -----")
            scrView.setContentOffset(CGPoint(x: 375 * 1, y: 0), animated: true)
            Konashi.pinMode(KonashiDigitalIOPin.LED2, mode: KonashiPinMode.output)
            Konashi.digitalWrite(KonashiDigitalIOPin.LED2, value: KonashiLevel.high)
        } else if (level > 10 && level < 20) {
            print("----- level 2 -----")
            scrView.setContentOffset(CGPoint(x: 375 * 2, y: 0), animated: true)
            Konashi.pinMode(KonashiDigitalIOPin.LED2, mode: KonashiPinMode.output)
            Konashi.digitalWrite(KonashiDigitalIOPin.LED2, value: KonashiLevel.high)
            Konashi.pinMode(KonashiDigitalIOPin.LED3, mode: KonashiPinMode.output)
            Konashi.digitalWrite(KonashiDigitalIOPin.LED3, value: KonashiLevel.high)
        } else if level > 20 {
            print("----- level 3 -----")
            scrView.setContentOffset(CGPoint(x: 375 * 3, y: 0), animated: true)
            Konashi.pinMode(KonashiDigitalIOPin.LED2, mode: KonashiPinMode.output)
            Konashi.digitalWrite(KonashiDigitalIOPin.LED2, value: KonashiLevel.high)
            Konashi.pinMode(KonashiDigitalIOPin.LED3, mode: KonashiPinMode.output)
            Konashi.digitalWrite(KonashiDigitalIOPin.LED3, value: KonashiLevel.high)
            Konashi.pinMode(KonashiDigitalIOPin.LED4, mode: KonashiPinMode.output)
            Konashi.digitalWrite(KonashiDigitalIOPin.LED4, value: KonashiLevel.high)
        }
    }

    // MARK: - Gesture Handlers
    func handleTap(sender: UITapGestureRecognizer){
        print("Tapped! Level: \(level)")
        let request = CycleChangerApiRequest()

        Session.send(request) { result in
            switch result {
            case .success(let item):
                print("data: \(item)")
                print(item.items.count)
                self.checkLevel(level: item.items.count)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
