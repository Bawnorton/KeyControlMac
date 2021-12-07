//
//  ViewController.swift
//  KeyControlSBMac
//
//  Created by Benjamin Norton on 2021-12-05.
//

import Cocoa
import MultipeerConnectivity
import Foundation

struct Global {
    static var peerID: MCPeerID!
    static var session: MCSession!
    static var connected: Bool!
}

class ViewController: NSViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var timer = Timer()
    var keyController = KeyboardControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConnectivity()
    }
    
    static func newInstance() -> ViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("ViewController")
        
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Cannot create view controller")
        }
        return viewcontroller
    }
    
    func setupConnectivity() {
        Global.peerID = MCPeerID(displayName: Host.current().name!)
        Global.session = MCSession(peer: Global.peerID, securityIdentity: nil, encryptionPreference: .required)
        Global.session.delegate = self
    }

    func startBrowser() -> MCBrowserViewController {
        let browser = MCBrowserViewController(serviceType: "key-transfer", session: Global.session)
        browser.delegate = self
        return browser
    }
    
    override var representedObject: Any? {
        didSet {
        
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            Global.connected = true
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            Global.connected = false
        @unknown default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let keyCode: UInt8 = data.first!
        let pressed: UInt8 = data.last!
        self.keyController.keyAction(KeyID: Int(keyCode), pressed: Int(pressed))
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        presentedViewControllers![0].dismiss(MCBrowserViewController.self)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        presentedViewControllers![0].dismiss(MCBrowserViewController.self)
    }

}

