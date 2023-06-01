actor Channel<T: Sendable> {
  private var data: [T] = []
  private var head = 0 // point to the first valid item
  func send(_ item: T) {
    data.append(item)
  }
  func receive() -> T {
    let res = data[head]
    head += 1
    return res
  }
}

let elapsed = await ContinuousClock().measure {
  let chan = Channel<Int>()
  let n = Int(CommandLine.arguments[1])!
  await withTaskGroup(of: Void.self) { group in
    for _ in 0..<n {
      group.addTask {
        await chan.send(1)
        do {
          try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {}
        let _ = await chan.receive()
      }
    }
  }
}
print(elapsed)
