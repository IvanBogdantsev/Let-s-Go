//
//  EventPageViewModelView.swift
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import UIKit

final class EventPageView: UIView {
    
    let contentView = UIView()
    let scrollView = UIScrollView()
    let eventImagesScroller = HorizontalViewScroller()
    let stackView = UIStackView(axis: .vertical, spacing: 4)
    let eventTitleLabel = UILabel()
    let numberOfParticipantsLabel = UILabel()
    let costLabel = UILabel()
    let dateLabel = UILabel()
    let durationLabel = UILabel()
    let descriptionLabel = UILabel()
    let creatorStackView = UIStackView(axis: .vertical, spacing: 4)
    let creatorLabel = UILabel()
    let creatorView = CreatorPreview()
    let participantsStackView = UIStackView(axis: .vertical, spacing: 4)
    let participantsLabel = UILabel()
    let participantsScroller = HorizontalViewScroller()
    let activeUsersStackView = UIStackView(axis: .vertical, spacing: 4)
    let activeUsersLabel = UILabel()
    let activeUsersScroller = HorizontalViewScroller()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layout()
        setStyle()
        creatorLabel.text = Strings.creator
        participantsLabel.text = Strings.go
        activeUsersLabel.text = Strings.active
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        contentView.addSubview(creatorStackView)
        contentView.addSubview(participantsStackView)
        contentView.addSubview(activeUsersStackView)
        contentView.addSubview(descriptionLabel)
        creatorStackView.addArrangedSubviews(creatorLabel, creatorView)
        participantsStackView.addArrangedSubviews(participantsLabel, participantsScroller)
        activeUsersStackView.addArrangedSubviews(activeUsersLabel, activeUsersScroller)
        
        stackView.addArrangedSubviews(eventImagesScroller, eventTitleLabel, numberOfParticipantsLabel, costLabel, dateLabel, durationLabel)
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.right.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.width.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.left.right.equalToSuperview().inset(8)
        }
        eventImagesScroller.snp.makeConstraints {
            $0.height.equalTo(324)
        }
        creatorStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(8)
            $0.top.equalTo(stackView.snp.bottom).offset(12)
        }
        participantsStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(8)
            $0.top.equalTo(creatorStackView.snp.bottom).offset(12)
        }
        activeUsersStackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(8)
            $0.top.equalTo(participantsStackView.snp.bottom).offset(12)
        }
        descriptionLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview().inset(8)
            $0.top.equalTo(activeUsersStackView.snp.bottom).offset(12)
        }
    }
    
    private func setStyle() {
        scrollView.showsVerticalScrollIndicator = false
        backgroundColor = Colors.letsgo_main_gray
        eventTitleLabel.font = UIFont.letsgo_headline(size: 24)
        numberOfParticipantsLabel.font = UIFont.letsgo_subhead()
        costLabel.font = UIFont.letsgo_subhead()
        dateLabel.font = UIFont.letsgo_subhead()
        durationLabel.font = UIFont.letsgo_subhead()
        descriptionLabel.font = UIFont.letsgo_callout()
        
        eventTitleLabel.textColor = Colors.letsgo_light_gray
        numberOfParticipantsLabel.textColor = Colors.letsgo_light_gray
        costLabel.textColor = Colors.letsgo_light_gray
        dateLabel.textColor = Colors.letsgo_light_gray
        durationLabel.textColor = Colors.letsgo_light_gray
        descriptionLabel.textColor = Colors.letsgo_white
        
        eventTitleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0
        
        creatorLabel.font = UIFont.letsgo_headline()
        participantsLabel.font = UIFont.letsgo_headline()
        activeUsersLabel.font = UIFont.letsgo_headline()
        
        creatorLabel.textColor = Colors.letsgo_white
        participantsLabel.textColor = Colors.letsgo_white
        activeUsersLabel.textColor = Colors.letsgo_white
    }
    
}
