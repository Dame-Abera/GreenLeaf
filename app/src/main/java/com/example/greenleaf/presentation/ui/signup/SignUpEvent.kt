package com.example.greenleaf.presentation.ui.signup
sealed class SignUpEvent {
    data class EmailChanged(val value: String) : SignUpEvent()
    data class PasswordChanged(val value: String) : SignUpEvent()
    data class ConfirmPasswordChanged(val value: String) : SignUpEvent()
    object Submit : SignUpEvent()
}