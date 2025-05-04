// domain/entities/User.kt
package com.example.greenleaf.domain.entities

data class User(
    val id: String,
    val name: String,
    val email: String,
    val isAdmin: Boolean
)
