//
//  RootViewController.swift
//  Different
//
//  Created by nonplus on 3/3/21.
//

import Combine
import UIKit

class DiffableViewController: UIViewController {
    
    // MARK: - Private Views
    private let startButton = UIBarButtonItem(systemItem: .play)
    private let stopButton = UIBarButtonItem(systemItem: .pause)
    private let standardButton = UIBarButtonItem(title: "Standard")

    // MARK: - Private Instance Variables
    private var cancellables: Set<AnyCancellable> = []
    private var data = UIColor.randomColorSet(numberOfColors: 1000)
    private var operationQueue = OperationQueue()
    private var shuffleColors = true
    
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(SquareCell.self, forCellWithReuseIdentifier: SquareCell.description())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, UIColor>(collectionView: collectionView,
                                                                                   cellProvider: cellProvider)
    
    private lazy var layout: UICollectionViewCompositionalLayout = {

        let rawDimension = view.bounds.width / 5
        let squareDimension = NSCollectionLayoutDimension.absolute(rawDimension)
        let squareSize = NSCollectionLayoutSize(widthDimension: squareDimension, heightDimension: squareDimension)
        let squareItem = NSCollectionLayoutItem(layoutSize: squareSize)
        
        let squaresHeight = NSCollectionLayoutDimension.absolute(rawDimension)
        let squaresWidth = NSCollectionLayoutDimension.fractionalWidth(1)
        let squaresSize = NSCollectionLayoutSize(widthDimension: squaresWidth, heightDimension: squaresHeight)
        let squaresGroup = NSCollectionLayoutGroup.horizontal(layoutSize: squaresSize, subitems: [squareItem])
        
        let squaresSection = NSCollectionLayoutSection(group: squaresGroup)
        
        return UICollectionViewCompositionalLayout(section: squaresSection)
    }()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    // MARK: - Public Methods
    
    @objc
    func toggleTimer() {
        if cancellables.count > 0 {
            navigationItem.leftBarButtonItem = startButton
            stopTimer()
        } else {
            navigationItem.leftBarButtonItem = stopButton
            startTimer()
        }
    }
    
    @objc
    func pushStandardViewController() {
        navigationController?.pushViewController(StandardViewController(), animated: true)
    }
    
    // MARK: - Private Methods
    
    // MARK: - Data Methods
    private func setupData() {
        data.shuffle()
        for section in Section.allCases {
            var initialSnapshot = NSDiffableDataSourceSectionSnapshot<UIColor>()
            initialSnapshot.append(data)
            DispatchQueue.main.async { [weak self] in
                UIView.animate(withDuration: 1) { [weak self] in
                    self?.view.backgroundColor = UIColor.random
                }
                self?.dataSource.apply(initialSnapshot, to: section, animatingDifferences: true, completion: {})
            }
        }

    }
    
    // MARK: - View Methods
    private func setupViews() {
        title = "Different"
        navigationController?.navigationItem.prompt = "poop"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(collectionView)
        
        startButton.target = self
        startButton.action = #selector(toggleTimer)
        stopButton.target = self
        stopButton.action = #selector(toggleTimer)
        standardButton.target = self
        standardButton.action = #selector(pushStandardViewController)
        
        navigationItem.setLeftBarButton(startButton, animated: true)
        navigationItem.setRightBarButton(standardButton, animated: true)
        navigationController?.navigationBar.tintColor = .label

        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    private func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, color: UIColor) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquareCell.description(), for: indexPath)
        cell.backgroundColor = color
        return cell
    }
    
    // MARK: - Timer Methods
    private func startTimer() {
        stopTimer()
        Timer
            .publish(every: 2, tolerance: 0.5, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] date in
                self?.operationQueue.addOperation { [weak self] in
                    self?.setupData()
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func stopTimer() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    // MARK: - Private Types

    private enum Section: CaseIterable {
        case main
    }
    
}
