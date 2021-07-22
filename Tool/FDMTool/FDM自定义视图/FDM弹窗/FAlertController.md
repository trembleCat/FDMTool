# FAlertController

## 说明

**FAlertController 为提示弹窗组件**
>**包含以下功能**
>
>**支持与系统样式相同的弹窗效果**
>
>**支持自适应 Action 样式**
>
>**支持修改弹窗颜色**

## 示例

示例请下载Demo到本地查看

## 使用方式
```swift
let alertController = FAlertController(title: "提示", message: "内容")
let action_1 = FAlertAction(title: "确定", style: .default) {
    // 点击确定后触发的事件
}

let action_2 = FAlertAction(title: "取消", style: .cancel)

self.navigationController?.present(alertController, animated: true, completion: nil)
```

## 作者

trembleCat, fa_dou_miao@163.com

## 许可证

FAlertController 是在MIT许可下提供的。有关详细信息，请参阅许可证文件。
