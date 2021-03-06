//
//  ChildProcessPipes.swift
//  Noze.io
//
//  Created by Helge Hess on 30/05/16.
//  Copyright © 2016 ZeeZide GmbH. All rights reserved.
//

import streams

/// Directly pipe the output of a child process into a stream, like so:
///
///     spawn("ls") | readlines | concat { lines in print("LINES: \(lines)") }
///
public func |<WriteStream: GWritableStreamType
                           where WriteStream.WriteType == UInt8>
             (left: ChildProcess, right: WriteStream) -> WriteStream
{
  guard let stdout = left.stdout else {
    // process has no stdout
    right.end()
    return right
  }
  return stdout.pipe(right)
}

/// Pipe a stream into a child process (stdin). Returns the stdout of the
/// child process, like so:
///
///      inStream | spawn("gzip") | outStream
///
/// This is essentially a transform stream where the transformation is done by
/// the child process.
///
public func |<ReadStream: GReadableStreamType
                           where ReadStream.ReadType == UInt8>
             (left: ReadStream, right: ChildProcess) -> SourceStream<PipeSource>
{
  // funky stuff :-)
  assert(right.stdin != nil, "child process has no stdin!")
  
  _ = left.pipe(right.stdin!)
  return right.stdout!
}

#if swift(>=3.0) // #swift3-fd
/// Pipe a sequence into a child process (stdin). Returns the stdout of the
/// child process, like so:
///
///      "Hello World!".utf8 | spawn("base64") | utf8 | concat { b64 in ... }
///
/// This is essentially a transform stream where the transformation is done by
/// the child process.
///
public func |<TI: Sequence where TI.Iterator.Element == UInt8>
            (left: TI, right: ChildProcess) -> SourceStream<PipeSource>
{
  // funky stuff :-)
  assert(right.stdin != nil, "child process has no stdin!")
  
  _ = left.pipe(right.stdin!)
  return right.stdout!
}
#else
/// Pipe a sequence into a child process (stdin). Returns the stdout of the
/// child process, like so:
///
///      "Hello World!".utf8 | spawn("base64") | utf8 | concat { b64 in ... }
///
/// This is essentially a transform stream where the transformation is done by
/// the child process.
///
public func |<TI: SequenceType where TI.Generator.Element == UInt8>
            (left: TI, right: ChildProcess) -> SourceStream<PipeSource>
{
  // funky stuff :-)
  assert(right.stdin != nil, "child process has no stdin!")
  
  left.pipe(right.stdin!)
  return right.stdout!
}
#endif

/// Pipe a String into a child process (stdin). Returns the stdout of the
/// child process, like so:
///
///      "Hello World!" | spawn("base64") | utf8 | concat { b64 in ... }
///
/// This is essentially a transform stream where the transformation is done by
/// the child process.
///
public func |(left: String, right: ChildProcess) -> SourceStream<PipeSource> {
  return left.utf8 | right
}
