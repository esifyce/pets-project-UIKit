import Foundation

// MARK: - Virtual Proxy Pattern
class User {
    let id = "123"
}

protocol ServerProtocol {
    func grandAccess(user: User)
    func denyAccess(user: User)
}

// Server
class ServerSide: ServerProtocol {
    func grandAccess(user: User) {
        print("access granted to user with id = \(user.id)")
    }

    func denyAccess(user: User) {
        print("access denied to user with id = \(user.id)")
    }
}

// Proxy
class ServerProxy: ServerProtocol {

    lazy private var server: ServerSide = ServerSide()

    func grandAccess(user: User) {
        server.grandAccess(user: user)
    }

    func denyAccess(user: User) {
        server.denyAccess(user: user)
    }
}

let user = User()
let proxy = ServerProxy()
proxy.grandAccess(user: user)
proxy.denyAccess(user: user)

// MARK: - Property Proxy Pattern
class User1 {
    let name = "Petr"
    let password = "123"
}

protocol ServerProtocol1 {
    func grantAccess1(user: User1)
}

// Server
class ServerSide1: ServerProtocol1 {
    func grantAccess1(user: User1) {
        print("access granted to user with name = \(user.name)")
    }
}

// Proxy
class ServerProxy1: ServerProtocol1 {
    // ссылка на сервер
    private var server: ServerSide1!
    
    func grantAccess1(user: User1) {
        // проверка что он не равен nil
        guard server != nil else {
            print("access can't be granted")
            return
        }
        server.grantAccess1(user: user)
    }
    
    func authenticate1(user: User1) {
        // проверка на авторизацию
        guard user.password == "123" else { return }
        print("user authenticated")
        server = ServerSide1()
    }
}

let user1 = User1()
let proxy1 = ServerProxy1()

proxy1.grantAccess1(user: user1)
proxy1.authenticate1(user: user1)
proxy1.grantAccess1(user: user1)

