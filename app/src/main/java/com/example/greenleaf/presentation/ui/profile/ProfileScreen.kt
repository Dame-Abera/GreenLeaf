package com.example.greenleaf.presentation.ui.profile

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Home
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import com.example.greenleaf.fakedata.FakeUserRepository
import com.example.greenleaf.presentation.viewmodels.ProfileViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ProfileScreen(
    navController: NavHostController,
    viewModel: ProfileViewModel = viewModel()
) {
    // If user is gone, go to login
    if (viewModel.isLoggedOut) {
        LaunchedEffect(Unit) {
            navController.navigate("login") {
                popUpTo("profile") { inclusive = true }
            }
        }
        return
    }

    // pull current user directly
    val user = FakeUserRepository.getUser()!!

    Scaffold(
        bottomBar = {
            NavigationBar {
                NavigationBarItem(
                    icon = { Icon(Icons.Default.Home, contentDescription = "Home") },
                    label = { Text("Home") },
                    selected = false,
                    onClick = {
                        navController.navigate("home") {
                            popUpTo("profile")
                            launchSingleTop = true
                        }
                    }
                )
                NavigationBarItem(
                    icon = { Icon(Icons.Default.Person, contentDescription = "Account") },
                    label = { Text("Account") },
                    selected = true,
                    onClick = { /* already here */ }
                )
            }
        },
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text("Profile") },
                actions = {
                    IconButton(onClick = { navController.navigate("edit_profile") }) {
                        Icon(Icons.Default.Edit, "Edit")
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
            Icon(
                Icons.Default.Person,
                contentDescription = null,
                Modifier.size(120.dp)
            )
            Spacer(Modifier.height(16.dp))
            Text(user.name, style = MaterialTheme.typography.titleLarge)
            Text(user.email, style = MaterialTheme.typography.bodyMedium)
            Spacer(Modifier.weight(1f))

            Button(
                onClick = { viewModel.logout() },
                Modifier.fillMaxWidth()
            ) {
                Text("Log Out")
            }
            Spacer(Modifier.height(8.dp))
            TextButton(
                onClick = { viewModel.showDeleteDlg = true },
                colors = ButtonDefaults.textButtonColors(contentColor = MaterialTheme.colorScheme.error),
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Delete Account")
            }
        }

        if (viewModel.showDeleteDlg) {
            AlertDialog(
                onDismissRequest = { viewModel.showDeleteDlg = false },
                title = { Text("Delete Account") },
                text = { Text("Are you sure you want to delete your account? This action cannot be undone.") },
                confirmButton = {
                    TextButton(onClick = {
                        viewModel.deleteAccount()
                        navController.navigate("login") {
                            popUpTo("profile") { inclusive = true }
                        }
                    }) {
                        Text("Delete", color = MaterialTheme.colorScheme.error)
                    }
                },
                dismissButton = {
                    TextButton(onClick = { viewModel.showDeleteDlg = false }) {
                        Text("Cancel")
                    }
                }
            )
        }
    }
}
