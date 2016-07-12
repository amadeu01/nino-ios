//
//  MD5.swift
//  Nino
//
//  Created by Danilo Becke on 12/07/16.
//  Copyright © 2016 Danilo Becke. All rights reserved.
//

import UIKit

class MD5: NSObject {

    static func digest(string: String) -> String? {
        
        guard let data = string.dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
        
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        
        CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        
        return (0..<Int(CC_MD5_DIGEST_LENGTH)).reduce("") { $0 + String(format: "%02x", digest[$1]) }
    }
    
}
