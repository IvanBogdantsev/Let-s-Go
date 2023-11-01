//
//  CreatorPreview.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 31.10.2023.
//

import UIKit
import AlamofireImage

final class CreatorPreview: UserPreview {
    
    private enum Dimensions {
        static let diameter: CGFloat = 66
    }
    
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setWithUser(_ user: User) {
        super.setWithUser(user)
        descriptionLabel.text = user.smallDescription
    }
    
    override func layout() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = Dimensions.diameter / 2
        avatarImageView.contentMode = .scaleAspectFill
        addSubviews(avatarImageView, nameLabel, descriptionLabel)
        avatarImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.width.equalTo(Dimensions.diameter)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(avatarImageView.snp.right).offset(8)
            $0.right.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.left.equalTo(avatarImageView.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    override func setStyle() {
        nameLabel.font = UIFont.letsgo_headline()
        nameLabel.textColor = Colors.letsgo_white
        descriptionLabel.font = UIFont.letsgo_subhead()
        descriptionLabel.textColor = Colors.letsgo_light_gray
    }
    
}
