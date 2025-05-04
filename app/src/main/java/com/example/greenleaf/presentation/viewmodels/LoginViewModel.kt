// presentation/viewmodel/LoginViewModel.kt
package com.example.greenleaf.presentation.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.greenleaf.domain.common.ResultOrFailure
import com.example.greenleaf.domain.failures.DomainFailure
import com.example.greenleaf.application.usecases.LoginUseCase
import com.example.greenleaf.domain.valueobjects.Email
import com.example.greenleaf.domain.valueobjects.Password
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

data class LoginUiState(
    val email: String = "",
    val password: String = "",
    val isLoading: Boolean = false,
    val error: String? = null,
    val success: Boolean = false
)

@HiltViewModel
class LoginViewModel @Inject constructor(
    private val loginUseCase: LoginUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(LoginUiState())
    val uiState: StateFlow<LoginUiState> = _uiState

    fun onEmailChanged(newEmail: String) {
        _uiState.value = _uiState.value.copy(email = newEmail)
    }

    fun onPasswordChanged(newPassword: String) {
        _uiState.value = _uiState.value.copy(password = newPassword)
    }

    fun onLoginClicked() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true, error = null)

            val emailResult = Email.create(_uiState.value.email)
            val passwordResult = Password.create(_uiState.value.password)

            if (emailResult is ResultOrFailure.Failure) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = emailResult.failure.message
                )
                return@launch
            }

            if (passwordResult is ResultOrFailure.Failure) {
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    error = passwordResult.failure.message
                )
                return@launch
            }

            val email = (emailResult as ResultOrFailure.Success).value
            val password = (passwordResult as ResultOrFailure.Success).value

            val loginResult = loginUseCase(email, password)

            _uiState.value = when (loginResult) {
                is ResultOrFailure.Success -> _uiState.value.copy(
                    isLoading = false,
                    success = true
                )
                is ResultOrFailure.Failure -> _uiState.value.copy(
                    isLoading = false,
                    error = when (val reason = loginResult.failure) {
                        is DomainFailure.NetworkError -> "Check your internet connection."
                        is DomainFailure.Unauthorized -> "Invalid credentials."
                        is DomainFailure.DatabaseError -> "Something went wrong with the server."
                        is DomainFailure.ValidationError -> reason.message
                        else -> "Unknown error occurred."
                    }
                )
            }
        }
    }
}

