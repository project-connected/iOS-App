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
    func topTabBarItemClicked(index: Int, item: ProjectState)
}

final class TopTabBarViewController: UIViewController {

    // MARK: - UI Properties
    private let scrollView: UIScrollView = UIScrollView()
    private let stackView: UIStackView = UIStackView()
    private let indicatorView: UIView = UIView()
    private lazy var indicatorLeadingConstraint: NSLayoutConstraint = {
        return self.indicatorView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor)
    }()
    private lazy var indicatorTrailingConstraint: NSLayoutConstraint = {
        return self.indicatorView.trailingAnchor.constraint(equalTo: self.indicatorView.leadingAnchor)
    }()

    // MARK: - Properties

    private var disposeBag = DisposeBag()
    private let viewModel: TopTabBarViewModelType
    weak var delegate: TopTabBarDelegate?

    // MARK: - Lifecycle

    init(
        viewModel: TopTabBarViewModelType
    ) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setUpLayout()
        bindStyles()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        viewModel.inputs.deinited()
    }

    // MARK: - Functions

    private func bindViewModel() {

        viewModel.outputs.tabBarItems()
            .drive(onNext: createButtons)
            .disposed(by: disposeBag)

        viewModel.outputs.notifyClickedItem()
            .emit(onNext: { self.delegate?.topTabBarItemClicked(index: $0.0, item: $0.1) })
            .disposed(by: disposeBag)

        viewModel.outputs.selectedItem()
            .drive(onNext: updateSelectedItem(index:))
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        scrollView.backgroundColor = .white

        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        scrollView.showsHorizontalScrollIndicator = false

        indicatorView.backgroundColor = .black
    }

    private func setUpLayout() {
        [stackView, indicatorView]
            .addSubviews(parent: scrollView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -2),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            indicatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            indicatorLeadingConstraint,
            indicatorTrailingConstraint,

            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }

    private func updateSelectedItem(index: Int) {
        guard index < stackView.arrangedSubviews.count else {
            return
        }

        stackView.arrangedSubviews
            .forEach { view in
                guard let btn = view as? UIButton else { return }
                btn.isSelected = (btn.tag == index)
            }

        let frame = stackView.arrangedSubviews[index].frame
        let leading = frame.origin.x + stackView.frame.origin.x
        let trailing = frame.width
        indicatorLeadingConstraint.constant = leading
        indicatorTrailingConstraint.constant = trailing

        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let `self` = self else { return }

            self.scrollView.layoutIfNeeded()

            if leading < self.scrollView.contentOffset.x {
                self.scrollView.contentOffset.x -= self.scrollView.contentOffset.x - leading
            } else {
                let left = leading + trailing
                let width = self.scrollView.contentOffset.x + self.scrollView.bounds.width
                if left > width {
                    self.scrollView.contentOffset.x += left - width
                }
            }
        }
    }

    private func createButtons(items: [(Int, ProjectState)]) {
        items.map { index, item in
            let btn = UIButton()
            btn.tag = index
            btn.sizeToFit()
            btn.setTitle(item.string, for: .normal)
            btn.setTitleColor(.gray, for: .normal)
            btn.setTitleColor(.black, for: .selected)
            btn.backgroundColor = .white
            btn.addTarget(self, action: #selector(itemClicked), for: .touchUpInside)
            return btn
        }
        .addArrangedSubviews(parent: stackView)
        .setTranslatesAutoresizingMaskIntoConstraints()
        .forEach { btn in
            NSLayoutConstraint.activate([
                btn.widthAnchor.constraint(
                    greaterThanOrEqualTo: view.widthAnchor,
                    multiplier: 1.0/CGFloat(stackView.arrangedSubviews.count),
                    constant: 10
                ),
                btn.widthAnchor.constraint(
                    lessThanOrEqualTo: view.widthAnchor,
                    multiplier: 0.5
                ),
                btn.topAnchor.constraint(equalTo: scrollView.topAnchor),
                btn.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -2)
            ])
        }
    }

    @objc
    private func itemClicked(_ sender: UIButton) {
        viewModel.inputs.itemClicked(index: sender.tag)
    }

    func selectItem(index: Int) {
        viewModel.inputs.selectItem(index: index)
    }

    func setProjectStates(projectStates: [ProjectState]) {
        viewModel.inputs.projectStates(states: projectStates)
    }
}
