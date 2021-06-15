import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
// вызвали напрямую
let workItem = DispatchWorkItem(qos: .utility, flags: .detached) {
    print("Performing workitem")
}

workItem.perform()

// вызываем в очереди
    // наша очередь ссылается на .global
let queue = DispatchQueue(label: "block.gcd", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .workItem, target: DispatchQueue.global(qos: .userInitiated))

// асинхрно отправили workItem
queue.asyncAfter(deadline: .now() + 1, execute: workItem)

workItem.notify(queue: .main) {
    print("workItem is Completed")
}
// проверяем отменнена ли работа
workItem.isCancelled

// отменяем если не начал работу
workItem.cancel()

workItem.wait()

// код не выполняется пока workItem не выполниться
