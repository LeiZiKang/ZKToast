// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  Toast.swift
//  ZKToastSwiftUI
//
//  Created by 雷子康 on 2024/11/7.
//

import Foundation
import SwiftUI

// MARK: - Model
public struct Toast: Identifiable {
    private(set) public var id: String = UUID().uuidString
    var content: AnyView
    
    public init(@ViewBuilder content: @escaping (String) -> some View) {
        self.content = .init(content(id))
    }
    
    var offsetX: CGFloat = 0
    public var isDeleting: Bool = false
}


// MARK: - View
fileprivate struct ToastsView: View {
    @Binding var toasts: [Toast]
    @State private var isExpanded: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            if isExpanded {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isExpanded = false
                    }
            }
            
            let layout = isExpanded ? AnyLayout(VStackLayout(spacing: 10)) : AnyLayout(ZStackLayout())
            
            layout {
                ForEach($toasts) { $toast in
                    let index = (toasts.count - 1) - (toasts.firstIndex(where: { $0.id == toast.id }) ?? 0)
                    toast.content
                        .offset(x: toast.offsetX)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    let xOffet = value.translation.width < 0 ? value.translation.width : 0
                                    toast.offsetX = xOffet
                                })
                                .onEnded({ value in
                                    let xOffset = value.translation.width + (value.velocity.width / 2)
                                    
                                    if -xOffset > 200 {
                                        /// Remove Toast
                                        $toasts.delete(toast.id)
                                    } else {
                                        /// Reset Toast to it's inital Position
                                        toast.offsetX = 0
                                    }
                                })

                        )
                        .visualEffect { [isExpanded] content, proxy in
                            content
                                .scaleEffect(isExpanded ? 1 : scale(index), anchor: .bottom)
                                .offset(y: isExpanded ? 0 : offsetY(index))
                        }
                        .zIndex(toast.isDeleting ? 1000 : 0)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(insertion: .offset(y: 100), removal: .move(edge: .leading)))
                }
            }
            .onTapGesture {
                isExpanded.toggle()
            }
            .padding(.bottom, 15)
        }
        .animation(.bouncy, value: isExpanded)
        
        .onChange(of: toasts.isEmpty) { newValue in
            if newValue {
                isExpanded = false
            }
        }
    }
    
    nonisolated func offsetY(_ index: Int) -> CGFloat {
        let offset = min(CGFloat(index) * 15, 30)
        
        return -offset
    }
    
    nonisolated func scale(_ index: Int) -> CGFloat {
        let scale = min(CGFloat(index) * 0.1, 1)
        
        return 1 - scale
    }
}



// MARK: - func
extension Binding<[Toast]> {
    /// dismiss Toast
  public  func delete(_ id: String) {
        if let toast = first(where: { $0.id == id }) {
            toast.wrappedValue.isDeleting = true
        }
        withAnimation {
            self.wrappedValue.removeAll(where: { $0.id == id })
        }
    }
}

extension View {
    @ViewBuilder
   public func interactiveToasts(_ toasts: Binding<[Toast]>) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity) // !!!: you can change it appear from the top
            .overlay(alignment: .bottom) {
                ToastsView(toasts: toasts)
            }
    }
}
//#Preview {
//    ContentView()
//}
