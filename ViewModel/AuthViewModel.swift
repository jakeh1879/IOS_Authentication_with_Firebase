//
//  AuthViewModel.swift
//  auth_app_test
//
//  Created by Jacob Hefele on 8/8/23.
//

//Provides funcitonality for authenticating user

import Foundation
import Firebase
import FirebaseFirestoreSwift

//Ensure that info provided by user meets designated requirements at profile creation
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}


@MainActor 
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? 
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser //Caching functionality is user is logged in
        
        Task {
            await fetchUser() 
        }
        
    }
    func signIn(withEmail email: String, password: String) async throws { //Look into async (can throw error)
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            //check out async await
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //create user using Firebase code
            self.userSession = result.user //user object (set user session property)
            let user = User(id: result.user.uid, fullName: fullName, email: email) //created our user through Firebase
            let encodedUser = try Firestore.Encoder().encode(user) //upload to Firestore
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser() //fetch data to update following creation of new user
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() //signs out user on backend
            self.userSession = nil //clears user session and takes back to login screen - ContentView updates as AuthView model changes
            self.currentUser = nil //clears current user data mmodel - ensures only one user logged in at time
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        //Delete user account
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return } //get current user id
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        print("DEBUG: Current user is \(self.currentUser)") 
    }
    
    
}
