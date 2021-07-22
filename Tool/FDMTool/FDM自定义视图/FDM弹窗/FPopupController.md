# FPresentController

## 说明

**FPresentController 为页面弹窗组件**
>**包含以下功能**
>
>**1.以弹出的形式展示新的 Controller**  
>
>**2.通过继承的方式使用该组件**
>
>**3.可以修改弹窗内容的高度以及动画时间**
  
  
> **注意：使用时需要将视图添加到 contentView 上**


## 示例

示例请下载Demo到本地查看

## 使用方式
```swift
// 继承 FPopupController
final class PopupTestController_2: FPopupController {
    
    // 显示内容高度
    override var contentHeight: CGFloat { 1000 }
    
    // 弹出动画时间
    override var animationDuration: TimeInterval { 0.25 }
    
    let headerLabel = UILabel()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将视图添加到 contentView 上
        contentView.addSubview(headerLabel)
        contentView.addSubview(tableView)
    }
}
```

## 作者

trembleCat, fa_dou_miao@163.com

## 许可证

FPresentController 是在MIT许可下提供的。有关详细信息，请参阅许可证文件。
