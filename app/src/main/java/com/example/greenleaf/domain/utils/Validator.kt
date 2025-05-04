// domain/utils/Validator.kt
package com.example.greenleaf.domain.utils

object Validator {
    fun isValidEmail(email: String): Boolean {
        val regex = Regex("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")
        return regex.matches(email)
    }

    fun isValidPassword(password: String): Boolean {
        return password.length >= 6
    }
}
