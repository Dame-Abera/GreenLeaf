// domain/entities/Observation.kt
package com.example.greenleaf.domain.entities

data class Observation(
    val id: String,
    val plantId: String,
    val date: Long, // Unix timestamp
    val notes: String,
    val imageUrl: String? = null
)
