package com.example.greenleaf.presentation.viewmodels

import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import com.example.greenleaf.fakedata.FakePlantRepository
import com.example.greenleaf.fakedata.Plant
import java.util.UUID

class AddEditPlantViewModel : ViewModel() {

    // Form state
    val commonName = mutableStateOf("")
    val scientificName = mutableStateOf("")
    val habitat = mutableStateOf("")
    val origin = mutableStateOf("")
    val description = mutableStateOf("")
    val isSaved = mutableStateOf(false)

    private var editingPlantId: String? = null

    /** Load existing plant data for editing */
    fun loadPlant(id: String) {
        FakePlantRepository.getById(id)?.let { plant ->
            editingPlantId = plant.id
            commonName.value = plant.commonName
            scientificName.value = plant.scientificName
            habitat.value = plant.habitat
            origin.value = plant.origin ?: ""
            description.value = plant.description ?: ""
        }
    }

    /** Save or update the plant in the fake repository */
    fun savePlant() {
        if (editingPlantId == null) {
            // Add new plant
            val newPlant = Plant(
                id = UUID.randomUUID().toString(),
                commonName = commonName.value,
                scientificName = scientificName.value,
                habitat = habitat.value,
                origin = origin.value.ifBlank { null },
                description = description.value.ifBlank { null },
                plantImageUrl = null,             // no image picked yet
                createdByUserId = "user_1"         // match your fake user
            )
            FakePlantRepository.add(newPlant)
        } else {
            // Update existing plant
            val updated = Plant(
                id = editingPlantId!!,
                commonName = commonName.value,
                scientificName = scientificName.value,
                habitat = habitat.value,
                origin = origin.value.ifBlank { null },
                description = description.value.ifBlank { null },
                plantImageUrl = FakePlantRepository.getById(editingPlantId!!)?.plantImageUrl,
                createdByUserId = FakePlantRepository.getById(editingPlantId!!)?.createdByUserId
                    ?: "user_1"
            )
            FakePlantRepository.update(updated)
        }
        isSaved.value = true
    }
}
