//
//  EventPageViewModelView.swift
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import UIKit

final class EventPageView: UIView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {}
    
    private func setStyle() {
        backgroundColor = Colors.letsgo_main_gray
    }
    
}
