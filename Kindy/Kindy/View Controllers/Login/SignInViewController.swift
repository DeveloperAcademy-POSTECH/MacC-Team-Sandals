//
//  LoginViewController.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/06.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import AuthenticationServices
import FirebaseFirestore
import FirebaseFirestoreSwift


class SignInViewController: UIViewController {
    
    private let firestoreManager = FirestoreManager()
    
    fileprivate var currentNonce: String?
    
    private let signInView: SignInView = SignInView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.navigationItem.title = "로그인"
        view.backgroundColor = .white
        signInView.translatesAutoresizingMaskIntoConstraints = false
        signInView.delegate = self
        view.addSubview(signInView)
        NSLayoutConstraint.activate([
            signInView.topAnchor.constraint(equalTo: view.topAnchor),
            signInView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            signInView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signInView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    
    // MARK: Google SignIn Button Action
    @objc private func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Task {
                if try await firestoreManager.isExistID(user?.profile?.email, "google") {
                    Auth.auth().signIn(with: credential) { [weak self] result, error in
                        guard let self = self else { return }
                        guard
                            result != nil,
                            error == nil else {
                            if let error = error {
                                print("Error google Login - \(error) ")
                            }
                            return
                        }
                        // Auth.auth().currentUser.uid 값을 가지고 FireStore에 유저 컬렉션에 해당 도큐먼트가 있는지 확인
                        // 확인 후 없다면 해당 유저 도큐먼트를
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    let vc = SignUpViewController()
                    vc.credential = credential
                    vc.provider = "google"
                    vc.email = user?.profile?.email ?? ""
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
    // MARK: Apple SignIn Button Action
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
      //난수 생성
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      // appleIDProvider 요청 생성
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
        // 해쉬값 전달
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
}

// Sign in with Apple 관련 사항
@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    // MARK: 난수 생성
    private func randomNonceString(length: Int = 32) -> String {
        
        precondition(length > 0)
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

        randoms.forEach { random in
            if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
    // MARK: 실제 로그인 작동하는 로직
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            // appleIDCredential.user , email fullName 등등으로 값을 확인할 수 있다 user는 identifier로 사용된다.

            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                idToken: idTokenString,
                                rawNonce: nonce)
            // Sign in with Firebase.
            let checkEmail: String = self.decode(jwt:idTokenString) ?? ""
            Task{
                if try await firestoreManager.isExistID(checkEmail, "apple") {
                    Auth.auth().signIn(with: credential) { [weak self] result, error in
                        guard let self = self else { return }
                        guard result != nil, error == nil else {
                            if let error = error {
                                print("Error google Login - \(error) ")
                            }
                            return
                        }
                        // Auth.auth().currentUser.uid 값을 가지고 FireStore에 유저 컬렉션에 해당 도큐먼트가 있는지 확인
                        // 확인 후 없다면 해당 유저 도큐먼트를
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    let vc = SignUpViewController()
                    vc.credential = credential
                    vc.provider = "apple"
                    vc.email = self.decode(jwt:idTokenString) ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }

}

// MARK: Apple에서 발행한 토큰값 decode
extension SignInViewController {
    // 출처 : https://github.com/auth0/JWTDecode.swift/tree/master/JWTDecode
    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 += padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    private func decodeJWTPart(_ value: String) throws -> [String: Any] {
        guard let bodyData = base64UrlDecode(value) else {
            throw JWTDecodeError.invalidBase64URL(value)
        }

        guard let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            throw JWTDecodeError.invalidJSON(value)
        }

        return payload
    }

    public enum JWTDecodeError: LocalizedError, CustomDebugStringConvertible {
        /// When either the header or body parts cannot be Base64URL-decoded.
        case invalidBase64URL(String)

        /// When either the decoded header or body is not a valid JSON object.
        case invalidJSON(String)

        /// When the JWT doesn't have the required amount of parts (header, body, and signature).
        case invalidPartCount(String, Int)

        /// Description of the error.
        ///
        /// - Important: You should avoid displaying the error description to the user, it's meant for **debugging** only.
        public var localizedDescription: String { return self.debugDescription }

        /// Description of the error.
        ///
        /// - Important: You should avoid displaying the error description to the user, it's meant for **debugging** only.
        public var errorDescription: String? { return self.debugDescription }

        /// Description of the error.
        ///
        /// - Important: You should avoid displaying the error description to the user, it's meant for **debugging** only.
        public var debugDescription: String {
            switch self {
            case .invalidJSON(let value):
                return "Failed to parse JSON from Base64URL value \(value)."
            case .invalidPartCount(let jwt, let parts):
                return "The JWT \(jwt) has \(parts) parts when it should have 3 parts."
            case .invalidBase64URL(let value):
                return "Failed to decode Base64URL value \(value)."
            }
        }
    }

    public func decode(jwt: String) -> String? {
        let parts = jwt.components(separatedBy: ".")
        do {
            let body = try decodeJWTPart(parts[1])
            return String(describing: body["email"] ?? "")
        } catch {
            return nil
        }
        
        
    }
    
}


extension SignInViewController: SignInDelegate {
    func googleSignInMethod() {
        googleSignIn()
    }
    
    func appleSignInMethod() {
        startSignInWithAppleFlow()
    }
}
