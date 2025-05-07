package com.example.greenleaf.presentation.viewmodels

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import com.example.greenleaf.fakedata.FakeObservationRepository
import com.example.greenleaf.fakedata.Observation

class ObservationDetailViewModel : ViewModel() {
    var observation by mutableStateOf<Observation?>(null)

    /** Load a single observation for details */
    fun loadObservation(id: String) {
        observation = FakeObservationRepository.getById(id)
    }

    /** Delete and clear */
    fun deleteObservation(id: String) {
        FakeObservationRepository.delete(id)
        observation = null
    }
}
