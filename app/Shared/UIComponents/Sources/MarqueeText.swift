import SwiftUI

public struct MarqueeText : View {
  private let font: UIFont = UIFont.custom(.bold, size: 10)
  
  private let text: String
  private let alignment: Alignment
  
  public init(text: String, alignment: Alignment) {
    self.text = text
    self.alignment = alignment
  }
  
  @State private var animate = false
  
  public var body : some View {
    let stringWidth = text.widthOfString(usingFont: font)
    let stringHeight = text.heightOfString(usingFont: font)
    
    let animation = Animation
      .linear(duration: Double(stringWidth) / 30)
      .repeatForever(autoreverses: false)
    
    return ZStack {
      GeometryReader { proxy in
        if stringWidth > proxy.size.width {
          Group {
            Text(self.text)
              .lineLimit(1)
              .font(.init(font))
              .offset(x: self.animate ? -stringWidth - stringHeight * 2 : 0)
              .animation(self.animate ? animation : nil, value: self.animate)
              .onAppear {
                Task.init {
                  self.animate = proxy.size.width < stringWidth
                }
              }
              .fixedSize(horizontal: true, vertical: false)
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            
            Text(self.text)
              .lineLimit(1)
              .font(.init(font))
              .offset(x: self.animate ? 0 : stringWidth + stringHeight * 2)
              .animation(self.animate ? animation : nil, value: self.animate)
              .onAppear {
                Task.init {
                  self.animate = proxy.size.width < stringWidth
                }
              }
              .fixedSize(horizontal: true, vertical: false)
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
          }
          .onChange(of: self.text, perform: { text in
            self.animate = proxy.size.width < stringWidth
          })
          .frame(width: proxy.size.width)
        } else {
          Text(self.text)
            .font(.init(font))
            .onChange(of: self.text, perform: { text in
              self.animate = proxy.size.width < stringWidth
            })
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: alignment)
        }
      }
    }
    .frame(height: stringHeight)
  }
  
  public init(text: String, alignment: Alignment?) {
    self.text = text
    self.alignment = alignment != nil ? alignment! : .topLeading
  }
}

extension String {
  
  func widthOfString(usingFont font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttributes)
    return size.width
  }
  
  func heightOfString(usingFont font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttributes)
    return size.height
  }
}
