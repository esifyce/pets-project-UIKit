import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// создаем очередь
let queue = DispatchQueue(label: "gcd.semaphores", attributes: .concurrent)

// создаем семафор
let semaphore = DispatchSemaphore(value: 0) // 0 - 1 - 0 - 1 - 0 - 1 - 0 - 1
semaphore.signal()

queue.async {
    // ждем бесконечно долго пока не получим сигнал
    semaphore.wait(timeout: .distantFuture)
    // поток будет выполняться 4 секунды
    Thread.sleep(forTimeInterval: 4)
    print("Block 1")
    // поток может заходить
    semaphore.signal()
}

queue.async {
    // ждем бесконечно долго пока не получим сигнал
    semaphore.wait(timeout: .distantFuture)
    // поток будет выполняться 4 секунды
    Thread.sleep(forTimeInterval: 2)
    print("Block 2")
    // поток может заходить
    semaphore.signal()
}

queue.async {
    // ждем бесконечно долго пока не получим сигнал
    semaphore.wait(timeout: .distantFuture)
    // поток будет выполняться 4 секунды
    Thread.sleep(forTimeInterval: 3)
    print("Block 3")
    // поток может заходить
    semaphore.signal()
}

queue.async {
    // ждем бесконечно долго пока не получим сигнал
    semaphore.wait(timeout: .distantFuture)
    // поток будет выполняться 4 секунды
    print("Block 4")
    // поток может заходить
    semaphore.signal()
}
