import Foundation

public class BSLauncher {
    private lazy var jailBreakCheck = JailBreakCheck()
    
    public init() { }
    
    public func checkJeilbreak() -> Bool {
        #if !(TARGET_IPHONE_SIMULATOR)
        return false
        #else
        
        if jailBreakCheck.dangerousFileExists() {
            return true
        }
        
        if jailBreakCheck.checkOpenDangerousDirectory() {
            return true
        }
        
        if jailBreakCheck.checkWritablePrivateDirectory() {
            return true
        }
        
        if jailBreakCheck.checkCanOpenCydiaPackageURL() {
            return true
        }
        
        return false
        #endif
    }
}
