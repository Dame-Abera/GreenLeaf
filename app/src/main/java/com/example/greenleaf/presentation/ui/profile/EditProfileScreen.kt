package com.example.greenleaf.presentation.ui.profile

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Home
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import com.example.greenleaf.presentation.viewmodels.EditProfileViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EditProfileScreen(
    navController: NavHostController,
    viewModel: EditProfileViewModel = viewModel()
) {
    Scaffold(
        // ←— ADD BOTTOM BAR HERE
        bottomBar = {
            NavigationBar {
                NavigationBarItem(
                    icon = { Icon(Icons.Default.Home, contentDescription = "Home") },
                    label = { Text("Home") },
                    selected = false,
                    onClick = {
                        navController.navigate("home") {
                            popUpTo("edit_profile")
                            launchSingleTop = true
                        }
                    }
                )
                NavigationBarItem(
                    icon = { Icon(Icons.Default.Person, contentDescription = "Account") },
                    label = { Text("Account") },
                    selected = true,
                    onClick = { /* no-op; already on Account */ }
                )
            }
        },
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text("Edit Profile") },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Default.Close, contentDescription = "Cancel")
                    }
                },
                actions = {
                    TextButton(onClick = {
                        viewModel.saveUser()
                        navController.popBackStack()
                    }) {
                        Text("Save")
                    }
                }
            )
        }
    ) { padding ->
        Column(
            Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(16.dp)
                .verticalScroll(rememberScrollState()),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Box(
                modifier = Modifier
                    .size(120.dp)
                    .clip(CircleShape)
                    .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.2f))
                    .clickable { /* TODO: pick photo */ },
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Default.Person, contentDescription = null, modifier = Modifier.size(64.dp))
                Text("Set New Photo", Modifier.align(Alignment.BottomCenter).padding(4.dp))
            }

            Spacer(Modifier.height(24.dp))

            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedTextField(
                    value = viewModel.firstName,
                    onValueChange = { viewModel.firstName = it },
                    label = { Text("First Name") },
                    modifier = Modifier.weight(1f)
                )
                OutlinedTextField(
                    value = viewModel.lastName,
                    onValueChange = { viewModel.lastName = it },
                    label = { Text("Last Name") },
                    modifier = Modifier.weight(1f)
                )
            }

            Spacer(Modifier.height(8.dp))
            OutlinedTextField(
                value = viewModel.birthdate,
                onValueChange = { viewModel.birthdate = it },
                label = { Text("Birth Date") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
            )
            Spacer(Modifier.height(8.dp))
            OutlinedTextField(
                value = viewModel.gender,
                onValueChange = { viewModel.gender = it },
                label = { Text("Gender") },
                modifier = Modifier.fillMaxWidth()
            )
            Spacer(Modifier.height(8.dp))
            OutlinedTextField(
                value = viewModel.email,
                onValueChange = { viewModel.email = it },
                label = { Text("Email") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email)
            )
            Spacer(Modifier.height(8.dp))
            OutlinedTextField(
                value = viewModel.phoneNumber,
                onValueChange = { viewModel.phoneNumber = it },
                label = { Text("Mobile") },
                modifier = Modifier.fillMaxWidth(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone)
            )
        }
    }
}
