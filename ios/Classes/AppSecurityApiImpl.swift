import Foundation
import UIKit
import SystemConfiguration

public class AppSecurityApiImpl: NSObject, AppSecurityApi {
    private let bundle = Bundle.main
    private let fm = FileManager.default

    public func isUseJailBrokenOrRoot() throws -> Bool {
        return detectJailbreak()
    }

    public func isDeviceUseVPN() throws -> Bool {
        return detectVPN()
    }

    public func isItRealDevice() throws -> Bool {
        return !isSimulator()
    }

    public func checkIsTheDeveloperModeOn() throws -> Bool {
        return isDebuggerAttached()
    }

    public func isRunningInTestFlight() throws -> Bool {
        return isTestFlight()
    }

    public func getIMEI() throws -> String? {
        return nil // IMEI not available on iOS
    }

    public func getDeviceId() throws -> String? {
        return identifierForVendor()
    }

    public func installSource() throws -> String? {
        return detectInstallSource()
    }

    public func isSafeEnvironment() throws -> [String]? {
        return buildSafeEnvironmentReasons()
    }

    public func installedFromValidSource(sourceList: [String]) throws -> Bool {
        let src = detectInstallSource() ?? "unknown"
        return sourceList.contains { src.caseInsensitiveCompare($0) == .orderedSame }
    }

    public func isClonedApp() throws -> Bool {
        return detectClone()
    }

    public func openDeveloperSettings() throws -> Bool {
        return false
    }

    public func addFlags(flag: Int) throws -> Bool {
        return false
    }

    public func clearFlags(flag: Int) throws -> Bool {
        return false
    }
}

private extension AppSecurityApiImpl {
    func detectJailbreak() -> Bool {
        if canOpenScheme("cydia://") { return true }

        let suspiciousPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt"
        ]
        for path in suspiciousPaths {
            if FileManager.default.fileExists(atPath: path) { return true }
        }

        let testPath = "/private/jailbreak.txt"
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            return true
        } catch { }

        return false
    }

    func detectVPN() -> Bool {
        var addrList: UnsafeMutablePointer<ifaddrs>? = nil
        defer { if addrList != nil { freeifaddrs(addrList) } }

        if getifaddrs(&addrList) == 0 {
            var ptr = addrList
            while ptr != nil {
                if let name = String(validatingUTF8: ptr!.pointee.ifa_name),
                   name.hasPrefix("utun") || name.hasPrefix("tap") || name.hasPrefix("tun") ||
                   name.contains("ppp") || name.contains("ipsec") {
                    return true
                }
                ptr = ptr!.pointee.ifa_next
            }
        }
        return false
    }

    func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    func isDebuggerAttached() -> Bool {
        var info = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.stride
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]

        let result = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)

        if result != 0 { return false }
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }


    func isTestFlight() -> Bool {
        guard let receiptURL = bundle.appStoreReceiptURL else { return false }
        return receiptURL.lastPathComponent == "sandboxReceipt"
    }

    func identifierForVendor() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

    func detectInstallSource() -> String? {
        if isTestFlight() { return "testflight" }
        if isAppStoreBuild() { return "appstore" }
        if hasEmbeddedProvisioningProfile() { return "enterprise" }
        return "sideload"
    }

    func isAppStoreBuild() -> Bool {
        #if DEBUG
        return false
        #else
        return !hasEmbeddedProvisioningProfile()
        #endif
    }

    func hasEmbeddedProvisioningProfile() -> Bool {
        guard let path = bundle.path(forResource: "embedded", ofType: "mobileprovision") else { return false }
        return fm.fileExists(atPath: path)
    }

    func buildSafeEnvironmentReasons() -> [String] {
        var issues: [String] = []
        if detectJailbreak() { issues.append("JAILBREAK") }
        if detectVPN() { issues.append("VPN_ACTIVE") }
        if isDebuggerAttached() { issues.append("DEBUGGER") }
        if isSimulator() { issues.append("SIMULATOR") }
        return issues
    }

    func detectClone() -> Bool {
        if isSimulator() { return false }
        guard let bundleURL = bundle.bundleURL.absoluteString.removingPercentEncoding else { return false }
        return bundleURL.contains("Containers/Shared/AppGroup") || bundleURL.contains("clone") || bundleURL.contains("dual")
    }

    func canOpenScheme(_ scheme: String) -> Bool {
        guard let url = URL(string: scheme) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}
