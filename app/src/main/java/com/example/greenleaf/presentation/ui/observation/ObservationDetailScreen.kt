package com.example.greenleaf.presentation.ui.observation

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material3.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Place
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import coil3.compose.AsyncImage
import java.text.SimpleDateFormat
import java.util.Locale
import com.example.greenleaf.presentation.viewmodels.PlantDetailViewModel
import com.example.greenleaf.presentation.viewmodels.ObservationDetailViewModel
import com.example.greenleaf.fakedata.Observation
import com.example.greenleaf.presentation.navigation.Screen

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
            Column {
                HorizontalDivider(thickness = 1.dp, color = Color.Gray)
                NavigationBar {
                    NavigationBarItem(
                        selected = false,
                        onClick = { navController.navigate("home") },
                        icon = { Icon(Icons.Filled.Home, contentDescription = "Home") },
                        label = { Text("Home") }
                    )
                    NavigationBarItem(
                        selected = false,
                        onClick = { navController.navigate("account") },
                        icon = { Icon(Icons.Filled.Person, contentDescription = "Account") },
                        label = { Text("Account") }
                    )
                }
            }
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
