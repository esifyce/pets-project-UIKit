import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// создаем очередь
let queue = DispatchQueue(label: "gcd.sources", attributes: .concurrent)

// создаем таймер
let timer = DispatchSource.makeTimerSource(queue: queue)

// настраиваем таймер
timer.schedule(deadline: .now(), repeating: .seconds(2), leeway: .milliseconds(300))
timer.setEventHandler {
    print("Hello world!")
}

timer.setCancelHandler {
    print("Timer is cancelled")
}

// запускаем таймер
timer.resume()
