package com.example.greenleaf.presentation.ui.home
import com.example.greenleaf.presentation.navigation.Screen

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.TabRowDefaults.SecondaryIndicator
import androidx.compose.material3.TabRowDefaults.tabIndicatorOffset
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import coil3.compose.AsyncImage
import com.example.greenleaf.fakedata.Plant
import com.example.greenleaf.fakedata.Observation
import com.example.greenleaf.presentation.viewmodels.HomeViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(
    navController: NavController,
    homeViewModel: HomeViewModel = viewModel()
) {
    val plants = homeViewModel.plants
    val observations = homeViewModel.observations

    var selectedTabIndex by remember { mutableIntStateOf(0) }
    val tabTitles = listOf("Plants", "Field observations")

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text("GreenLeaf") }
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = {
                    if (selectedTabIndex == 0) navController.navigate(    Screen.AddEditPlant.createRoute(null))
                    else navController.navigate(          Screen.AddEditObservation.createRoute(null)
                    )
                },
                containerColor = Color(0xFF00C853)
            ) {
                Icon(Icons.Filled.Add, contentDescription = "Add")
            }
        },
        bottomBar = {
            Column {
                HorizontalDivider(thickness = 1.dp, color = Color.Gray)
                NavigationBar {
                    NavigationBarItem(
                        selected = true,
                        onClick = { /* Home selected */ },
                        icon = { Icon(Icons.Filled.Home, contentDescription = "Home") },
                        label = { Text("Home") }
                    )
                    NavigationBarItem(
                        selected = false,
                        onClick= {
                            navController.navigate(Screen.Profile.route) {
                                // optional: clear any deeper backstack
                                popUpTo(Screen.Home.route) { inclusive = false }
                            }
                        },
                        icon = { Icon(Icons.Filled.Person, contentDescription = "Account") },
                        label = { Text("Account") }
                    )
                }
            }
        }
    ) { innerPadding ->
        Column(modifier = Modifier.padding(innerPadding)) {
            TabRow(
                selectedTabIndex = selectedTabIndex,
                indicator = { tabPositions ->
                    SecondaryIndicator(
                        Modifier.tabIndicatorOffset(tabPositions[selectedTabIndex]),
                        color = Color(0xFF00C853)
                    )
                }
            ) {
                tabTitles.forEachIndexed { index, title ->
                    Tab(
                        selected = selectedTabIndex == index,
                        onClick = { selectedTabIndex = index }
                    ) {
                        Text(title, modifier = Modifier.padding(16.dp))
                    }
                }
            }

            if (selectedTabIndex == 0) {
                LazyColumn(modifier = Modifier.fillMaxSize()) {
                    items(plants) { plant ->
                        PlantCard(plant = plant) {
                            navController.navigate(Screen.PlantDetail.createRoute(plant.id))
                        }
                    }
                }
            } else {
                LazyColumn(modifier = Modifier.fillMaxSize()) {
                    items(observations) { obs ->
                        ObservationCard(observation = obs) {
                            navController.navigate(Screen.ObservationDetail.createRoute(obs.id))
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun PlantCard(
    plant: Plant,
    onDetailsClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        shape = RoundedCornerShape(8.dp)
    ) {
        Box(modifier = Modifier.height(180.dp)) {
            AsyncImage(
                model = plant.plantImageUrl,
                contentDescription = plant.commonName,
                contentScale = ContentScale.Crop,
                modifier = Modifier.fillMaxSize()
            )
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = plant.commonName,
                    style = MaterialTheme.typography.titleLarge,
                    color = Color.White
                )
                Button(
                    onClick = onDetailsClick,
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00C853))
                ) {
                    Text(text = "Plant Details", color = Color.White)
                }
            }
        }
    }
}

@Composable
fun ObservationCard(
    observation: Observation,
    onDetailsClick: () -> Unit
) {
    val dateText = "${observation.date}, ${observation.time}"
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        shape = RoundedCornerShape(8.dp)
    ) {
        Box(modifier = Modifier.height(180.dp)) {
            AsyncImage(
                model = observation.observationImageUrl,
                contentDescription = observation.relatedPlantName,
                contentScale = ContentScale.Crop,
                modifier = Modifier.fillMaxSize()
            )
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalArrangement = Arrangement.SpaceBetween
            ) {
                Row(modifier = Modifier.fillMaxWidth()) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            text = observation.relatedPlantName,
                            style = MaterialTheme.typography.titleMedium,
                            color = Color.White
                        )
                        Text(
                            text = observation.relatedPlantName, // or scientificName if available
                            style = MaterialTheme.typography.bodyMedium,
                            color = Color.White
                        )
                    }
                    Column(horizontalAlignment = Alignment.End) {
                        Text(
                            text = dateText,
                            style = MaterialTheme.typography.bodySmall,
                            color = Color.White
                        )
                        Text(
                            text = observation.location,
                            style = MaterialTheme.typography.bodySmall,
                            color = Color.White
                        )
                    }
                }
                Text(
                    text = observation.note ?: "",
                    style = MaterialTheme.typography.bodyMedium,
                    color = Color.White,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )
                Button(
                    onClick = onDetailsClick,
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00C853))
                ) {
                    Text(text = "Observation Details", color = Color.White)
                }
            }
        }
    }
}