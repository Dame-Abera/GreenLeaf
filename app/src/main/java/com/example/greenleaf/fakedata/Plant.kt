package com.example.greenleaf.fakedata

import com.example.greenleaf.R

data class Plant(
    val id: String,
    val commonName: String,
    val scientificName: String,
    val habitat: String,
    val origin: String?,
    val description: String?,
    val plantImageUrl: String?, // Matches ImageField
    val createdByUserId: String // ForeignKey to CustomUser
)

object FakePlantRepository {
    private val plants = mutableListOf(
        Plant(
            id = "1",
            commonName = "Rose",
            scientificName = "Rosa rubiginosa",
            habitat = "Gardens and hedgerows",
            origin = "Asia",
            description = "A thorny flowering shrub often used ornamentally.",
            plantImageUrl = "android.resource://com.example.greenleaf/${R.drawable.greenleaf}"
            ,
            createdByUserId = "user_1"
        ),
        Plant(
            id = "2",
            commonName = "Sunflower",
            scientificName = "Helianthus annuus",
            habitat = "Open fields",
            origin = "North America",
            description = "A tall plant with a large yellow flower head that tracks the sun.",
            plantImageUrl =  "android.resource://com.example.greenleaf/${R.drawable.greenleaf}"
            ,
            createdByUserId = "user_1"
        )
    )

    fun getAll(): List<Plant> = plants
    fun getById(id: String): Plant? = plants.find { it.id == id }

    fun add(plant: Plant) {
        plants.add(plant)
    }

    fun update(updatedPlant: Plant) {
        val index = plants.indexOfFirst { it.id == updatedPlant.id }
        if (index != -1) plants[index] = updatedPlant
    }

    fun delete(id: String) {
        plants.removeAll { it.id == id }
    }
}
