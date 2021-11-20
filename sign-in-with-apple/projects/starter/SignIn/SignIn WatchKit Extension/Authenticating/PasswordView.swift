import SwiftUI

struct PasswordView: View {
  @State private var userName = ""
  @State private var password = ""
  
  let completionHandler: (String, String) -> Void
  
  private var isButtonDisabled: Bool {
    return userName.trimmingCharacters(in: .whitespaces).isEmpty
    || password.isEmpty
  }
  
  var body: some View {
    VStack {
      TextField("User Name", text: $userName)
        .textContentType(.username)
      
      SecureField("Password", text: $password)
        .textContentType(.password)
      
      Button("Sign In", action: signInTapped)
        .disabled(isButtonDisabled)
    }
  }
  
  init(userName: String? = nil, completionHandler: @escaping (String, String) -> Void) {
    self.completionHandler = completionHandler
    _userName = State(initialValue: userName ?? "")
  }
  
  private func signInTapped() {
    completionHandler(userName.trimmingCharacters(in: .whitespaces), password)
  }
}

struct PasswordView_Previews: PreviewProvider {
  static var previews: some View {
    PasswordView { _, _ in return }
  }
}
