//
//  Module.swift
//  Noze.io
//
//  Created by Helge Heß on 4/10/16.
//  Copyright © 2016 ZeeZide GmbH. All rights reserved.
//

@_exported import core
@_exported import streams
import xsys

public class NozeNet : NozeModule {
}
public let module = NozeNet()


// TODO: What is the difference between connect() and createConnection?


/// Create a `Socket` object and automatically connect it to the given 
/// host/port, where `host` defaults to 'localhost'.
///
/// Optional onConnect block.
///
/// Sample:
///
///     let sock = net.connect(80, "zeezide.de") { sock in
///       sock.write("GET / HTTP/1.0\r\n")
///       sock.write("Content-Length: 0\r\n")
///       sock.write("Host: zeezide.de\r\n")
///       sock.end  ("\r\n")
///     }
///
public func connect(port: Int, _ host: String = "localhost",
                    onConnect: ConnectCB? = nil)
            -> Socket
{
  return Socket().connect(port: port, host: host, onConnect: onConnect)
}

public class ConnectOptions {
  public var hostname : String?     = "localhost"
  public var port     : Int         = 80

  /// Version of IP stack (IPv4) 
  public var family   : sa_family_t = sa_family_t(xsys.AF_INET)
  
  public init() {}
}

public func connect(options o: ConnectOptions = ConnectOptions(),
                    onConnect cb: ConnectCB? = nil)
  -> Socket
{
  return Socket().connect(options: o, onConnect: cb)
}


#if swift(>=3.0) // #swift3-discardable-result
/// Creates a new `net.Server` object.
///
/// Optional onConnection block.
///
/// Sample:
///
///     let server = net.createServer { sock in
///       print("connected")
///     }
///     .onError { error in
///       print("error: \(error)")
///     }
///     .listen {
///       print("Server is listening on \($0.address)")
///     }
///
@discardableResult
public func createServer(allowHalfOpen  : Bool = false,
                         pauseOnConnect : Bool = false,
                         onConnection   : ConnectCB? = nil) -> Server
{
  let srv = Server(allowHalfOpen:  allowHalfOpen,
                   pauseOnConnect: pauseOnConnect)
  if let cb = onConnection { _ = srv.onConnection(handler: cb) }
  return srv
}
#else // Swift 2.2
/// Creates a new `net.Server` object.
///
/// Optional onConnection block.
///
/// Sample:
///
///     let server = net.createServer { sock in
///       print("connected")
///     }
///     .onError { error in
///       print("error: \(error)")
///     }
///     .listen {
///       print("Server is listening on \($0.address)")
///     }
///
public func createServer(allowHalfOpen ho: Bool = false,
                         pauseOnConnect : Bool = false,
                         onConnection   : ConnectCB? = nil) -> Server
{
  let srv = Server(allowHalfOpen:  ho,
                   pauseOnConnect: pauseOnConnect)
  if let cb = onConnection { _ = srv.onConnection(handler: cb) }
  return srv
}
#endif // Swift 2.2


#if os(Linux)
#else
  // importing this from xsys doesn't seem to work
  import Foundation // this is for POSIXError : Error
#endif

#if swift(>=3.0) // #swift3-1st-arg #swift3-discardable-result
@discardableResult
public func connect(_ port: Int, _ host: String = "localhost",
                    onConnect: ConnectCB? = nil)
            -> Socket
{
  return connect(port: port, host, onConnect: onConnect)
}
#endif
