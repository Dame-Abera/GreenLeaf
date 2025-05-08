package com.example.greenleaf.presentation.ui.observation

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Place
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import coil3.compose.AsyncImage
import com.example.greenleaf.presentation.components.MainBottomBar
import com.example.greenleaf.presentation.navigation.Screen
import com.example.greenleaf.presentation.viewmodels.ObservationDetailViewModel
import java.text.SimpleDateFormat
import java.util.Locale

@Composable
fun ObservationDetailScreen(
    navController: NavController,
    observationId: String,
    observationViewModel: ObservationDetailViewModel = viewModel()
) {
    // Load the observation only once
    LaunchedEffect(observationId) {
        observationViewModel.loadObservation(observationId)
    }

    val observation = observationViewModel.observation ?: return

    // Convert date + time strings to Date object for formatting
    val dateTimeString = "${observation.date} ${observation.time}"
    val inputFormat = remember { SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault()) }
    val dateObject = remember(observation) {
        try {
            inputFormat.parse(dateTimeString)
        } catch (e: Exception) {
            null
        }
    }
    val outputFormat = remember { SimpleDateFormat("MMMM dd, yyyy, h:mm a", Locale.getDefault()) }
    val formattedDate = dateObject?.let { outputFormat.format(it) } ?: "${observation.date} ${observation.time}"

    Scaffold(
        bottomBar = {
            MainBottomBar(navController)
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .verticalScroll(rememberScrollState())
        ) {
            Box {
                AsyncImage(
                    model = observation.observationImageUrl,
                    contentDescription = observation.relatedPlantName,
                    contentScale = ContentScale.Crop,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(250.dp)
                )
                IconButton(
                    onClick = { navController.popBackStack() },
                    modifier = Modifier.padding(16.dp)
                ) {
                    Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back", tint = Color.White)
                }
            }
            Column(modifier = Modifier.padding(16.dp)) {
                Text(
                    text = observation.relatedPlantName,
                    style = MaterialTheme.typography.titleLarge
                )
                Text(
                    text = "Scientific name not available", // Fake data has no field for this
                    style = MaterialTheme.typography.titleSmall,
                    color = Color.Gray
                )
                Spacer(modifier = Modifier.height(8.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Filled.Place, contentDescription = "Date", tint = Color.Gray)
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(
                        text = formattedDate,
                        style = MaterialTheme.typography.bodyMedium
                    )
                }
                Text(
                    text = observation.location,
                    style = MaterialTheme.typography.bodyMedium
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = "Notes",
                    fontWeight = FontWeight.Bold,
                    style = MaterialTheme.typography.bodyLarge
                )
                Text(
                    text = observation.note ?: "No notes provided",
                    style = MaterialTheme.typography.bodyMedium
                )
                Spacer(modifier = Modifier.height(16.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                    Button(

                        onClick = {  Screen.AddEditObservation.createRoute(observation.id)},
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00C853))
                    ) {
                        Text("Edit Observation", color = Color.White)
                    }
                    Button(
                        onClick = {
                            observationViewModel.deleteObservation(observation.id)
                            navController.popBackStack()
                        },
                        colors = ButtonDefaults.buttonColors(containerColor = Color.Red)
                    ) {
                        Text("Delete Observation", color = Color.White)
                    }
                }
            }
        }
    }
}
