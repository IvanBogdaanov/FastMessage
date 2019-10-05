//
//  FastMessage.swift
//  FastMessage
//
//  Created by Иван Богданов on 25.09.2019.
//  Copyright © 2019 Ivan Bogdanov. All rights reserved.
//

import UIKit

public enum StyleAlert {
    case black
    case white
}

public enum PositionAlert {
    case center
    case top
    case bottom
    case left
    case right
}

public class FastMessage {
    
    public static let shared = FastMessage()
    
    private let window = UIApplication.shared.windows.last!
    private var backgroundView = UIView()
    private var alert = UIView()
    private let semaphore = DispatchSemaphore(value: 1)
    private let queue = DispatchQueue(label: "Action")
    
    private init() {}
    
    public func show(style: StyleAlert = .black,
              title: String?,
              message: String,
              duration: Int = 2,
              durationHidden: Int = 1,
              durationShow: Int = 1,
              positionAlert: PositionAlert = .center) {
        
        queue.async { [unowned self] in
            
            self.semaphore.wait()
            
            DispatchQueue.main.async {
                self.setupAlert(title: title,
                                message: message,
                                style: style,
                                positionAlert: positionAlert)
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: TimeInterval(durationShow), animations: {
                    switch style {
                    case .black:
                        self.alert.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                    case .white:
                        self.alert.backgroundColor = UIColor.white.withAlphaComponent(1)
                    }
                })
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration), execute: {
                UIView.animate(withDuration: Double(durationHidden), animations: {
                    self.alert.alpha = 0
                })
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(durationShow + duration + durationHidden), execute: {
                self.alert.removeFromSuperview()
                self.semaphore.signal()
            })
            
        }
        
    }
    
    private func setupAlert(title: String?,
                            message: String,
                            style: StyleAlert,
                            positionAlert: PositionAlert) {
        
        alert = MessageView(title: title, message: message, style: style)
        constraintsAlert(positionAlert: positionAlert, view: window)
        
    }
    
    private func constraintsAlert(positionAlert: PositionAlert, view: UIView) {
        
        alert.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alert)
        view.addConstraints([
            
            alert.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            alert.widthAnchor.constraint(equalToConstant: 270)
            
            ])
        
        switch positionAlert {
            
        case .center:
            
            var topConstraint: NSLayoutConstraint!
            
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                if let navVC = window.rootViewController as? UINavigationController {
                    topConstraint = alert.topAnchor.constraint(greaterThanOrEqualTo: navVC.navigationBar.bottomAnchor, constant: 10)
                } else {
                    topConstraint = alert.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 44)
                }
            default:
                topConstraint = alert.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 10)
            }
            
            view.addConstraints([
                
                alert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                alert.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                alert.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 10),
                topConstraint,
                alert.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -10),
                alert.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10),
                
                ])
            
        case .left:
            
            var leftConstraint: NSLayoutConstraint!
            
            switch UIDevice.current.orientation {
                
            case .landscapeLeft:
                leftConstraint = alert.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 44)
                
            default:
                leftConstraint = alert.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
                
            }
            
            view.addConstraints([
                
                alert.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                leftConstraint,
                
                alert.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 10),
                alert.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -10),
                alert.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10),
                
                ])
        case .top:
            
            var topConstraint: NSLayoutConstraint!
            
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                if let navVC = window.rootViewController as? UINavigationController {
                    topConstraint = alert.topAnchor.constraint(equalTo: navVC.navigationBar.bottomAnchor, constant: 10)
                } else {
                    topConstraint = alert.topAnchor.constraint(equalTo: view.topAnchor, constant: 44)
                }
            default:
                topConstraint = alert.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
            }
            
            view.addConstraints([
                
                alert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                topConstraint,
                
                alert.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 10),
                alert.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -10),
                alert.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10),
                
                ])
            
        case .right:
            
            var rightConstraint: NSLayoutConstraint!
            
            switch UIDevice.current.orientation {
                
            case .landscapeRight:
                rightConstraint = alert.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -44)
                
            default:
                rightConstraint = alert.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
                
            }
            
            view.addConstraints([
                
                alert.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                rightConstraint,
                
                alert.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 10),
                alert.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 10),
                alert.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10)
                
                ])
            
        case .bottom:
            
            view.addConstraints([
                
                alert.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                alert.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
                alert.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 10),
                alert.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 10),
                alert.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -10)
                
                ])
            
        }
        
    }
}

fileprivate class MessageView: UIView {
    
    private let labelTitle = UILabel()
    private let labelMessage = UILabel()
    private var topMessageConstraint: NSLayoutConstraint?
    private var style: StyleAlert!
    
    fileprivate init(title: String?, message: String, style: StyleAlert) {
        super.init(frame: .zero)
        
        self.style = style
        layer.cornerRadius = 12.9
        
        if let title = title {
            if title.count > 50 {
                let index = title.index(title.startIndex, offsetBy: 50)
                labelTitle.text = String(title[..<index])
            } else {
                labelTitle.text = title
            }
        }
        
        if message.count > 1000 {
            let index = message.index(message.startIndex, offsetBy: 1000)
            labelMessage.text = String(message[..<index])
        } else {
            labelMessage.text = message
        }
        
        settingsLabels()
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
    
    private func settingsLabels() {
        
        switch style! {
        case .black:
            labelTitle.textColor = .white
            labelMessage.textColor = .white
            backgroundColor = UIColor.black.withAlphaComponent(0)
            
        case .white:
            layer.shadowRadius = 2.5
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOpacity = 1
            layer.shadowOffset = .zero
            labelTitle.textColor = .black
            labelMessage.textColor = .black
            backgroundColor = UIColor.white.withAlphaComponent(0)
            
        }
        
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
