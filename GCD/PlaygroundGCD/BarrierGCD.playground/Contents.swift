import UIKit
import PlaygroundSupport

// позволяет выполнить Playground до конца, обновляя его
PlaygroundPage.current.needsIndefiniteExecution = true

class SafeArray<Element> {
    private var array = [Element]()
    private let queue = DispatchQueue(label: "DispatchBarrier", attributes: .concurrent)
    
    public func append(element: Element) {
        // используем барьер, т.е. Ничто не выполняется, пока не выполнится барьер
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }
    
    public var elements: [Element] {
        // создаем свойство в которое помещаем значение
        var result = [Element]()
        // делаем синхронный, потому что когда мы делаем запрос мы хотим получить результат, но если мы не дожидаемся получение результата, то мы не сможем получить правильный ответ
        queue.sync {
            result = self.array
        }
        return result
    }
}

var safeArray = SafeArray<Int>()
array.append(0)
DispatchQueue.concurrentPerform(iterations: 10) { index in
    safeArray.append(element: index)
}

print("safeArray: \(safeArray.elements)")

var array = [Int]()
DispatchQueue.concurrentPerform(iterations: 10) { index in
    array.append(index)
}
print("array: \(array)")
