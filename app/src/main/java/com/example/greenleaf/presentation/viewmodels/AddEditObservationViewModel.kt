package com.example.greenleaf.presentation.viewmodels

import androidx.compose.runtime.*
import androidx.lifecycle.ViewModel
import com.example.greenleaf.fakedata.FakeObservationRepository
import com.example.greenleaf.fakedata.Observation
import java.util.*

class AddEditObservationViewModel : ViewModel() {
    var observation by mutableStateOf(
        Observation(
            id = UUID.randomUUID().toString(),
            relatedPlantId = null,
            relatedPlantName = "",
            observationImageUrl = null,
            date = "",
            time = "",
            location = "",
            note = "",
            createdByUserId = "user_1"
        )
    )
        private set

    fun loadObservation(id: String) {
        FakeObservationRepository.getById(id)?.let {
            observation = it
        }
    }

    fun onPlantNameChange(value: String) {
        observation = observation.copy(relatedPlantName = value)
    }

    fun onDateChange(value: String) {
        observation = observation.copy(date = value)
    }

    fun onNotesChange(value: String) {
        observation = observation.copy(note = value)
    }

    fun saveObservation() {
        if (FakeObservationRepository.getById(observation.id) == null) {
            FakeObservationRepository.add(observation)
        } else {
            FakeObservationRepository.update(observation)
        }
    }
}
