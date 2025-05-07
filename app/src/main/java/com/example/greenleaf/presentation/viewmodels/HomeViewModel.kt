package com.example.greenleaf.presentation.viewmodels
import androidx.compose.runtime.mutableStateListOf
import androidx.lifecycle.ViewModel
import com.example.greenleaf.fakedata.FakeObservationRepository
import com.example.greenleaf.fakedata.FakePlantRepository
import com.example.greenleaf.fakedata.Plant
import com.example.greenleaf.fakedata.Observation

class HomeViewModel : ViewModel() {
    // Backing mutable lists that survive recomposition
    private val _plants = mutableStateListOf<Plant>().apply {
        addAll(FakePlantRepository.getAll())
    }
    private val _observations = mutableStateListOf<Observation>().apply {
        addAll(FakeObservationRepository.getAll())
    }

    val plants: List<Plant> get() = _plants
    val observations: List<Observation> get() = _observations
}
