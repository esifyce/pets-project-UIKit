import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "ru.swiftbook", attributes: .concurrent)

// создаем группу
// MARK: - 1 вариант
let group = DispatchGroup()

queue.async(group: group) {
    for i in 0...10 {
        if i == 10 {
            print(i)
        }
    }
}

queue.async(group: group) {
    for i in 0...20 {
        if i == 20 {
            print(i)
        }
    }
}

group.notify(queue: .main) {
    print("Все закончено в группе")
}
// MARK: - 2 вариант
let secondGroup = DispatchGroup()
secondGroup.enter()
queue.async(group: group) {
    for i in 0...30 {
        if i == 30 {
            print(i)
            secondGroup.leave()
        }
    }
}

let result = secondGroup.wait(timeout: .now() + 3)
print(result)

secondGroup.notify(queue: .main) {
    print("все закончено во второй группе")
}

print("Этот принт должен быть выше чем последний")

secondGroup.wait()
    // после выполнени wait, код пойдет дальше
