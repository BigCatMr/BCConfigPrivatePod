//
//  BPage_Extension.swift
//
//  Created by MambaYong on 2021/12/7.
//  Copyright © 2021 MambaYong. All rights reserved.
//

import CTMediator

fileprivate let ModuleName = "__ProjectName__"

public extension CTMediator {
    func __ProjectName___demo(name:String, callback:@escaping (String)->Void) -> UIViewController? {
        let params:[AnyHashable:Any] = [
            "name": name,
            "callback": callback,
            kCTMediatorParamsKeySwiftTargetModuleName: ModuleName
        ]
        if let viewController = performTarget(ModuleName, action: "demo", params: params, shouldCacheTarget: false) as? UIViewController {
            return viewController
        }
        return nil
    }
}
