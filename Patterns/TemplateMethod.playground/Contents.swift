import Foundation

// абстрактный класс
class DriveVehicle {
    
    final func startVehicle() {
        haveASeat()
        useProtection()
        lookAtTheMirror()
        turnSignal()
        driveForward()
    }
    
    func haveASeat() {
    // когда мы вызовем этот метод, у нас будет ошибка
        preconditionFailure(" this method should be overriden")
    }
    
    func useProtection() {
        // когда мы вызовем этот метод, у нас будет ошибка
        preconditionFailure(" this method should be overriden")
    }
    
    func lookAtTheMirror() {
    // когда мы вызовем этот метод, у нас будет ошибка
        preconditionFailure(" this method should be overriden")
    }
    
    func turnSignal() {
    // когда мы вызовем этот метод, у нас будет ошибка
        preconditionFailure(" this method should be overriden")
    }
    
    func driveForward() {
    // когда мы вызовем этот метод, у нас будет ошибка
        preconditionFailure(" this method should be overriden")
    }
}

class Bicycle: DriveVehicle {
    
    override func haveASeat() {
        print("sit down on a bicycle seat")
    }
    
    override func useProtection() {
        print("wear a helmet")
    }
    
    override func lookAtTheMirror() {
        print("look at the little mirror")
    }
    
    override func turnSignal() {
        print("show left hand")
    }
    
    override func driveForward() {
        print("pedal")
    }
}

class Car: DriveVehicle {
    
    override func haveASeat() {
        print("sit down on a car seat")
        closeTheDoor()
    }
    
    func closeTheDoor() {
        print("close the door")
    }
    
    override func useProtection() {
        print("fasten selt belt")
    }
    
    override func lookAtTheMirror() {
        print("look at the rearview mirror")
    }
    
    override func turnSignal() {
        print("turn on left turn light")
    }
    
    override func driveForward() {
        print("push pedal")
    }
}

let car = Car()
let bicycle = Bicycle()

car.startVehicle()
print("#############")
bicycle.startVehicle()
