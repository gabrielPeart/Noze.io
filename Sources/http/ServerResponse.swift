//
//  ServerResponse.swift
//  Noze.io
//
//  Created by Helge Heß on 4/27/16.
//  Copyright © 2016 ZeeZide GmbH. All rights reserved.
//

import core
import streams
import events
import net

/// Created by an http.Server. This represents the write end of a client socket.
///
public class ServerResponse : HTTPMessageWrapper {
  // TODO: trailers
  // TODO: setTimeout(msecs, cb)
  
  override public init(_ stream: WritableByteStreamType) {
    super.init(stream)
    setHeader("Connection", "close") // until we support better
  }
  
  public var statusCode    : Int? = nil
  public var statusMessage : String? = nil
  
  public func writeHead(statusCode: Int, _ statusMessage: String?,
                        _ headers: Dictionary<String, Any> = [:])
  {
    assert(!headersSent)
    
    self.statusCode = statusCode
    if let s = statusMessage { self.statusMessage = s }
    
    // merge in headers
    for (key, value) in headers {
      setHeader(key, value)
    }
    
    _primaryWriteHTTPMessageHead()
  }
  public func writeHead(statusCode: Int, _ h: Dictionary<String, Any> = [:]) {
    // Yup, default args don't do here
    writeHead(statusCode, nil, h)
  }
  
  override func _primaryWriteIntro() {
    if statusCode == nil { statusCode = 200 }
    let msg = statusMessage ?? HTTPStatus.text(forStatus: statusCode!)
    
    _ = self.write("HTTP/1.1 \(statusCode!) \(msg)\r\n")
  }
  
  // TODO: events: finish, close(terminated before end() was called)
}


// MARK: - Swift 3 Helpers

#if swift(>=3.0) // #swift3-1st-arg
public extension ServerResponse {
  // In this case we really want those non-kwarg methods.
  
  public func writeHead(_ s: Int, _ m: String?,
                        _ h: Dictionary<String, Any> = [:])
  {
    writeHead(statusCode: s, m, h)
  }
  public func writeHead(_ s: Int, _ h: Dictionary<String, Any> = [:]) {
    // Yup, default args don't do here
    writeHead(statusCode: s, nil, h)
  }
  
}
#endif
