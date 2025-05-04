package com.example.greenleaf.domain.entities

data class Plant(
    val id: String,
    val name: String,
    val species: String,
    val description: String,
    val imageUrl: String? = null
)
