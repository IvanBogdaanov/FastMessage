# FastMessage
Это небольшая библиотека для быстрого отображения сообщений на экране
<img width="339" alt="Снимок экрана 2019-10-11 в 20 53 11" src="https://user-images.githubusercontent.com/50133415/66673471-4ed7d680-ec69-11e9-933a-9a165f992631.png">
<img width="340" alt="Снимок экрана 2019-10-11 в 20 53 36" src="https://user-images.githubusercontent.com/50133415/66673490-5a2b0200-ec69-11e9-94f0-b72353ee1170.png">

## Installation
### CocoaPods
To integrate FastMessage into your Xcode project using CocoaPods, specify it in your Podfile:

Вставьте следущий код в ваш Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'FastMessage'
end
```
## Usage
### Default Show
1.  Импортируем в наш проект FastMessage
```swift
import FastMessage
```
2.  Для отображения на экране сообщения используется всего одна функция.

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        
        view.showToast(title: String?, message: String)
        
    }
```
У этой функции есть расширенная версия (обязательными параметрами являются только первый два, у остальных есть дефолтные значения):
```swift
  override func viewDidLoad() {
        super.viewDidLoad()
        
        view.showToast(title: String?,
                       message: String,
                       durationShow: Double,
                       duration: Double,
                       durationHidden: Double,
                       typeView: TypeView,
                       typeInstallation: TypeInstallation)
        
    }
 ```
   Где сумма ***durationShow, duration, durationHidden*** являются длительностью жизни сообщения на экране.
     
   ***typeView*** - Тип UIView который вы хотите отобразитью. Есть два типа, ***.Default(styleToast: StyleToast)*** с возможность выбора двух стилей (.black and .white) и ***.custom(view: UIView)*** где view является вашей собственной UIView
     
   ***typeInstalation*** - Это выбор того как вы можете установить свой UIView на экране. Есть два режима, ***.Default(positionToast: PositionToast, minHeightView: CGFloat, minWidthView: CGFloat)***, где positionToast это выбор позиции на экране, а minHeightView, minWidthView, это минимальный размер UIView, второй режим ***.myConstraints(completion: (UIView) -> Void)***, где у вас есть возможность установить свой UIView самостоятельно. 
     
Пример использования .myConstraints(completion: (UIView) -> Void):
```swift
     override func viewDidLoad() {
        super.viewDidLoad()
        
        view.showToast(title: "Заголовок",message: "Сообщение", typeInstallation: .myConstraints(completion: { myView in
            
            myView.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(myView)
            self.view.addConstraints([
                
                myView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
                myView.widthAnchor.constraint(equalToConstant: 270),
                
                myView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                myView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)

                ])
            
        }))
        
    }
```
     
## Communication
Пишите что добавить или убрать

Ivan.bogdaanov@gmail.com

telegram: @IvanBogdaanov

## License
FastMessage is released under the MIT license. See LICENSE for details.
