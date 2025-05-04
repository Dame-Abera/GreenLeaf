package com.example.greenleaf.domain.valueobjects

import com.example.greenleaf.domain.common.ResultOrFailure
import com.example.greenleaf.domain.failures.DomainFailure

@JvmInline
value class Password(val value: String) {
    init {
        require(value.isNotBlank()) { "Password cannot be blank" }
        require(value.length >= 8) { "Password must be at least 8 characters long" }
    }

    companion object {
        fun create(value: String): ResultOrFailure<Password> {
            return try {
                ResultOrFailure.Success(Password(value))
            } catch (e: IllegalArgumentException) {
                ResultOrFailure.Failure(DomainFailure.ValidationError(e.message ?: "Invalid password"))
            }
        }
    }
}