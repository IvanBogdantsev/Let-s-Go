//
//  EventPreviewView.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 18.10.2023.
//

import UIKit

final class EventPreviewView: UIView {
    
    let contentView = UIView()
    let scrollView = UIScrollView()
    let horizontalViewScroller = HorizontalViewScroller()
    let stackView = UIStackView(axis: .vertical, spacing: 4)
    let eventTitleLabel = UILabel()
    let numberOfParticipantsLabel = UILabel()
    let costLabel = UILabel()
    let dateLabel = UILabel()
    let durationLabel = UILabel()
    let descriptionLabel = UILabel()
    let detailsButton = UIButton()
    let chatButton = UIButton()
    let buttonsStackView = UIStackView(axis: .horizontal, spacing: 4)
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        layout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        buttonsStackView.addArrangedSubviews(detailsButton, chatButton)
        stackView.addArrangedSubviews(eventTitleLabel, numberOfParticipantsLabel, costLabel, dateLabel, durationLabel, buttonsStackView, horizontalViewScroller, descriptionLabel)
        stackView.setCustomSpacing(12, after: durationLabel)
        stackView.setCustomSpacing(12, after: buttonsStackView)
        stackView.setCustomSpacing(8, after: horizontalViewScroller)
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.right.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.width.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.right.equalToSuperview().inset(8)
        }
        horizontalViewScroller.snp.makeConstraints {
            $0.height.equalTo(244)
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
        
        buttonsStackView.distribution = .fillEqually
        detailsButton.defaultStyleBoldedRed()
        detailsButton.setTitle(Strings.details.capitalized, for: .normal)
        chatButton.defaultStyleGray()
        chatButton.setTitle(Strings.chat.capitalized, for: .normal)
    }
    
}
