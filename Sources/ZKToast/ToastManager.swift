//
//  ToastManager.swift
//  PhoneClone
//
//  Created by 雷子康 on 2024/11/8.
//

import Foundation
import SwiftUI
import ZKToast

public final class ToastManager: ObservableObject {
    
    @MainActor
    @Published public var toasts: [Toast] = []
    
    public init() {}
    
    
    @MainActor
    public func showToast(@ViewBuilder content: @escaping() -> any View) {
        withAnimation {
            let toast = Toast { id in
                HStack(spacing: 12) {
                    
                    AnyView(content())
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        // MARK: remove toast
                        Task { @MainActor in
                            self.deleteToast(id)
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                    }
                }
                .foregroundStyle(Color.primary)
                .padding(.vertical, 12)
                .padding(.leading, 15)
                .padding(.trailing, 10)
                .background {
                    Capsule()
                        .fill(.background)
                        .shadow(color: .black.opacity(0.06), radius: 3, x: -1, y: -3)
                        .shadow(color: .black.opacity(0.06), radius: 2, x: 1, y: 3)
                }
                .padding(.horizontal, 15)
            }
            self.toasts.append(toast)
        }
    }
    
    
    @MainActor
    func deleteToast(_ id: String) {
        if let index = self.toasts.firstIndex(where: { $0.id == id }) {
            self.toasts[index].isDeleting = true
        }
        withAnimation {
            self.toasts.removeAll(where: { $0.id == id })
        }
    }
    
    @MainActor
    public func removeAll() {
        withAnimation {
            self.toasts.removeAll()
        }
    }
}


