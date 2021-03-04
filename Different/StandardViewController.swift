//
//  StandardViewController.swift
//  Different
//
//  Created by nonplus on 3/4/21.
//

import UIKit

class StandardViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(SquareCell.self, forCellWithReuseIdentifier: SquareCell.description())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - View Methods
    private func setupViews() {
        title = "Standardarino"
        navigationController?.navigationItem.prompt = "poop"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(collectionView)
        
//        startButton.target = self
//        startButton.action = #selector(toggleTimer)
//        stopButton.target = self
//        stopButton.action = #selector(toggleTimer)
        
//        navigationItem.setLeftBarButton(startButton, animated: true)
//        navigationItem.setRightBarButton(standardButton, animated: true)
        navigationController?.navigationBar.tintColor = .label

        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }

}

extension StandardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquareCell.description(), for: indexPath)
        cell.backgroundColor = color
        return cell
    }
}

extension StandardViewController: UICollectionViewDelegate {}
