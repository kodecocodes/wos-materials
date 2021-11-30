import SwiftUI
import AuthenticationServices

struct SignInView: View {
  @AppStorage("userName") private var storedUserName = ""
  @AppStorage("userCredential") private var userCredential = ""
  @Environment(\.dismiss) private var dismiss

  private let nonce = UUID().uuidString
  
  let onSignedIn: (String) -> Void
  
  var body: some View {
    ScrollView {
      Text("This action requires you to be signed in.")
        .font(.body)
      
      SignInWithAppleButton(onRequest: onRequest, onCompletion: siwaCompletion)
        .signInWithAppleButtonStyle(.white)
      
      Divider()
        .padding()
      
      PasswordView(
        userName: storedUserName,
        completionHandler: userPasswordCompletion
      )
    }
  }
  
  private func onRequest(request: ASAuthorizationAppleIDRequest) {
    request.requestedScopes = [.fullName]
    request.state = "some state string"
    request.nonce = nonce
  }
  
  private func siwaCompletion(result: Result<ASAuthorization, Error>) {
    guard
      case .success(let authorization) = result,
      let credential = authorization.credential as? ASAuthorizationAppleIDCredential
    else {
      if case .failure(let error) = result {
        print("Failed to authenticate: \(error.localizedDescription)")
      }
      
      return
    }

    // Pass credential.identityToken and credential.authorizationCode
    if credential.fullName == nil {
      // You've logged in an existing user account.
    } else {
      // The user does not exist, so register a new account.
    }

    userCredential = credential.user
  }
  
  private func userPasswordCompletion(userName: String, password: String) {
    storedUserName = userName

    var request = URLRequest(url: URL(string: "https://your.site.com/login")!)
    request.httpMethod = "POST"
    // request.httpBody = ...

    DispatchQueue.main.async {
      onSignedIn("some token here")
      dismiss()
    }
  }
}

struct SignInView_Previews: PreviewProvider {
  static var previews: some View {
    SignInView { _ in }
  }
}
