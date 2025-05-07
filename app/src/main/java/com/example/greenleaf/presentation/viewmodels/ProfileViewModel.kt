package com.example.greenleaf.presentation.viewmodels

import androidx.lifecycle.ViewModel
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import com.example.greenleaf.fakedata.FakeUserRepository

class ProfileViewModel : ViewModel() {
    var isLoggedOut   by mutableStateOf(false)
    var showDeleteDlg by mutableStateOf(false)

    fun logout() {
        FakeUserRepository.deleteUser()
        isLoggedOut = true
    }

    fun deleteAccount() {
        FakeUserRepository.deleteUser()
        isLoggedOut = true
    }
}
