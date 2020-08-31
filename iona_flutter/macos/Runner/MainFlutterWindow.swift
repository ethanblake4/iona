import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    
    var customToolbar: NSToolbar = NSToolbar(identifier: "coolToolbar");
    
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController.init()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        customToolbar.showsBaselineSeparator = false
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.toolbar = customToolbar
        self.delegate = self


        RegisterGeneratedPlugins(registry: flutterViewController)

        super.awakeFromNib()
    }
}

extension MainFlutterWindow: NSWindowDelegate {
    
    func window(_ window: NSWindow, willUseFullScreenPresentationOptions proposedOptions: NSApplication.PresentationOptions = []) -> NSApplication.PresentationOptions {
        return [.autoHideToolbar, .autoHideMenuBar, .fullScreen]
    }
}
