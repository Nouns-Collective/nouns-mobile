//
//  SwiftUIView.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-01.
//

import SwiftUI

public struct BottomSheet<SheetContent: View>: ViewModifier {
    
    /// A binding boolean value to indicate whether or not the bottom sheet should be shown
    @Binding var isPresented: Bool {
        didSet {
            translation = 0
        }
    }
    
    /// The current drag translation of the bottom sheet's drag gesture
    @State private var translation: CGFloat = 0
    
    /// The last recorded drag value of the bottom sheet's drag gesture
    @State private var lastDragPosition: DragGesture.Value?
    
    /// A view to be the shown as the main content in the bottom sheet
    private let sheetContent: SheetContent
    
    /// Initializes a view modification with a binding boolean for presentation and any content for a bottom sheet
    ///
    ///
    /// - Parameters:
    ///   - isPresented: A binding boolean value to indicate whether or not the bottom sheet should be shown
    ///   - content: Any view to be the content of the bottom sheet
    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.sheetContent = content()
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isPresented.toggle()
                    }
                
                VStack {
                    Spacer()
                    
                    sheetContent
                        .zIndex(1)
                        .padding(.bottom, 20)
                        .background(Color.white)
                        .cornerRadius(32, corners: [.topLeft, .topRight])
                        .offset(x: 0, y: translation)
                        .gesture(
                            DragGesture()
                                .onChanged { self.dragChanged($0) }
                                .onEnded { self.dragEnded($0) }
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 24, x: 0, y: 0)
                        .frame(maxWidth: .infinity)
                }
                .ignoresSafeArea()
                .transition(.move(edge: .bottom))
                .animation(.spring())
            }
        }
    }
    
    private func dragChanged(_ value: DragGesture.Value) {
        if value.translation.height > 0 {
            lastDragPosition = value
            translation = value.translation.height
        }
    }
    
    private func dragEnded(_ value: DragGesture.Value) {
        var speed: CGFloat = 0
        
        if let lastDragPosition = lastDragPosition {
            let timeDiff = value.time.timeIntervalSince(lastDragPosition.time)
            speed = CGFloat(value.translation.height - lastDragPosition.translation.height) / CGFloat(timeDiff)
        }
        
        if speed > 10 || translation > 200 {
            self.isPresented = false
        } else {
            self.translation = 0
        }
    }
}

extension View {
    /// An extension to any view to add a conditional bottom sheet to the the screen.
    /// It takes a binding boolean value and any content to place within the sheet
    ///
    /// An example of using this view modifier is:
    /// ```swift
    /// NavigationView {
    ///     Button(action: {
    ///         isPresented.toggle()
    ///     }, label: {
    ///         Text("Click Me")
    ///     })
    /// }
    /// .bottomSheet(isPresented: $isPresented) {
    ///     Text("Sheet Content")
    /// }
    /// ```
    ///
    /// Note: Bottom sheets should only be attached to views that take up the entire screen, such as a full-size VStack or NavigationView,
    /// to ensure proper placement and sizing
    ///
    /// - Parameters:
    ///   - isPresented: A binding boolean value to indicate whether or not the bottom sheet should be shown
    ///   - content: Any view to be the content of the bottom sheet
    public func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        return modifier(BottomSheet(isPresented: isPresented, content: content))
    }
}

// TODO: - Just an example for the review process, will remove once approved.
struct BindingContainer : View {
     @State private var isPresented = false

     var body: some View {
         Button(action: {
            isPresented.toggle()
         }, label: {
             Text("Click Me")
         })
         .bottomSheet(isPresented: $isPresented) {
             VStack(alignment: .center, spacing: 8) {
                 Text("Are you sure you want to cancel?")
                     .bold()
                     .padding(.bottom, 8)
                 Text("Yes")
                     .bold()
                     .padding()
                     .foregroundColor(Color.black.opacity(0.4))
                 Divider()
                 Text("No")
                     .bold()
                     .padding()
                     .foregroundColor(Color.black.opacity(0.4))
             }.padding(24)
         }
     }
}

struct BottomSheet_Provider: PreviewProvider {
    static var previews: some View {
        BindingContainer()
    }
}
