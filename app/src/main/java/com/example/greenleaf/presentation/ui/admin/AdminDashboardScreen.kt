package com.example.greenleaf.presentation.ui.admin

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.example.greenleaf.fakedata.FakeUserRepository

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AdminDashboardScreen(navController: NavController) {
    val users = listOfNotNull(FakeUserRepository.getUser()) // Simulating a list of users
    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Registered Users") })
        }
    ) { contentPadding ->
        LazyColumn(modifier = Modifier.padding(contentPadding).padding(16.dp)) {
            items(users) { user ->
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(vertical = 8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(user.name, style = MaterialTheme.typography.bodyLarge)
                        Text(user.email, style = MaterialTheme.typography.bodySmall, color = Color.Gray)
                    }
                    // Role badge (hardcoded as "USER" since `role` is not in the `User` class)
                    AssistChip(
                        onClick = { /* no action */ },
                        label = { Text("USER", color = Color.White) },
                        colors = AssistChipDefaults.assistChipColors(containerColor = Color.Gray)
                    )
                }
                HorizontalDivider()
            }
        }
    }
}