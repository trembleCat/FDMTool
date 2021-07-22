# FButton

>**组件功能**
>
>**1. 支持图片在上下左右四个方向**
>**2. 支持设置图片与文本的间距大小**
>**3. 支持设置图片的固定大小**
>**4. 支持分别设置内容范围与响应范围**
>**5. 支持使用自动布局或使用 Frame**
>**6. 使用方式与 UIButton 基本相同**

>**注意事项**
>
>**1. spacing 间距不能为负值**
>**2. 如果不设置 imageSize ，则会以图片大小进行自适应**
>**3. 设定的固定宽高需要大于设定的 imageSize + spacing**
>**4. 布局方式以图片自适应为基准，当设定的 Size 过大时并不会居中**
>**5. ContentSize 为展示大小，QHButton 的 Size 为实际大小（点击范围）**

## 示例

```swift

let button = FButton()
self.view.addSubview(button)

// 设置图片与文本的间距
button.spacing = 30
// 设置图片方向
button.imageDirection = .top
// 设置图片大小
button.imageSize = .init(width: 70, height: 70)

button.setImage(.init(named: "icon"), for: .normal)
button.setTitle("Button", for: .normal)
button.snp.makeConstraints { make in
       make.center.equalToSuperview()
}
```

## 作者

trembleCat, fa_dou_miao@163.com

