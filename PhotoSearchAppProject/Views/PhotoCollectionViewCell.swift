//
//  PhotoCollectionViewCell.swift
//  PhotoSearchApp
//
//  Created by Sarper Kececi on 16.02.2024.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
       
    }
    
    override func layoutSubviews() {
        posterImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
    }
    public func configure(with photo: Photo) {
        if let url = URL(string: photo.urls?.regular ?? "nil") {
            posterImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
