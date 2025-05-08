package com.example.greenleaf.presentation.ui.observation

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AddAPhoto
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import com.example.greenleaf.presentation.components.MainBottomBar
import com.example.greenleaf.presentation.viewmodels.AddEditObservationViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddEditObservationScreen(
    navController: NavHostController,
    observationId: String?,
    observationViewModel: AddEditObservationViewModel = viewModel()
) {
    val isNewObservation = observationId == null

    LaunchedEffect(observationId) {
        if (!isNewObservation) {
            observationViewModel.loadObservation(observationId!!)
        }
    }

    val observation = observationViewModel.observation

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = {
                    Text(
                        if (isNewObservation) "Add Observation" else "Edit Observation",
                        style = MaterialTheme.typography.headlineSmall
                    )
                },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Default.Close, contentDescription = "Cancel")
                    }
                },
                actions = {
                    TextButton(onClick = {
                        observationViewModel.saveObservation()
                        navController.popBackStack()
                    }) {
                        Text("Save")
                    }
                }
            )
        },
        bottomBar = {
            MainBottomBar(navController)
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp)
                .verticalScroll(rememberScrollState())
        ) {
            Box(
                modifier = Modifier
                    .height(180.dp)
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(8.dp))
                    .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.1f))
                    .clickable { /* TODO: Pick or capture observation photo */ },
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.AddAPhoto,
                    contentDescription = "Add Observation Photo",
                    tint = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.size(48.dp)
                )
            }
            Spacer(modifier = Modifier.height(16.dp))
            OutlinedTextField(
                value = observation.relatedPlantName,
                onValueChange = { observationViewModel.onPlantNameChange(it) },
                label = { Text("Plant Name") },
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(modifier = Modifier.height(8.dp))
            OutlinedTextField(
                value = observation.date,
                onValueChange = { observationViewModel.onDateChange(it) },
                label = { Text("Date") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
            )
            Spacer(modifier = Modifier.height(8.dp))
            OutlinedTextField(
                value = observation.note ?: "",
                onValueChange = { observationViewModel.onNotesChange(it) },
                label = { Text("Notes") },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(120.dp)
            )
            // Additional fields as needed
        }
    }
}

