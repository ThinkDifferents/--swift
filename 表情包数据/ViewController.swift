//
//  ViewController.swift
//  表情包数据
//
//  Created by shiwei on 17/5/25.
//  Copyright © 2017年 shiwei. All rights reserved.
//

import UIKit

// 黄色文件夹打包的时候不会建立目录 - 素材不予许重名

// 蓝色文件夹打包的时候会创建目录, 可以分目录的存储素材文件 - 素材可以重名
// 适用于游戏的场景
// 手机应用的皮肤: 白天/夜间模式
// 切记不要把程序文件放在蓝色的文件夹中

// bundle
// 通常用在第三方框架的素材,可以按照黄色文件夹的方式拖拽,同时会保留目录结构
// 可以避免文件重名


class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let string = "我[爱你]啊[笑哈哈]"
        label.attributedText =  SWEmotionManager.shared.emotionString(string: string, font: label.font)
        
    }
    
    func emotionString(string: String) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: string)
        
        // 简历正则, 过滤所有表情文字
        let patter = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: patter, options: []) else {
            return attrString
        }

        // 匹配所有项
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        for m in matches.reversed() {
            let r = m.rangeAt(0)
            let subStr = (attrString.string as NSString).substring(with: r)
            
            // 使用 subStr 查找对应的表情符号
            if let em = SWEmotionManager.shared.findEmotion(string: subStr) {
            
                // 使用表情符号中的属性文本替换原有的属性文本的内容
                attrString.replaceCharacters(in: r, with: em.imageText(font: label.font))
            }
        }
            
        
        return attrString
        
        
    }
    
    func demo() -> () {
        
        print(SWEmotionManager.shared.packages.last?.emotions.last?.image ?? UIImage())
        
        print(SWEmotionManager.shared.findEmotion(string: "[爱你]") ?? SWEmoticion())
        
        let em = SWEmotionManager.shared.findEmotion(string: "[马上有对象]")
        label.attributedText = em?.imageText(font: label.font)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

