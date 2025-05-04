package com.example.greenleaf.data.repositories

import com.example.greenleaf.domain.repositories.AuthRepository
import com.example.greenleaf.domain.valueobjects.Email
import com.example.greenleaf.domain.valueobjects.Password
import com.example.greenleaf.domain.common.ResultOrFailure
import com.example.greenleaf.domain.failures.DomainFailure
import javax.inject.Inject

class AuthRepositoryImpl @Inject constructor() : AuthRepository {
    private val mockEmail = "test@example.com"
    private val mockPassword = ""

    override suspend fun login(email: Email, password: Password): ResultOrFailure<Unit> {
        return if (email.value == mockEmail && password.value == mockPassword) {
            ResultOrFailure.Success(Unit)
        } else {
            ResultOrFailure.Failure(DomainFailure.Unauthorized("Invalid email or password"))
        }
    }
}