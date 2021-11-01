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
    @State var translation: CGFloat = 0
    
    /// The last recorded drag value of the bottom sheet's drag gesture
    @State var lastDragPosition: DragGesture.Value?
    
    let sheetContent: SheetContent
    
    /// Initializes a view modification with a binding boolean for presentation and any content for a bottom sheet
    ///
    ///
    /// - Parameters:
    ///   - isPresented: A binding boolean value to indicate whether or not the bottom sheet should be shown
    ///   - content: Any view to be the content of the bottom sheet
    init(
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
                                .onChanged { gesture in
                                    if gesture.translation.height > 0 {
                                        self.lastDragPosition = gesture
                                        self.translation = gesture.translation.height
                                    }
                                }
                                .onEnded { gesture in
                                    let timeDiff = gesture.time.timeIntervalSince(self.lastDragPosition!.time)
                                    let speed: CGFloat = CGFloat(gesture.translation.height - self.lastDragPosition!.translation.height) / CGFloat(timeDiff)
                                    
                                    if speed > 10 || translation > 200 {
                                        self.isPresented = false
                                    } else {
                                        self.translation = 0
                                    }
                                }
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
}

extension View {
    /// An extension to any view to add a conditional bottom sheet to the the screen.
    /// It takes a binding boolean value and any content to place within the sheet
    ///
    /// An example of using this view modifier is:
    /// ```swift
    /// NavigationView {
    ///     Text("Hello World")
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
    func bottomSheet<Content: View>(
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
