#  ZKToast

## description
the toast for swiftUI

## platform

iOS 17 

## usage:

``` swift
import SwiftUI
import ZKToast

struct ContentView: View {
    /// add the toast property
    @State private var toasts: [Toast] = []
    var body: some View {
        NavigationStack {
            List {
                Text("Dumy List Row View")
            }
            .navigationTitle("Toast")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showToast()
                    } label: {
                        Text("Show")
                    }
                }
            }
        }
        .interactiveToasts($toasts)
    }
    @MainActor
    func showToast() {
        withAnimation {
            let toast = Toast { id in
                ToastView(id)
            }
            
            self.toasts.append(toast)
        }
    }
    /// customize your toast UI
    @ViewBuilder
    func ToastView(_ id: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "square.and.arrow.up.fill")
            
            Text("Hello World")
                .font(.callout)
            
            Spacer(minLength: 0)
            
            Button {
                // MARK: remove toast
                $toasts.delete(id)
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
}

```

### Inspired by [kavsoft](https://kavsoft.dev/)

