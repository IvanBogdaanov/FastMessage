# FastMessage
It is a small library for displaying quick pop-up messages

Это небольшая библиотека для быстрого отображения сообщений на экране

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
1. Import Fast Message into our project

   Импортируем в наш проект FastMessage

```swift
import FastMessage
```
2. Call the command to display the default message

   Вызываем команду для отображения дефолтного сообщения
```swift
FastMessage.shared.show(title: "Заголовок", message: "Сообщение")
```
3. Result

   Результат
<img width="322" alt="Снимок экрана 2019-10-06 в 16 24 30" src="https://user-images.githubusercontent.com/50133415/66269815-d2528b80-e855-11e9-9de9-62901bb5518f.png">

### Extended Show
Extended version of show

Расширенная версия функции show
```swift
FastMessage.shared.show(style: StyleAlert,
                        title: String,
                        message: String,
                        duration: Int,
                        durationHidden: Int,
                        durationShow: Int,
                        positionAlert: PositionAlert)
```
* style: 

There are two styles: black and white (the default is black
)

Есть два стиля: белый и черный (по дефолту стоит черный цвет)
```swift
style: .black
```
and (и)
```swift
style: .white
```
<img width="292" alt="Снимок экрана 2019-10-06 в 16 35 44" src="https://user-images.githubusercontent.com/50133415/66270015-68d37c80-e857-11e9-9b1b-daa631ba4219.png">

* duration, durationHidden, durationShow:

time the message is displayed on the screen(duration + durationHidden + durationShow)

Время отображения сообщения на экране(duration + durationHidden + durationShow)

P.S. If the background is light and you want to use a white style then durationShow put 0

Если фон светлый и вы хотите использовать белый стиль то durationShow ставьте 0

* positionAlert:

the place where you want to place the message

Это то место где вы хотите разместить сообщение

```swift
positionAlert: .center
positionAlert: .left
positionAlert: .right
positionAlert: .top
positionAlert: .bottom
```

## Communication
Write that add or that to remove

Пишите что добавить или убрать

Ivan.bogdaanov@gmail.com

telegram: @IvanBogdaanov

## License
FastMessage is released under the MIT license. See LICENSE for details.
