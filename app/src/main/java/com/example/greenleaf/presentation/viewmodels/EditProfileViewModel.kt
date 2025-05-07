package com.example.greenleaf.presentation.viewmodels

import androidx.lifecycle.ViewModel
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import com.example.greenleaf.fakedata.FakeUserRepository
import com.example.greenleaf.fakedata.User

class EditProfileViewModel : ViewModel() {

    // individual form fields
    var firstName       by mutableStateOf("")
    var lastName        by mutableStateOf("")
    var email           by mutableStateOf("")
    var birthdate       by mutableStateOf("")
    var gender          by mutableStateOf("")
    var phoneNumber     by mutableStateOf("")
    var profileImageUrl by mutableStateOf<String?>(null)

    init {
        loadUser()
    }

    /** Populate the form with the current user */
    fun loadUser() {
        FakeUserRepository.getUser()?.let { u ->
            val parts = u.name.split(" ", limit = 2)
            firstName       = parts.getOrNull(0).orEmpty()
            lastName        = parts.getOrNull(1).orEmpty()
            email           = u.email
            birthdate       = u.birthdate.orEmpty()
            gender          = u.gender.orEmpty()
            phoneNumber     = u.phoneNumber.orEmpty()
            profileImageUrl = u.profileImageUrl
        }
    }

    /** Persist edits back into the fake repo */
    fun saveUser() {
        val fullName = listOf(firstName, lastName)
            .filter { it.isNotBlank() }
            .joinToString(" ")
        val existing = FakeUserRepository.getUser()
        if (existing != null) {
            val updated = existing.copy(
                name            = fullName,
                email           = email.trim(),
                birthdate       = birthdate.ifBlank { null },
                gender          = gender.ifBlank { null },
                phoneNumber     = phoneNumber.ifBlank { null },
                profileImageUrl = profileImageUrl
            )
            FakeUserRepository.updateUser(updated)
        }
    }
}
