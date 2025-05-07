package com.example.greenleaf.presentation.viewmodels

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.example.greenleaf.fakedata.FakePlantRepository
import com.example.greenleaf.fakedata.Plant

class PlantDetailViewModel : ViewModel() {
    var plant by mutableStateOf<Plant?>(null)

    /** Load a single plant for details */
    fun loadPlant(id: String) {
        plant = FakePlantRepository.getById(id)
    }

    /** Delete and clear */
    fun deletePlant(id: String) {
        FakePlantRepository.delete(id)
        plant = null
    }
}
