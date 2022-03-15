//
//  JailBreakCheck.swift
//  
//
//  Created by 斉藤　尚也 on 2022/03/15.
//

import Foundation
import UIKit
import Darwin.C

// MEMO: trueが返ってきたら全て脱獄とみなす
final class JailBreakCheck {
    func dangerousFileExists() -> Bool {
        if FileManager.default.fileExists(atPath: "/Application/Cydia.app") {
            return true
        } else if FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
            return true
        } else if FileManager.default.fileExists(atPath: "/bin/bash") {
            return true
        } else if FileManager.default.fileExists(atPath: "/usr/sbin/sshd") {
            return true
        } else if FileManager.default.fileExists(atPath: "/etc/apt") {
            return true
        } else if FileManager.default.fileExists(atPath: "/private/var/lib/apt") {
            return true
        }

        return false
    }
    
    func checkOpenDangerousDirectory() -> Bool {
        var isJailbreak = false
        var file: UnsafeMutablePointer<FILE>?

        let checkUrls: [String] = [
            "/bin/bash",
            "/bin/ssh",
            "/Application/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/usr/sbin/sshd",
            "/etc/apt"
        ]

        for url in checkUrls {
            do {
                defer {
                    fclose(file)
                }

                file = try fopen(path: url)

                defer {
                    if file != nil {
                        isJailbreak = true
                    }
                }
            } catch {}
        }

        return isJailbreak
    }
    
    func checkWritablePrivateDirectory() -> Bool {
        let testText = "This is jailbreak test."
        var isWrote = false

        do {
            try testText.write(toFile: "/private/jailbreak.txt", atomically: true, encoding: String.Encoding.utf8)

            defer {
                try! FileManager.default.removeItem(atPath: "/private/jailbreak.txt")
                isWrote = true
            }
        } catch {}
        
        return isWrote
    }
    
    func checkCanOpenCydiaPackageURL() -> Bool {
        guard let target: URL = URL(string: "cydia://package/com.example.package") else {
            return true
        }
        
        return UIApplication.shared.canOpenURL(target)
    }
    
    private func fopen(path: String) throws -> UnsafeMutablePointer<FILE>? {
        let f = Darwin.fopen(path, "r")
        return f
    }
}
