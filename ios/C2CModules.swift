@objc(C2CModules)
class C2CModules: NSObject {

    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
