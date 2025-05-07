package com.example.greenleaf.presentation.ui.plant

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import com.example.greenleaf.presentation.viewmodels.AddEditPlantViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddEditPlantScreen(
    navController: NavController,
    viewModel: AddEditPlantViewModel = viewModel(),
    plantId: String? = null
) {
    // If editing, load existing plant into form
    LaunchedEffect(plantId) {
        plantId?.let { viewModel.loadPlant(it) }
    }

    // After saving, pop back
    if (viewModel.isSaved.value) {
        navController.popBackStack()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Add/Edit Plant") },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .padding(16.dp)
                .verticalScroll(rememberScrollState())
        ) {
            // Image placeholder
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(150.dp)
                    .background(Color.LightGray),
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Filled.Person, contentDescription = "Add Image")
                Text("Add/Change Image")
            }

            Spacer(Modifier.height(16.dp))

            // Form fields
            OutlinedTextField(
                value = viewModel.commonName.value,
                onValueChange = { viewModel.commonName.value = it },
                label = { Text("Common Name") },
                placeholder = { Text("e.g. Red Maple") },
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(Modifier.height(8.dp))

            OutlinedTextField(
                value = viewModel.scientificName.value,
                onValueChange = { viewModel.scientificName.value = it },
                label = { Text("Scientific Name") },
                placeholder = { Text("e.g. Acer rubrum") },
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(Modifier.height(8.dp))

            OutlinedTextField(
                value = viewModel.habitat.value,
                onValueChange = { viewModel.habitat.value = it },
                label = { Text("Habitat") },
                placeholder = { Text("e.g. Deciduous forest") },
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(Modifier.height(8.dp))

            OutlinedTextField(
                value = viewModel.origin.value,
                onValueChange = { viewModel.origin.value = it },
                label = { Text("Origin") },
                placeholder = { Text("e.g. Ethiopia") },
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(Modifier.height(8.dp))

            OutlinedTextField(
                value = viewModel.description.value,
                onValueChange = { viewModel.description.value = it },
                label = { Text("Description") },
                placeholder = { Text("Provide detailed description") },
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(Modifier.height(24.dp))

            // Cancel / Save buttons
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedButton(
                    onClick = { navController.popBackStack() },
                    modifier = Modifier.weight(1f)
                ) {
                    Text("Cancel")
                }
                Button(
                    onClick = { viewModel.savePlant() },
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00C853)),
                    modifier = Modifier.weight(1f)
                ) {
                    Text("Save", color = Color.White)
                }
            }
        }
    }
}
