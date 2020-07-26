//
//  TobTabBarViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol TopTabBarDelegate: class {
    func topTabBarItemClicked(item: TopTabBarItem)
}

final class TopTabBarViewController: UIViewController {

    // MARK: - UI Properties

    private let scrollView: UIScrollView = UIScrollView()
    private let buttonStackView: UIStackView = UIStackView()
    private let indicatorView: UIView = UIView()
    private lazy var indicatorViewLeadingConstraint: NSLayoutConstraint = {
        return self.indicatorView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0)
    }()
    private lazy var indicatorViewTrailingingConstraint: NSLayoutConstraint = {
        return self.indicatorView.trailingAnchor.constraint(equalTo: self.indicatorView.leadingAnchor, constant: 0)
    }()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: TopTabBarViewModelType
    weak var delegate: TopTabBarDelegate?

    // MARK: - Lifecycle

    init(viewModel: TopTabBarViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setUpLayout()
        bindStyles()
        bindViewModel()

        viewModel.inputs.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func bindViewModel() {

        viewModel.outputs.tabBarItems()
            .drive(onNext: createButtons(items:))
            .disposed(by: disposeBag)

        viewModel.outputs.notifyClickedItem()
            .emit(onNext: delegate?.topTabBarItemClicked(item:))
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        view.backgroundColor = .yellow

        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        buttonStackView.alignment = .fill

        indicatorView.backgroundColor = .black
    }

    private func setUpLayout() {
        [buttonStackView, indicatorView]
            .addSubviews(parent: scrollView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            buttonStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            buttonStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.width),

            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            indicatorViewLeadingConstraint,
            indicatorViewTrailingingConstraint,

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func createButtons(items: [TopTabBarItem]) {
        items.enumerated().map { (index, item) in
            let btn = UIButton()
            btn.tag = index
            btn.setTitle(item.title, for: .normal)
            btn.addTarget(self, action: #selector(itemClicked(_:)), for: .touchUpInside)
            btn.backgroundColor = .white
            btn.setTitleColor(.black, for: .normal)
            return btn
        }.addArrangedSubviews(parent: buttonStackView)
    }

    @objc
    private func itemClicked(_ button: UIButton) {
        viewModel.inputs.itemClicked(index: button.tag)
        moveIndicator(index: button.tag)
    }

    private func moveIndicator(index: Int) {
        print("move indicator")
        let button = buttonStackView.arrangedSubviews[index]

        let leading = button.frame.origin.x
        let width = button.frame.width
        indicatorViewLeadingConstraint.constant = leading
        indicatorViewTrailingingConstraint.constant = width

    }
}
