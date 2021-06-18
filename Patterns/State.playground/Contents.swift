import Foundation

// определяет какие состояния у нас есть
protocol State {
    
    func on(printer: Printer)
    func off(printer: Printer)
    func printDocument(printer: Printer)
}
// MARK: - Определили наши состояния
class On: State {
    
    func on(printer: Printer) {
        print("it is on already")
    }
    
    func off(printer: Printer) {
        print("turning printer off")
        printer.set(state: Off())
    }
    
    func printDocument(printer: Printer) {
        print("printing")
        printer.set(state: Print())
    }
}

class Off: State {
    
    func on(printer: Printer) {
        print("turning on")
        printer.set(state: On())
    }
    
    func off(printer: Printer) {
        print("it is already off")
    }
    
    func printDocument(printer: Printer) {
        print("if it off, we can't print")
    }
}

class Print: State {
    
    func on(printer: Printer) {
        print("it is on already")
    }
    
    func off(printer: Printer) {
        print("turning printer off")
        printer.set(state: Off())
    }
    
    func printDocument(printer: Printer) {
        print("it is already printing")
    }
}

class Printer {
    
    var state: State
    
    init() {
        self.state = On()
    }
    
    func set(state: State) {
        self.state = state
    }
    
    func turnOn() {
        state.on(printer: self)
    }
    
    func turnOff() {
        state.off(printer: self)
    }
    
    func printDocument() {
        state.printDocument(printer: self)
    }
}

let printer = Printer()
printer.printDocument()
printer.turnOff()
printer.turnOn()
printer.turnOn()
printer.printDocument()
printer.turnOn()
printer.printDocument()
