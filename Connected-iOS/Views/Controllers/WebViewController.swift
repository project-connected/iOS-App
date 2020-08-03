//
//  WebViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/30.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

final class WebViewController: UIViewController {

    // MARK: - UI Properties

    // MARK: - Properties

    private var disposeBag = DisposeBag()
    private let viewModel: WebViewModelType

    // MARK: - Lifecycle

    init(
        viewModel: WebViewModelType
    ) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLayout()
        bindStyles()
        bindViewModel()

        self.view.backgroundColor = .white
        let label = UILabel()
        label.text = "WebView"
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    // MARK: - Functions

    private func bindViewModel() {
        self.rx.deallocated
            .bind(onNext: {[weak self] in
                self?.viewModel.inputs.deinited()
            })
            .disposed(by: disposeBag)
    }

    private func bindStyles() {

    }

    private func setUpLayout() {

    }
}
