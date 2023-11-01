//
//  UserPreview.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 30.10.2023.
//

import UIKit
import AlamofireImage

class UserPreview: UIView {
    
    private enum Dimensions {
        static let diameter: CGFloat = 56
    }
    
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithUser(_ user: User) {
        if let url = user.photoURL {
            self.avatarImageView.af.setImage(
                withURL: url,
                placeholderImage: Images.default_event_pic,
                filter: CircleFilter(),
                imageTransition: .crossDissolve(AnimationDuration.microRegular.timeInterval),
                runImageTransitionIfCached: false
            )
        }
        nameLabel.text = user.name
    }
    
    func layout() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = Dimensions.diameter / 2
        avatarImageView.contentMode = .scaleAspectFill
        addSubviews(avatarImageView, nameLabel)
        avatarImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.width.equalTo(Dimensions.diameter)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(4)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func setStyle() {
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.letsgo_subhead()
        nameLabel.textColor = Colors.letsgo_white
    }
    
}
