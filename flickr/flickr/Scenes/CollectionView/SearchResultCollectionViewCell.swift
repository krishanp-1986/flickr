//
//  SearchResultCollectionViewCell.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import UIKit
import SnapKit

class SearchResultCollectionViewCell: UICollectionViewCell, Reusable {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Private
    
    private func buildUI() {
        self.cardView.addSubViews(resultImage, titleLabel)
        self.contentView.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        resultImage.snp.makeConstraints({
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(resultImage.snp.width).multipliedBy(0.75)
        })
        
        titleLabel.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview().inset(8)
            $0.top.equalTo(resultImage.snp.bottom).offset(8)
        })
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    
    private lazy var cardView: CardView = {
        let cardView = CardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private lazy var resultImage: UIImageView = {
        let imageView = UIImageView()
        imageView.roundedCorners(maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

extension SearchResultCollectionViewCell {
    func configure(_ cellViewModel: ImageCollectionViewCellViewModel) {
        self.titleLabel.text = cellViewModel.title
        self.resultImage.loadImage(urlString: cellViewModel.imageUrl)
    }
}

