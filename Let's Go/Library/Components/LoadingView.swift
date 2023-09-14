//
//  LoadingView.swift
//  FlightGuide
//
//  Created by Eugene Kleban on 16.05.23.
//

import UIKit
import SnapKit

final class LoadingView: UIView {
    
    private(set) lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.style = UIActivityIndicatorView.Style.large
        view.startAnimating()
        view.hidesWhenStopped = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialise() {
        backgroundColor = .white.withAlphaComponent(0.1)
        addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
