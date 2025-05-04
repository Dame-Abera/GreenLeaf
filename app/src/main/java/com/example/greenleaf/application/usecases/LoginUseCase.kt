// domain/usecases/LoginUseCase.kt
package com.example.greenleaf.application.usecases

import com.example.greenleaf.domain.repositories.AuthRepository
import com.example.greenleaf.domain.valueobjects.Email
import com.example.greenleaf.domain.valueobjects.Password
import com.example.greenleaf.domain.common.ResultOrFailure

class LoginUseCase(
    private val authRepository: AuthRepository
) {
    suspend operator fun invoke(email: Email, password: Password): ResultOrFailure<Unit> {
        return authRepository.login(email, password)
    }
}
