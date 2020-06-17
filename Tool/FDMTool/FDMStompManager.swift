//
//  FDMStompManager.swift
//  Apple
//
//  Created by 发抖喵 on 2020/3/18.
//  Copyright © 2020 yunzainfo. All rights reserved.
//

// 直播聊天WebSocket

import UIKit
import StompClientLib

class FDMStompManager: NSObject {
    
    var stompUrl: String = ""
    var header: [String: String]?
    let socketClient = StompClientLib()
    
    /// 连接成功回调
    var clientDidConnectBlock: ((StompClientLib) -> ())?
    /// 连接断开回调
    var clientDidDisconnectBlock: ((StompClientLib) -> ())?
    /// 接收到数据回调
    var didReceiveMessageWithStringBlock: ((AnyObject?,String) -> ())?
    
    /// 启动连接
    func startStomp(stompUrl: String, header: [String: String]?) {
        self.stompUrl = stompUrl
        self.header = header
        
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: URL(string: stompUrl)!), delegate: self, connectionHeaders: header)
    }
    
    /// 重新连接
    func reconnectStomp() {
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: URL(string: stompUrl)!), delegate: self, connectionHeaders: header)
    }
    
    /// 断开连接
    func stompDisconnect() {
        socketClient.disconnect()
    }
    
    /// 发送消息
    func sendJson(dict:AnyObject,toDestination:String) {
        socketClient.sendJSONForDict(dict: dict, toDestination: toDestination)
    }
    
}

//MARK: delegate
extension FDMStompManager: StompClientLibDelegate{
    /// 接收到的信息
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        FDMQuick.Log(title: "接收到的信息\(destination)", message: jsonBody)
        
        self.didReceiveMessageWithStringBlock?(jsonBody,destination)
    }
    
    /// 已断开
    func stompClientDidDisconnect(client: StompClientLib!) {
        FDMQuick.Log(title: "已断开", message: "")
        
        self.clientDidDisconnectBlock?(client)
    }
    
    /// 已连接
    func stompClientDidConnect(client: StompClientLib!) {
        FDMQuick.Log(title: "已连接", message: "")
        
        self.clientDidConnectBlock?(client)
    }
    
    /// 如果您将使用STOMP进行应用内购买，则可能需要使用此功能来获取收据
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        FDMQuick.Log(title: "使用STOMP进行应用内购买", message: receiptId)
    }
    
    /// 您的错误信息将通过此功能接收
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        FDMQuick.Log(title: "您的错误信息将通过此功能接收", message: description)
    }
    
    /// 如果您需要控制服务器的ping操作
    func serverDidSendPing() {
        
    }
}
