//
//  SWEmotionPackage.swift
//  表情包数据
//
//  Created by shiwei on 17/5/25.
//  Copyright © 2017年 shiwei. All rights reserved.
//

import UIKit

class SWEmotionPackage: NSObject {
    // 表情包的分组名
    var groupName: String?
    
    // 表情包目录,从目录下载 info.plist 可以创建表情模型数组
    var directory: String? {
        didSet {
            guard let directory = directory,
                
                let path = Bundle.main.path(forResource: "EmotionIcons.bundle", ofType: nil),
            
                let bundle = Bundle(path: path),
                
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                
                let array = NSArray(contentsOfFile: infoPath) as? [[String : String]],
            
                let models = NSArray.yy_modelArray(with: SWEmoticion.self, json: array) as? [SWEmoticion]
            

                
                else {
                return
            }
            // 遍历models数组,设置每一个表情符号的目录
            for m in models {
                m.directory = directory
            }
            
            
            // 设置表情模型数组
            emotions += models
        }
    }
    
    
    /// 懒加载的表情数组
    /// 使用懒加载可以避免后续的解包
    lazy var emotions = [SWEmoticion]()
    
    override var description: String {
        return yy_modelDescription()
    }

}
