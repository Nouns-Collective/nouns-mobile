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
    
    /// A boolean value to show or hide the dimming view beneath the sheet and above the underlying content
    private let showDimmingView: Bool
    
    /// Initializes a view modification with a binding boolean for presentation and any content for a bottom sheet
    ///
    ///
    /// - Parameters:
    ///   - isPresented: A binding boolean value to indicate whether or not the bottom sheet should be shown
    ///   - content: Any view to be the content of the bottom sheet
    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> SheetContent,
        showDimmingView: Bool = true
    ) {
        self._isPresented = isPresented
        self.sheetContent = content()
        self.showDimmingView = showDimmingView
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .zIndex(1)
            
            if isPresented {
                Color.black
                    .zIndex(2)
                    .opacity(showDimmingView ? 0.2 : 0)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isPresented.toggle()
                        }
                    }
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    sheetContent
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.black, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .offset(x: 0, y: translation)
                        .gesture(
                            DragGesture()
                                .onChanged { self.dragChanged($0) }
                                .onEnded { self.dragEnded($0) }
                        )
                }
                .zIndex(3)
                .transition(.move(edge: .bottom))
                .animation(.spring(), value: isPresented)
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
struct BindingContainer: View {
     @State private var isPresented = true

     var body: some View {
         Button(action: {
            isPresented.toggle()
         }, label: {
             Text("Click Me")
         })
         .bottomSheet(isPresented: $isPresented) {
             VStack(alignment: .leading, spacing: 20) {
                 Text("What is this?")
                     .font(Font.title.bold())
                 Text("Each noun is a member of the Nouns DAO and entitled to one vote in all governance matters. This means, once Noun 62 was owned by beautifulpunks.eth, they could vote on proposals to the DAO and this is their voting activity.")
                     .font(.body)
             }
             .padding(16)
            .padding(.bottom, 4)
         }
     }
}

struct BottomSheet_Provider: PreviewProvider {
    static var previews: some View {
        BindingContainer()
    }
}
