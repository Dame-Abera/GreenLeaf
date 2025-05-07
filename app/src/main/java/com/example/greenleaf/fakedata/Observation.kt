package com.example.greenleaf.fakedata

import com.example.greenleaf.R

data class Observation(
    val id: String,
    val relatedPlantId: String?, // Matches nullable FK to PlantModel
    val relatedPlantName: String, // Display name
    val observationImageUrl: String?, // Matches ImageField
    val date: String, // YYYY-MM-DD
    val time: String, // HH:MM
    val location: String,
    val note: String?,
    val createdByUserId: String // FK to CustomUser
)

object FakeObservationRepository {
    private val observations = mutableListOf(
        Observation(
            id = "obs_1",
            relatedPlantId = "1",
            relatedPlantName = "Rose",
            observationImageUrl = "android.resource://com.example.greenleaf/${R.drawable.greenleaf}"
            ,
            date = "2025-05-01",
            time = "10:30",
            location = "Green Park",
            note = "Found growing near the pond. Healthy and vibrant.",
            createdByUserId = "user_1"
        ),
        Observation(
            id = "obs_2",
            relatedPlantId = "2",
            relatedPlantName = "Sunflower",
            observationImageUrl ="android.resource://com.example.greenleaf/${R.drawable.greenleaf}",
            date = "2025-05-03",
            time = "14:15",
            location = "Farm edge",
            note = "Tilting toward sun. Several bees observed.",
            createdByUserId = "user_1"
        )
    )

    fun getAll(): List<Observation> = observations
    fun getById(id: String): Observation? = observations.find { it.id == id }
    fun getByPlantId(plantId: String): List<Observation> = observations.filter { it.relatedPlantId == plantId }

    fun add(observation: Observation) {
        observations.add(observation)
    }

    fun update(updatedObservation: Observation) {
        val index = observations.indexOfFirst { it.id == updatedObservation.id }
        if (index != -1) observations[index] = updatedObservation
    }

    fun delete(id: String) {
        observations.removeAll { it.id == id }
    }
}

