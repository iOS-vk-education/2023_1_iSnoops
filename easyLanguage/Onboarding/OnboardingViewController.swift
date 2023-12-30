//
//  OnboardingViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.12.2023.
//

import UIKit

struct OnboardingSlide {
    let title: String
    let image: UIImage?
}

final class OnboardingViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            OnboardingCollectionViewCell.self,
            forCellWithReuseIdentifier: "OnboardingCollectionViewCell"
        )
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private let nextButton = UIButton()
    private let pageControl = UIPageControl()

    var slides: [OnboardingSlide] = []

    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle(NSLocalizedString("nextButtonStartTitle", comment: ""), for: .normal)
            } else {
                nextButton.setTitle(NSLocalizedString("nextButtonContinueTitle", comment: ""), for: .normal)
            }
        }
    }
}

// MARK: - life cycle
extension OnboardingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setAppearance()
        addConstraints()
    }
}

// MARK: - set appearance
private extension OnboardingViewController {
    func setAppearance() {
        view.backgroundColor = .PrimaryColors.Background.background

        slides = [
            OnboardingSlide(title: NSLocalizedString("gameplayLanguageLearningTitle", comment: ""),
                            image: UIImage(named: "OnboardingIcon")),
            OnboardingSlide(title: NSLocalizedString("createCustomCategoriesTitle", comment: ""),
                            image: UIImage(named: "OnboardingCategories")),
            OnboardingSlide(title: NSLocalizedString("swipeBasedLanguageLearningTitle", comment: ""),
                            image: UIImage(named: "OnboardingLearning"))
        ]

        setPageControlAppearance()
        setNextButtonAppearance()
    }

    func setPageControlAppearance() {
        pageControl.numberOfPages = slides.count
        pageControl.currentPageIndicatorTintColor = .PrimaryColors.Button.blue
        pageControl.pageIndicatorTintColor = .systemGray4
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
    }

    func setNextButtonAppearance() {
        nextButton.setTitle(NSLocalizedString("nextButtonContinueTitle", comment: ""), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.backgroundColor = .PrimaryColors.Button.blue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }

    @objc
    private func nextButtonTapped() {
        if currentPage == slides.count - 1 {
            let controller = TabBarController()
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "onboardingCompleted")
        } else if currentPage < slides.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    @objc
    private func pageControlValueChanged() {
        let newPage = pageControl.currentPage
        let indexPath = IndexPath(item: newPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentPage = newPage
    }
}

// MARK: - set constraints
private extension OnboardingViewController {
    func addConstraints() {
        [collectionView, pageControl, nextButton].forEach {
            view.addSubview($0)
        }
        setCollectionView()
        setNextButton()
        setPageControl()
    }

    func setCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
    }

    func setNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -25).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    func setPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                            constant: -view.bounds.height / 20).isActive = true
    }
}

// MARK: - UICollectionViewDelegates
extension OnboardingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                         "OnboardingCollectionViewCell", for: indexPath) as? OnboardingCollectionViewCell
        else {
            return .init()
        }
        cell.setup(slides[indexPath.row])
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
