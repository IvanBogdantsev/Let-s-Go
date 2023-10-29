//
//  HorizontalViewsScroller.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 25.10.2023.
//

import UIKit
import SnapKit

final class HorizontalViewScroller: UIScrollView {
    
    struct Ratio {
        let height: CGFloat
        let width: CGFloat
        var aspectRatio: CGFloat {
            width / height
        }
    }

    private let contentView = UIView()
    private let spacing: CGFloat
    private let cornerRadius: CGFloat
    private let ratio: Ratio

    init(frame: CGRect = .zero, spacing: CGFloat = 8, cornerRadius: CGFloat = 8, ratio: Ratio = Ratio(height: 16, width: 9)) {
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.ratio = ratio
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func insertImages(_ images: [UIImage?]) {
        var currentLeft = contentView.snp.left
        images.enumerated().forEach { index, image in
            guard let image = image else { return }
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = cornerRadius
            contentView.addSubview(imageView)

            imageView.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.top.equalToSuperview()
                $0.left.equalTo(currentLeft).offset(spacing)
                currentLeft = imageView.snp.right
                $0.width.equalTo(snp.height).multipliedBy(ratio.aspectRatio)
            }
        }

        if let lastImageView = contentView.subviews.last {
            lastImageView.snp.makeConstraints {
                $0.right.equalToSuperview().inset(spacing)
            }
        }
    }
    
    private func layout() {
        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
}
