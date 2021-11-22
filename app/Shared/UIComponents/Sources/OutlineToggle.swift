//
//  OutlineToggle.swift
//  
//
//  Created by Ziad Tamim on 21.11.21.
//

import SwiftUI

public struct OutlineToggle: View {
    @Binding public var isOn: Bool
    @Namespace private var toggleNamespace
    
    public init(isOn: Binding<Bool>) {
        self._isOn = isOn
    }
    
    public var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            Capsule()
                .strokeBorder(.black, lineWidth: 2)
                .background(isOn ? AnyView(Gradient.bubbleGum) : AnyView(Color.white))
                .clipShape(Capsule())
                .frame(width: 56, height: 34)
              
            HStack {
                if isOn {
                    Circle()
                        .strokeBorder(.black, lineWidth: 2)
                        .background(.white)
                        .clipShape(Circle())
                        .frame(width: 27, height: 27)
                        .padding(.trailing, 3)
                        .matchedGeometryEffect(id: "toggle", in: toggleNamespace)
                } else {
                    Circle()
                        .strokeBorder(.black, lineWidth: 2)
                        .background(.white)
                        .clipShape(Circle())
                        .frame(width: 27, height: 27)
                        .padding(.leading, 3)
                        .matchedGeometryEffect(id: "toggle", in: toggleNamespace)
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.05)) {
                isOn.toggle()
            }
        }
    }
}

struct OutlineToggle_Previews: PreviewProvider {
    static var previews: some View {
        OutlineToggle(isOn: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
