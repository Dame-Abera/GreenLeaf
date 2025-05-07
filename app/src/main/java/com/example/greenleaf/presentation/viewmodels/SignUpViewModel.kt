// presentation/viewmodel/SignUpViewModel.kt
package com.example.greenleaf.presentation.viewmodels

import androidx.lifecycle.ViewModel
import com.example.greenleaf.presentation.ui.signup.SignUpEvent
import com.example.greenleaf.presentation.ui.signup.SignUpUiState
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import javax.inject.Inject

@HiltViewModel
class SignUpViewModel @Inject constructor() : ViewModel() {

    private val _uiState = MutableStateFlow(SignUpUiState())
    val uiState: StateFlow<SignUpUiState> = _uiState.asStateFlow()

    fun onEvent(event: SignUpEvent) {
        when (event) {
            is SignUpEvent.EmailChanged -> _uiState.update { it.copy(email = event.value) }
            is SignUpEvent.PasswordChanged -> _uiState.update { it.copy(password = event.value) }
            is SignUpEvent.ConfirmPasswordChanged -> _uiState.update { it.copy(confirmPassword = event.value) }
            is SignUpEvent.Submit -> {
                // TODO: Add registration use case later
            }
        }
    }
}
