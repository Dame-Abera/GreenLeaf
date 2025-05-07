package com.example.greenleaf.fakedata

import com.example.greenleaf.R

data class User(
    val id: String,
    var name: String,
    var email: String,
    var birthdate: String?, // YYYY-MM-DD
    var gender: String?, // "Male" or "Female"
    var phoneNumber: String?,
    var profileImageUrl: String? // Matches ImageField
)

object FakeUserRepository {
    var currentUser: User? = User(
        id = "user_1",
        name = "Jane Doe",
        email = "jane.doe@example.com",
        birthdate = "1990-01-01",
        gender = "Female",
        phoneNumber = "555-1234",
        profileImageUrl ="android.resource://com.example.greenleaf/${R.drawable.greenleaf}"

    )

    fun getUser(): User? = currentUser
    fun updateUser(user: User) {
        currentUser = user
    }

    fun deleteUser() {
        currentUser = null
    }
}
