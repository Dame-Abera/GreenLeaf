// domain/repositories/AuthRepository.kt
package com.example.greenleaf.domain.repositories

import com.example.greenleaf.domain.common.ResultOrFailure
import com.example.greenleaf.domain.valueobjects.Email
import com.example.greenleaf.domain.valueobjects.Password

interface AuthRepository {
    suspend fun login(email: Email, password: Password): ResultOrFailure<Unit>
}
