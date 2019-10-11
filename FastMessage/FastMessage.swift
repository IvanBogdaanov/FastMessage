import UIKit

// MARK: - All enum FastMessage

/**
 Тип UIView для отображения на экране.
 */
public enum TypeView {
    ///UIView по умолчанию c возможность выбора стиля.
    case Default(styleToast: StyleToast)
    /// Кастомная UIView.
    case custom(view: UIView)
}

/**
 Способ установки UIView на экран.
 */
public enum TypeInstallation {
    //По умолчанию с возможностью выбора позиции и минимального размера UIView.
    case Default(positionToast: PositionToast, minHeightView: CGFloat, minWidthView: CGFloat)
    //Установка UIView вручную.
    case myConstraints(completion: (UIView) -> Void)
}

/**
 Стиль для дефолтного UIView.
 */
public enum StyleToast {
    case black
    case white
}

/**
 Позиция для типа установки по умолчанию
 */
public enum PositionToast {
    case center
    case top
    case bottom
}

// MARK: - Очередь для сообщений

fileprivate class ToastQueue {
    
    fileprivate static let shared = ToastQueue()
    
    private var inQueue: Bool = false
    private var currentView: UIView?
    
    private init() {}
    
    private var list = [() -> UIView]() {
        didSet {
            
            if !inQueue {
                
                inQueue = true
                
                if let first = list.first {
                    currentView = first()
                    
                    guard let currentView = currentView else { return }
                    
                    UIView.animate(withDuration: currentView.durationShow) {
                        currentView.alpha = 1
                        Timer.scheduledTimer(withTimeInterval: currentView.durationShow + currentView.duration, repeats: false, block: { _ in
                            UIView.animate(withDuration: currentView.durationHidden, animations: {
                                currentView.alpha = 0
                            })
                        })
                    }
                    
                    Timer.scheduledTimer(withTimeInterval: currentView.durationShow + currentView.duration + currentView.durationHidden, repeats: false) { _ in
                        self.deleteCurrentView()
                    }
                    
                } else {
                    inQueue = false
                }
                
            }
            
        }
    }
    
    fileprivate func clearAllToast() {
        list.removeAll()
        if let view = currentView {
            view.removeFromSuperview()
        }
        currentView = nil
        inQueue = false
    }
    
    fileprivate func deleteCurrentView() {
        if let view = currentView {
            view.removeFromSuperview()
            currentView = nil
            inQueue = false
            let _ = list.removeFirst()
        }
    }
    
    fileprivate func append(_ object: @escaping () -> UIView) {
        list.append(object)
    }
    
}

// MARK: - Дефолтный UIView

fileprivate class ToastView: UIView {
    
    fileprivate let labelTitle = UILabel()
    private let labelMessage = UILabel()
    private var topMessageConstraint: NSLayoutConstraint?
    private var style: StyleToast?
    
    fileprivate init(title: String?, message: String, style: StyleToast) {
        super.init(frame: .zero)
        
        self.style = style
        layer.cornerRadius = 12.9
        labelTitle.text = title
        labelMessage.text = message
        
        titleSettings()
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(labelTitle)
        addSubview(labelMessage)
        
        addConstraints([
            
            labelTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelTitle.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            labelTitle.firstBaselineAnchor.constraint(equalTo: topAnchor, constant: 36),
            labelTitle.firstBaselineAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: 36),
            labelTitle.firstBaselineAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 22.5),
            
            labelMessage.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelMessage.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            labelMessage.firstBaselineAnchor.constraint(equalTo: labelTitle.lastBaselineAnchor, constant: 20),
            labelMessage.firstBaselineAnchor.constraint(lessThanOrEqualTo: labelTitle.lastBaselineAnchor, constant: 20),
            labelMessage.firstBaselineAnchor.constraint(greaterThanOrEqualTo: labelTitle.lastBaselineAnchor, constant: 17),
            labelMessage.lastBaselineAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            self.bottomAnchor.constraint(equalTo: labelMessage.lastBaselineAnchor, constant: 24)
            
            ])
    }
    
    private func titleSettings() {
        
        switch style! {
        case .black:
            
            labelTitle.textColor = .white
            labelMessage.textColor = .white
            backgroundColor = UIColor.black
            
        case .white:
            
            layer.shadowRadius = 2.5
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOpacity = 1
            layer.shadowOffset = .zero
            labelTitle.textColor = .black
            labelMessage.textColor = .black
            backgroundColor = UIColor.white
            
        }
        
        self.alpha = 0
        
        labelTitle.font = .boldSystemFont(ofSize: 17)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.numberOfLines = 0
        labelTitle.textAlignment = .center
        labelTitle.clipsToBounds = true
        
        labelMessage.backgroundColor = .clear
        labelMessage.font = .systemFont(ofSize: 13)
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        labelMessage.numberOfLines = 0
        labelMessage.clipsToBounds = true
        labelMessage.textAlignment = .center
        
    }
    
}

extension UIView {
    
    private struct ToastKey {
        static var durationShow = "Fast_Message.durationShow"
        static var duration = "Fast_Message.duration"
        static var durationHidden = "Fast_Message.durationHidden"
        static var queue = "Fast_Message.queue"
    }
    
    fileprivate var durationShow: Double {
        get {
            guard let value = objc_getAssociatedObject(self, &ToastKey.durationShow) as? Double else {
                return 0
            }
            return value
        }
        set {
            objc_setAssociatedObject(self,
                                     &ToastKey.durationShow,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var durationHidden: Double {
        get {
            guard let value = objc_getAssociatedObject(self, &ToastKey.durationHidden) as? Double else {
                return 1
            }
            return value
        }
        set {
            objc_setAssociatedObject(self,
                                     &ToastKey.durationHidden,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var duration: Double {
        get {
            guard let value = objc_getAssociatedObject(self, &ToastKey.duration) as? Double else {
                return 2
            }
            return value
        }
        set {
            objc_setAssociatedObject(self,
                                     &ToastKey.duration,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     
     Удаляет текущее сообщение.
     
     */
    
    public func closeCurrentToast() {
        ToastQueue.shared.deleteCurrentView()
    }
    
    /**
     Показывает сообщение с заданными **параметрами**.
     
     - Parameter title: Заголовок вашего сообщения (может быть пустым).
     - Parameter message: Сообщение.
     - Parameter durationShow: Длительность появления сообщения( по дефолту стоит 0.5).
     - Parameter duration: Длительность сообщения( по дефолту стоит 2).
     - Parameter durationHidden: Длительность скрытия сообщения( по дефолту стоит 0.8).
     - Parameter typeView: Это UIView который будет отображен на экране ( по дефолту стоит .Default(styleToast: .black).
     - Parameter typeInstallation: Это то как вы хотите установить свой UIView на экране.
     
     */
    
    public func showToast(title: String?,
                          message: String,
                          durationShow: Double = 0.5,
                          duration: Double = 2,
                          durationHidden: Double = 0.8,
                          typeView: TypeView = .Default(styleToast: .black),
                          typeInstallation: TypeInstallation = .Default(positionToast: .center, minHeightView: 44, minWidthView: 270)) {
        
        ToastQueue.shared.append {
            self.setupView(title: title,
                           message: message,
                           durationShow: durationShow,
                           duration: duration,
                           durationHidden: durationHidden,
                           typeView: typeView,
                           typeInstallation: typeInstallation)
        }
        
    }
    /**
     
     Удаляет все сообщения в очереди
     
     */
    
    public func clearAllToast() {
        ToastQueue.shared.clearAllToast()
    }
    
    private func setupView(title: String?,
                           message: String,
                           durationShow: Double,
                           duration: Double,
                           durationHidden: Double,
                           typeView: TypeView,
                           typeInstallation: TypeInstallation) -> UIView {
        
        var view: UIView?
        
        switch typeView {
        case let .Default(style):
            view = ToastView(title: title, message: message, style: style)
            
        case let .custom(customView):
            view = customView
            
        }
        
        if let view = view {
            view.durationShow = durationShow
            view.duration = duration
            view.durationHidden = durationHidden
            
            switch typeInstallation {
            case let .Default(position, minHeight, minWidth):
                setupConstraintsView(positionToast: position, view: view, minHeight: minHeight, minWidth: minWidth)
            case let .myConstraints(completion):
                completion(view)
            }
        }
        
        return view!
        
    }
    
    private func setupConstraintsView(positionToast: PositionToast, view: UIView, minHeight: CGFloat, minWidth: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        self.addConstraints([
            
            view.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight),
            view.widthAnchor.constraint(equalToConstant: minWidth)
            
            ])
        if let window = UIApplication.shared.windows.last {
            
            switch positionToast {
            case .center:
                
                var topConstraint: NSLayoutConstraint!
                
                if let navVC = window.rootViewController as? UINavigationController {
                    topConstraint = view.topAnchor.constraint(greaterThanOrEqualTo: navVC.navigationBar.bottomAnchor, constant: 10)
                } else {
                    topConstraint = view.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 44)
                }
                
                self.addConstraints([
                    
                    view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    
                    view.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 10),
                    topConstraint,
                    view.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -10),
                    view.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10),
                    
                    ])
                
            case .top:
                
                var topConstraint: NSLayoutConstraint!
                
                if let navVC = window.rootViewController as? UINavigationController {
                    topConstraint = view.topAnchor.constraint(equalTo: navVC.navigationBar.bottomAnchor, constant: 10)
                    
                } else {
                    topConstraint = view.topAnchor.constraint(equalTo: self.topAnchor, constant: 44)
                }
                
                self.addConstraints([
                    
                    view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    topConstraint,
                    
                    view.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 10),
                    view.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -10),
                    view.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -22),
                    
                    ])
                
            case .bottom:
                self.addConstraints([
                    
                    view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22),
                    view.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 10),
                    view.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 10),
                    view.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -10)
                    
                    ])
                
            }
            
        }
        
    }
    
}
