//
//  MainViewController.swift
//  EdoctorDlvnSdkExample
//
//  Created by Tran Minh Dat on 4/12/25.
//

import UIKit
import EdoctorDlvnSdk

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private var isAuthenticated = false
    private var selectedEnv: Env = .SANDBOX
    
    // Test data
    private var partnerId = "45f63H33771b42f1b08b7f9a50e6bd8a"
    private var deviceId = ""
    private var dcId = ""
    private var token = "26f63593771b42f1b08b7f9a50e6dc7c"
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "⚪ Chưa đăng nhập"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let envSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Sandbox", "Live"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private let partnerIdField = createTextField(placeholder: "Partner ID")
    private let deviceIdField = createTextField(placeholder: "Device ID")
    private let dcIdField = createTextField(placeholder: "DC ID (Phone)")
    private let tokenField = createTextField(placeholder: "Token")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        
        // Generate device ID
        deviceId = UUID().uuidString
        deviceIdField.text = deviceId
        partnerIdField.text = partnerId
        tokenField.text = token
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "SDK Example"
        view.backgroundColor = .systemBackground
        
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Stack View
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Status Section
        let statusCard = createCard(title: "Trạng thái", content: statusLabel)
        stackView.addArrangedSubview(statusCard)
        
        // Environment Section
        let envLabel = UILabel()
        envLabel.text = "Môi trường"
        envLabel.font = .boldSystemFont(ofSize: 16)
        
        let envStack = UIStackView(arrangedSubviews: [envLabel, envSegment])
        envStack.axis = .vertical
        envStack.spacing = 8
        let envCard = createCardContainer(content: envStack)
        stackView.addArrangedSubview(envCard)
        
        // Test Data Section
        let dataLabel = UILabel()
        dataLabel.text = "Test Data"
        dataLabel.font = .boldSystemFont(ofSize: 16)
        
        let dataStack = UIStackView(arrangedSubviews: [dataLabel, partnerIdField, deviceIdField, dcIdField, tokenField])
        dataStack.axis = .vertical
        dataStack.spacing = 10
        let dataCard = createCardContainer(content: dataStack)
        stackView.addArrangedSubview(dataCard)
        
        // Actions Section
        let actionsLabel = UILabel()
        actionsLabel.text = "Actions"
        actionsLabel.font = .boldSystemFont(ofSize: 16)
        
        let sendDataBtn = createButton(title: "📤 DLVNSendData", subtitle: "Gửi data và lấy access token", color: .systemBlue)
        sendDataBtn.addTarget(self, action: #selector(sendDataTapped), for: .touchUpInside)
        
        let authBtn = createButton(title: "🔐 Authenticate EDR", subtitle: "Đăng nhập và setup Sendbird", color: .systemGreen)
        authBtn.addTarget(self, action: #selector(authenticateTapped), for: .touchUpInside)
        
        let webViewBtn = createButton(title: "🌐 Open WebView", subtitle: "Mở WebView tư vấn sức khỏe", color: .systemPurple)
        webViewBtn.addTarget(self, action: #selector(openWebViewTapped), for: .touchUpInside)
        
        let logoutBtn = createButton(title: "🚪 Đăng xuất", subtitle: "Hủy đăng ký Sendbird", color: .systemRed)
        logoutBtn.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        let clearCacheBtn = createButton(title: "🗑️ Clear Cache", subtitle: "Xóa cache WebView", color: .systemOrange)
        clearCacheBtn.addTarget(self, action: #selector(clearCacheTapped), for: .touchUpInside)
        
        let actionsStack = UIStackView(arrangedSubviews: [actionsLabel, sendDataBtn, authBtn, webViewBtn, logoutBtn, clearCacheBtn])
        actionsStack.axis = .vertical
        actionsStack.spacing = 12
        let actionsCard = createCardContainer(content: actionsStack)
        stackView.addArrangedSubview(actionsCard)
    }
    
    private func setupActions() {
        envSegment.addTarget(self, action: #selector(envChanged), for: .valueChanged)
        
        // Dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    @objc private func envChanged() {
        selectedEnv = envSegment.selectedSegmentIndex == 0 ? .SANDBOX : .LIVE
        changeEnv(envUpdate: selectedEnv)
        updateStatus("Đã chuyển sang \(selectedEnv == .SANDBOX ? "Sandbox" : "Live")")
    }
    
    @objc private func sendDataTapped() {
        guard let dcId = dcIdField.text, !dcId.isEmpty else {
            updateStatus("⚠️ Vui lòng nhập DC ID")
            return
        }
        
        let data: [String: Any] = [
            "partnerid": partnerIdField.text ?? "",
            "deviceid": deviceIdField.text ?? "",
            "dcId": dcId,
            "token": tokenField.text ?? ""
        ]
        
        updateStatus("⏳ Đang gửi data...")
        
        DLVNSendData(data: data) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                    self?.updateStatus("✅ Gửi data thành công")
                } else {
                    self?.updateStatus("❌ Lỗi: \(error?.localizedDescription ?? "Unknown")")
                }
            }
        }
    }
    
    @objc private func authenticateTapped() {
        guard let dcId = dcIdField.text, !dcId.isEmpty else {
            updateStatus("⚠️ Vui lòng nhập DC ID")
            return
        }
        
        let data: [String: Any] = [
            "partnerid": partnerIdField.text ?? "",
            "deviceid": deviceIdField.text ?? "",
            "dcId": dcId,
            "token": tokenField.text ?? ""
        ]
        
        updateStatus("⏳ Đang đăng nhập...")
        
        authenticateEDR(data: data) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                    self?.updateStatus("✅ Đăng nhập thành công")
                } else {
                    self?.updateStatus("❌ Lỗi: \(error?.localizedDescription ?? "Unknown")")
                }
            }
        }
    }
    
    @objc private func openWebViewTapped() {
        openWebView(currentViewController: self)
    }
    
    @objc private func logoutTapped() {
        deauthenticateEDR()
        isAuthenticated = false
        updateStatus("⚪ Đã đăng xuất")
    }
    
    @objc private func clearCacheTapped() {
        clearWebViewCache()
        updateStatus("🗑️ Đã xóa cache")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helpers
    private func updateStatus(_ message: String) {
        statusLabel.text = message
    }
    
    private static func createTextField(placeholder: String) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        return field
    }
    
    private func createCard(title: String, content: UIView) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, content])
        stack.axis = .vertical
        stack.spacing = 8
        
        return createCardContainer(content: stack)
    }
    
    private func createCardContainer(content: UIView) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 10
        
        content.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(content)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            content.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        
        return container
    }
    
    private func createButton(title: String, subtitle: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .left
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .white.withAlphaComponent(0.8)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -12)
        ])
        
        return button
    }
}
