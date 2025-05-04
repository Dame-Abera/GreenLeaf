package com.example.greenleaf.domain.valueobjects

import com.example.greenleaf.domain.common.ResultOrFailure
import com.example.greenleaf.domain.failures.DomainFailure

@JvmInline
value class Email(val value: String) {
    init {
        require(value.isNotBlank()) { "Email cannot be blank" }
        require(value.contains("@")) { "Email must contain @" }
    }

    companion object {
        fun create(value: String): ResultOrFailure<Email> {
            return try {
                ResultOrFailure.Success(Email(value))
            } catch (e: IllegalArgumentException) {
                ResultOrFailure.Failure(DomainFailure.ValidationError(e.message ?: "Invalid email"))
            }
        }
    }
}