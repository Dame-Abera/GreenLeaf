package com.example.greenleaf.presentation.ui.plant
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.background
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material3.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import coil3.compose.AsyncImage
import com.example.greenleaf.presentation.viewmodels.PlantDetailViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.greenleaf.presentation.components.MainBottomBar
import com.example.greenleaf.presentation.navigation.Screen

@Composable
fun PlantDetailScreen(
    navController: NavController,
    plantId: String,
    plantViewModel: PlantDetailViewModel = viewModel()
) {
    LaunchedEffect(Unit) {
        plantViewModel.loadPlant(plantId)
    }

    val plant = plantViewModel.plant ?: return

    Scaffold(
        bottomBar = {
            MainBottomBar(navController)
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
        ) {
            Box {
                AsyncImage(
                    model = plant.plantImageUrl,
                    contentDescription = plant.commonName,
                    contentScale = ContentScale.Crop,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(260.dp)
                )
                IconButton(
                    onClick = { navController.popBackStack() },
                    modifier = Modifier
                        .padding(16.dp)
                ) {
                    Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back", tint = Color.White)
                }
            }

            Column(modifier = Modifier.padding(16.dp)) {
                Text(plant.commonName, style = MaterialTheme.typography.titleLarge)
                Text(plant.scientificName, style = MaterialTheme.typography.titleSmall, color = Color.Gray)

                Spacer(Modifier.height(12.dp))

                Text("Habitat", fontWeight = FontWeight.Bold)
                Text(plant.habitat)

                Spacer(Modifier.height(8.dp))

                Text("Origin", fontWeight = FontWeight.Bold)
                Text(plant.origin ?: "-")

                Spacer(Modifier.height(8.dp))

                Text("Description", fontWeight = FontWeight.Bold)
                Text(plant.description ?: "No description provided.")

                Spacer(Modifier.height(16.dp))

                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Button(
                        onClick = { navController.navigate(
                                  Screen.AddEditPlant.createRoute(plant.id)
                                          ) },
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00C853))
                    ) {
                        Text("Edit Plant Details")
                    }
                    Button(
                        onClick = {
                            plantViewModel.deletePlant(plant.id)
                            navController.popBackStack()
                        },
                        colors = ButtonDefaults.buttonColors(containerColor = Color.Red)
                    ) {
                        Text("Delete Plant Details")
                    }
                }
            }
        }
    }
}
