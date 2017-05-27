//
//  SWEmotionManager.swift
//  表情包数据
//
//  Created by shiwei on 17/5/25.
//  Copyright © 2017年 shiwei. All rights reserved.
//

import UIKit

/// 表情管理器
class SWEmotionManager {
    
    // 为了便于表情的复用, 建立一个单利, 只加载一次表情数据
    // 表情管理器的单例
    static let shared = SWEmotionManager()
    
    /// 表情包的懒加载数组
    lazy var packages = [SWEmotionPackage]()
    
    /// 构造函数, 如果在init 之前增加 pricate 修饰符, 可以要求调用者必须通过 shared 访问对象
    private init() {
        loadPackages()
    }
    
    // 表情包数据处理
    private func loadPackages() {
        // 读取plist
        guard let path = Bundle.main.path(forResource: "EmotionIcons.bundle", ofType: nil),
            
            let bundle = Bundle(path: path),
        
            // 前面的目录一律省略
            let plistPath = bundle.path(forResource: "emotions.plist", ofType: nil),
        
            let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
        
            
            let models = NSArray.yy_modelArray(with: SWEmotionPackage.self, json: array) as? [SWEmotionPackage]
            
            else {
                return
        }
        
        // 设置表情包数据
        packages += models
//        print(packages)
        
    }
    
    func emotionString(string: String, font: UIFont) -> NSAttributedString {
        
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
                attrString.replaceCharacters(in: r, with: em.imageText(font: font))
            }
        }
        
        // 统一设置一遍字符串的属性
        attrString.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: attrString.length))
        return attrString
        
        
    }

    
    // 表情符号处理
    /// 根据string 在所有的表情符号中查找对应的表情模型对象
    ///
    /// - 找到 返回表情模型
    /// - 否则 返回 nil
    func findEmotion(string: String) -> SWEmoticion? {
        
        // 遍历表情包
        for p in packages {
            
            // 过滤string
//            let result = p.emotions.filter({ (em) -> Bool in
//                return em.chs == string
//            })
            
            // 方法2 尾随闭包
//            let result = p.emotions.filter() {
//                return $0.chs == string
//            }
            
            let result = p.emotions.filter() { $0.chs == string }
            
            // 判断结果数量的数组
            if result.count == 1 {
                return result[0]
            }
        }
        return nil
    }
    
}
