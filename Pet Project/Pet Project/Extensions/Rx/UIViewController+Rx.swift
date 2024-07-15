//
//  UIViewController+Rx.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import RxCocoa
import RxSwift
import RxSwiftExt

extension Reactive where Base: UIViewController {
    
    var viewDidLoad: ControlEvent<Void> {
        return ControlEvent(events: sentMessage(#selector(Base.viewDidLoad)).mapTo(()))
    }

    var viewWillAppear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillAppear)).mapTo(()))
    }

    var viewWillAppearAnimated: ControlEvent<Bool> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillAppear)).compactMap { $0[0] as? Bool })
    }
    
    var viewWillLayoutSubviews: ControlEvent<Void> {
        return ControlEvent(events: sentMessage(#selector(Base.viewWillLayoutSubviews)).mapTo(()))
    }
    
    var viewDidLayoutSubviews: ControlEvent<Void> {
        return ControlEvent(events: sentMessage(#selector(Base.viewDidLayoutSubviews)).mapTo(()))
    }

    var viewDidAppear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewDidAppear)).mapTo(()))
    }

    var viewWillDisappear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillDisappear)).mapTo(()))
    }

    var viewDidDisappear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewDidDisappear)).mapTo(()))
    }

    func dismiss(animated: Bool) -> ControlEvent<Void> {
        return ControlEvent(
            events: Observable.create { [weak base = self.base] observer in
                base?.dismiss(animated: animated) {
                    observer.onNext(())
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        )
    }
    
    var applicationWillEnterForeground: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.willEnterForegroundNotification)
                .mapTo(())
            )
    }
    
    var applicationDidBecomeActive: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.didBecomeActiveNotification)
                .mapTo(())
        )
    }
    
    var applicationDidEnterBackground: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.didEnterBackgroundNotification)
                .mapTo(())
        )
    }
    
    var applicationWillResignActive: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.willResignActiveNotification)
                .mapTo(())
        )
    }
}

extension Reactive where Base: UITabBarController {
    
    var viewDidLoad: ControlEvent<Void> {
        return ControlEvent(events: sentMessage(#selector(Base.viewDidLoad)).mapTo(()))
    }

    var viewWillAppear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillAppear)).mapTo(()))
    }

    var viewWillAppearAnimated: ControlEvent<Bool> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillAppear)).compactMap { $0[0] as? Bool })
    }
    
    var viewWillLayoutSubviews: ControlEvent<Void> {
        return ControlEvent(events: sentMessage(#selector(Base.viewWillLayoutSubviews)).mapTo(()))
    }
    
    var viewDidLayoutSubviews: ControlEvent<Void> {
        return ControlEvent(events: sentMessage(#selector(Base.viewDidLayoutSubviews)).mapTo(()))
    }

    var viewDidAppear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewDidAppear)).mapTo(()))
    }

    var viewWillDisappear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillDisappear)).mapTo(()))
    }

    var viewDidDisappear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewDidDisappear)).mapTo(()))
    }

    func dismiss(animated: Bool) -> ControlEvent<Void> {
        return ControlEvent(
            events: Observable.create { [weak base = self.base] observer in
                base?.dismiss(animated: animated) {
                    observer.onNext(())
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        )
    }
    
    var applicationWillEnterForeground: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.willEnterForegroundNotification)
                .mapTo(())
            )
    }
    
    var applicationDidBecomeActive: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.didBecomeActiveNotification)
                .mapTo(())
        )
    }
    
    var applicationDidEnterBackground: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.didEnterBackgroundNotification)
                .mapTo(())
        )
    }
    
    var applicationWillResignActive: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.willResignActiveNotification)
                .mapTo(())
        )
    }
}

extension Reactive where Base: UINavigationController {
    
    var viewDidLoad: ControlEvent<Void> {
        return ControlEvent(events: sentMessage(#selector(Base.viewDidLoad)).mapTo(()))
    }

    var viewWillAppear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillAppear)).mapTo(()))
    }

    var viewWillAppearAnimated: ControlEvent<Bool> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillAppear)).compactMap { $0[0] as? Bool })
    }
    
    var viewWillLayoutSubviews: ControlEvent<Void> {
        return ControlEvent(events: sentMessage(#selector(Base.viewWillLayoutSubviews)).mapTo(()))
    }
    
    var viewDidLayoutSubviews: ControlEvent<Void> {
        return ControlEvent(events: sentMessage(#selector(Base.viewDidLayoutSubviews)).mapTo(()))
    }

    var viewDidAppear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewDidAppear)).mapTo(()))
    }

    var viewWillDisappear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewWillDisappear)).mapTo(()))
    }

    var viewDidDisappear: ControlEvent<Void> {
        return ControlEvent(events: self.sentMessage(#selector(Base.viewDidDisappear)).mapTo(()))
    }

    func dismiss(animated: Bool) -> ControlEvent<Void> {
        return ControlEvent(
            events: Observable.create { [weak base = self.base] observer in
                base?.dismiss(animated: animated) {
                    observer.onNext(())
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        )
    }
    
    var applicationWillEnterForeground: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.willEnterForegroundNotification)
                .mapTo(())
            )
    }
    
    var applicationDidBecomeActive: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.didBecomeActiveNotification)
                .mapTo(())
        )
    }
    
    var applicationDidEnterBackground: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.didEnterBackgroundNotification)
                .mapTo(())
        )
    }
    
    var applicationWillResignActive: ControlEvent<Void> {
        return ControlEvent(
            events: NotificationCenter.default.rx
                .notification(UIApplication.willResignActiveNotification)
                .mapTo(())
        )
    }
}

