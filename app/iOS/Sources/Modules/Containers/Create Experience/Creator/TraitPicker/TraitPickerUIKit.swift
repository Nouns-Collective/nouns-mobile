//
//  TraitPickerUIKit.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2022-04-05.
//

import UIKit
import SwiftUI
import UIComponents
import Combine

final class TraitPickerUIKitView: UIViewRepresentable {
  typealias UIViewType = TraitPickerUIKit
  
  @ObservedObject var viewModel: NounCreator.ViewModel
  
  private var cancellables = Set<AnyCancellable>()
  
  init(viewModel: NounCreator.ViewModel) {
    self.viewModel = viewModel
  }
  
  func makeUIView(context: Context) -> TraitPickerUIKit {
    let grid = TraitPickerUIKit(viewModel: viewModel)
    return grid
  }
  
  func updateUIView(_ uiView: TraitPickerUIKit, context: Context) {
    //
  }
}

class TraitPickerUIKit: UIView {
  
  @ObservedObject var viewModel: NounCreator.ViewModel
  
  private var cancellables = Set<AnyCancellable>()
  
  private let traitTypes = TraitType.allCases
  
  private lazy var collectionViewLayout: UICollectionViewCompositionalLayout = {
    let fraction: CGFloat = 1 / 3
    let itemInset: CGFloat = 2.5
    let sectionInset: CGFloat = 5.0
    
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(fraction))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(fraction), heightDimension: .fractionalHeight(1))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
    
    return UICollectionViewCompositionalLayout(section: section, configuration: config)
  }()
  
  private lazy var collectionView: UICollectionView = {
    let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.register(TraitItemCell.self, forCellWithReuseIdentifier: TraitItemCell.reuseIdentifier)
    cv.delegate = self
    cv.dataSource = self
    cv.showsHorizontalScrollIndicator = false
    cv.showsVerticalScrollIndicator = false
    cv.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    cv.allowsSelection = true
    cv.allowsMultipleSelection = true
    return cv
  }()
  
  init(viewModel: NounCreator.ViewModel) {
    self.viewModel = viewModel
    
    super.init(frame: .zero)
    setupViews()
    subscribeToChanges()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  func subscribeToChanges() {
    viewModel.tapPublisher
      .sink { [weak self] newTraitType in
        guard let sectionIndex = self?.traitTypes.firstIndex(of: newTraitType) else { return }
        self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: sectionIndex), at: .left, animated: true)
      }
      .store(in: &cancellables)
  }
  
  func setupViews() {
    addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.heightAnchor.constraint(equalToConstant: 250)
    ])
  }
}

extension TraitPickerUIKit: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return traitTypes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let traitType = traitTypes[section]
    
    switch traitType {
    case .background:
      return NounCreator.backgroundColors.count
    default:
      return traitType.traits.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TraitItemCell.reuseIdentifier, for: indexPath) as? TraitItemCell else {
      return UICollectionViewCell()
    }
    
    cell.setupViews()
    
    if traitTypes[indexPath.section] == .background {
      let gradient = NounCreator.backgroundColors[indexPath.row]
      let colors = gradient.colors.map { UIColor($0) }
      cell.setBackgroundGradient(colors: colors)
    } else {
      let trait = traitTypes[indexPath.section].traits[indexPath.row]
      cell.setImage(trait.assetImage)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: false) })
    return true
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    self.viewModel.selectTrait(indexPath.row, ofType: self.traitTypes[indexPath.section])
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
    let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    guard let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
    viewModel.currentModifiableTraitType = traitTypes[visibleIndexPath.section]
  }
}

fileprivate final class TraitItemCell: UICollectionViewCell {
  
  static let reuseIdentifier = "traitItemCell"
  
  private var image: String?
  
  override var isSelected: Bool {
    didSet {
      UIView.animate(withDuration: 0.15) {
        self.layer.borderColor = self.isSelected ? UIColor(Color.componentNounsBlack).cgColor : nil
        self.layer.borderWidth = self.isSelected ? 2.0 : 0
      }
    }
  }
  
  lazy private var imageView: UIImageView = {
    let imgView = UIImageView()
    imgView.translatesAutoresizingMaskIntoConstraints = false
    imgView.contentMode = .scaleAspectFit
    imgView.layer.magnificationFilter = .nearest
    return imgView
  }()
  
  lazy private var gradientView: UIView = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupViews() {
    backgroundColor = UIColor(Color.componentSoftGrey)
    layer.cornerRadius = 8
    layer.masksToBounds = true
    
    addSubview(gradientView)
    gradientView.translatesAutoresizingMaskIntoConstraints = false
    
    for sublayer in gradientView.layer.sublayers ?? [] {
      sublayer.removeFromSuperlayer()
    }
    
    NSLayoutConstraint.activate([
      gradientView.leftAnchor.constraint(equalTo: leftAnchor),
      gradientView.rightAnchor.constraint(equalTo: rightAnchor),
      gradientView.topAnchor.constraint(equalTo: topAnchor),
      gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
    imageView.image = nil
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.leftAnchor.constraint(equalTo: leftAnchor),
      imageView.rightAnchor.constraint(equalTo: rightAnchor),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func setImage(_ image: String?) {
    self.image = image
    
    guard let image = image else {
      imageView.image = nil
      return
    }
    
    imageView.image = UIImage(nounTraitName: image)
  }
  
  func setBackgroundGradient(colors: [UIColor]) {
    let gradient = CAGradientLayer()
    
    gradient.frame = gradientView.bounds
    gradient.colors = colors.map { $0.cgColor }
    
    gradientView.layer.insertSublayer(gradient, at: 0)
  }
}
