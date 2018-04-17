//
//  MultipleerCommunicator.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 31.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    private let serviceType = "tinkoff-chat"
    
    let myPeerId = MCPeerID(displayName: (UIDevice.current.identifierForVendor?.uuidString)!)
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    weak var delegate: CommunicatorDelegate?
    var online: Bool
    
    var sessions = [String: MCSession]()
    
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName": UIDevice.current.name], serviceType: serviceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        self.online = true
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
        
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        do {
            if let session = sessions[userID] {
                let id = generateMessageId()
                let data = try JSONSerialization.data(withJSONObject: ["eventType": "TextMessage", "text": string, "messageId": id], options: [])
                try session.send(data, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
                completionHandler?(true, nil)
            } else {
                completionHandler?(false, nil)
            }
            
            
        } catch {
            completionHandler?(false, error)
        }
        
    }
    
    deinit {
        self.serviceBrowser.stopBrowsingForPeers()
        self.serviceAdvertiser.stopAdvertisingPeer()
    }

}

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

protocol CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, sessions[peerID.displayName])
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        
        if let userInfo = info {
            if let userName = userInfo["userName"] {
                print(peerID.displayName)
                if sessions[peerID.displayName] == nil {
                    let session = MCSession(peer: myPeerId)
                    session.delegate = self
                    
                    sessions[peerID.displayName] = session
                    browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
                    delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
                }
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        sessions.removeValue(forKey: peerID.displayName)
        delegate?.didLostUser(userID: peerID.displayName)
        print(peerID.displayName)
    }
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
            
            if let text = json["text"] {
                delegate?.didRecieveMessage(text: text, fromUser: peerID.displayName, toUser: myPeerId.displayName)
            }
            
        } catch {
            print(error)
        }
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
