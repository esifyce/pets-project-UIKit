import Foundation

// adaptee
class SimpleCar {
    
    func sound() -> String {
        return "tr-tr-tr-tr"
    }
}

// target
protocol SupercarProtocol {
    
    func makeNoise() -> String
}

class Supercar: SupercarProtocol {
    func makeNoise() -> String {
        return "wroom-wroom"
    }
}
// adapter
class SupercarAdaptor: SupercarProtocol {

    var simpleCar: SimpleCar
    
    init(simpleCar: SimpleCar) {
        self.simpleCar = simpleCar
    }
    
    func makeNoise() -> String {
        return simpleCar.sound()
    }
}

