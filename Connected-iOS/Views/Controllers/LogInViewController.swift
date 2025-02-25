//
//  LogInViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/19.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift

final class LogInViewController: UIViewController {

    // MARK: - UI Properties

    private let logoImageView: UIImageView = UIImageView()
    private let signUpBtn: UIButton = UIButton()
    private let signInBtn: UIButton = UIButton()

    // MARK: - Properties

    private var disposeBag = DisposeBag()
    private let viewModel: LogInViewModelType
    private weak var coordinator: LogInCoordinatorType?

    // MARK: - Lifecycle

    init(
        viewModel: LogInViewModelType,
        coordinator: LogInCoordinatorType
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Functions

    private func bindViewModel() {

        self.rx.deallocated
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.deinited()
            })
            .disposed(by: disposeBag)

        signUpBtn.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: viewModel.inputs.signUpClicked)
            .disposed(by: disposeBag)

        signInBtn.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: viewModel.inputs.signInClicked)
            .disposed(by: disposeBag)

        viewModel.outputs.pushViewController()
            .emit(onNext: navigate(to:))
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        self.view.backgroundColor = .white

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = #imageLiteral(resourceName: "Swift_logo_440px")

        signUpBtn.backgroundColor = .systemBlue
        signUpBtn.setTitle("SIGN UP", for: .normal)
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.layer.cornerRadius = 12

        signInBtn.setTitle("SIGN IN", for: .normal)
        signInBtn.setTitleColor(.black, for: .normal)
        signInBtn.layer.borderColor = UIColor.black.cgColor
        signInBtn.layer.borderWidth = 1
        signInBtn.layer.cornerRadius = 12
    }

    private func setUpLayout() {
        [logoImageView, signUpBtn, signInBtn]
            .addSubviews(parent: self.view)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            logoImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),

            signUpBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            signUpBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            signUpBtn.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 110),
            signUpBtn.heightAnchor.constraint(equalToConstant: 60),

            signInBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            signInBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            signInBtn.topAnchor.constraint(equalTo: signUpBtn.bottomAnchor, constant: 15),
            signInBtn.heightAnchor.constraint(equalToConstant: 60)

        ])
    }

    private func navigate(to data: LogInViewControllerData) {
        switch data {
        case .signUp:
            coordinator?.pushToSignUp()
        case .signIn:
            coordinator?.pushToSignIn()
        }
    }
}
