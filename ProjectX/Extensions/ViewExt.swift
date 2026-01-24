//
//  ViewExt.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/24/26.
//

import SwiftUI

extension View {
    func toast(
        isPresented: Binding<Bool>,
        duration: TimeInterval = 3.0,
        icon: String? = nil,
        message: String,
        tint: Color? = nil
    ) -> some View {
        modifier(
            ToastPresenter(
                isPresented: isPresented,
                duration: duration,
                icon: icon,
                message: message,
                tint: tint
            )
        )
    }
}
