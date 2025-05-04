package com.example.greenleaf.presentation.ui.home

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
// import androidx.compose.foundation.clickable // Not used directly, remove if not needed
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons

import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.AccountCircle
import androidx.compose.material.icons.filled.Home
import androidx.compose.material3.Button // Use M3 Button
import androidx.compose.material3.ButtonDefaults // Use M3 ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon // Already have M3 Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.material3.NavigationBar // Use M3 NavigationBar
import androidx.compose.material3.NavigationBarItem // Use M3 NavigationBarItem
import androidx.compose.material3.FloatingActionButton // Use M3 FloatingActionButton
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale // Added for better image scaling
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow // Added for description ellipsis
import androidx.compose.ui.unit.dp
import com.example.greenleaf.R // Assuming this R file exists and is correct

@Composable
fun HomeScreen() {
    var selectedTab by remember { mutableStateOf(0) }
    val tabs = listOf("Plants", "Field observations")

    Scaffold(

        bottomBar = {
            NavigationBar(containerColor = Color.White) {
                NavigationBarItem(
                    icon = { Icon(Icons.Default.Home, contentDescription = "Home") },
                    selected = true,
                    onClick = { },
                    label = { Text("Home") }
                )
                NavigationBarItem(
                    icon = { Icon(Icons.Default.AccountCircle, contentDescription = "Account") },
                    selected = false,
                    onClick = { },
                    label = { Text("Account") }
                )
            }
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = { /* Handle Add */ },
                containerColor = Color(0xFF4CAF50),
                contentColor = Color.White
            ) {
                Icon(Icons.Default.Add, contentDescription = "Add")
            }
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .padding(paddingValues)
                .padding(horizontal = 16.dp, vertical = 8.dp)
                .fillMaxSize()
        ) {
            Text(
                text = "GreenLeaf",
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(bottom = 5.dp)
            )

            TabRow(
                selectedTabIndex = selectedTab,
                containerColor = Color.Transparent,
                contentColor = MaterialTheme.colorScheme.primary
            ) {
                tabs.forEachIndexed { index, title ->
                    Tab(
                        selected = selectedTab == index,
                        onClick = { selectedTab = index },
                        text = { Text(title) }
                    )
                }
            }

//            Spacer(modifier = Modifier.height(16.dp))

            when (selectedTab) {
                0 -> PlantsList()
                1 -> ObservationsList()
            }
        }
    }
}

@Composable
fun PlantsList() {
    // Consider using unique keys if data can change, e.g., plant IDs
    val plants = listOf(
        "Aloe Vera" to R.drawable.greenleaf,
        "Clover" to R.drawable.greenleaf,
        "Succulent" to R.drawable.greenleaf, // Changed duplicate name for clarity
        "Fern" to R.drawable.greenleaf,    // Changed duplicate name for clarity
    )

    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(12.dp) // Add space between items
    ) {
        items(plants) { (name, imageRes) ->
            // M3 Card is fine
            Card(
                shape = MaterialTheme.shapes.medium,
                elevation = CardDefaults.cardElevation(defaultElevation = 4.dp), // M3 elevation syntax
                modifier = Modifier
                    .fillMaxWidth()
                // .padding(vertical = 8.dp) // Removed, using Arrangement.spacedBy in LazyColumn
            ) {
                Box(modifier = Modifier.height(180.dp)) { // Increased height slightly
                    Image(
                        painter = painterResource(id = imageRes),
                        contentDescription = name,
                        contentScale = ContentScale.Crop, // Crop image to fill bounds
                        modifier = Modifier.fillMaxSize() // Image fills the Box
                    )
                    // Optional: Add a scrim for better text readability on image
                    Box(modifier = Modifier
                        .fillMaxSize()
                        .align(Alignment.BottomCenter)
                        .background(Color.Black.copy(alpha = 0.4f)))

                    // Text positioned at top start
                    Text(
                        text = name,
                        color = Color.White,
                        fontWeight = FontWeight.Bold,
                        style = MaterialTheme.typography.titleMedium, // Use M3 typography
                        // fontSize = 18.sp, // Prefer typography styles
                        modifier = Modifier
                            .align(Alignment.TopStart)
                            .padding(12.dp) // Increased padding
                    )
                    // Use M3 Button
                    Button(
                        onClick = { /* Plant Details */ },
                        modifier = Modifier
                            .align(Alignment.BottomEnd)
                            .padding(12.dp), // Increased padding
                        // Use M3 ButtonDefaults and containerColor
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF4CAF50)) // Example Green
                    ) {
                        Text(
                            text = "Plant Details",
                            color = Color.White,
                            style = MaterialTheme.typography.labelSmall // Use M3 typography for button text
                            // fontSize = 12.sp // Prefer typography styles
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun ObservationsList() {
    // Consider using unique IDs for observations
    val observations = listOf(
        Observation("Aloe Vera Obs 1", "April 23, 2024, 2:15 PM", "Awash Valley", "I saw a tall grass-like plant with delicate purple flowers blooming near the riverbank. Looked healthy."),
        Observation("Clover Field", "April 22, 2024, 10:00 AM", "Highland Park", "Large patch of clover, appears to be thriving well after recent rain. Many bees present."),
        Observation("Succulent Discovery", "April 21, 2024, 4:30 PM", "Desert Trail", "Found a small succulent growing under a rock ledge. Seems adapted to the arid conditions."),
        Observation("Fern Grove", "April 20, 2024, 9:15 AM", "Redwood Forest", "Observed a dense area of ferns near a stream. Moist soil, shaded environment. Very green."),
    )

    LazyColumn(
        verticalArrangement = Arrangement.spacedBy(12.dp) // Add space between items
    ) {
        items(observations) { observation ->
            // M3 Card is fine
            Card(
                shape = MaterialTheme.shapes.medium,
                elevation = CardDefaults.cardElevation(defaultElevation = 4.dp), // M3 elevation syntax
                modifier = Modifier
                    .fillMaxWidth()
                // .padding(vertical = 8.dp) // Removed, using Arrangement.spacedBy in LazyColumn
            ) {
                Box(modifier = Modifier.height(180.dp)) { // Consistent height
                    Image(
                        painter = painterResource(id = R.drawable.greenleaf), // Use appropriate image if available
                        contentDescription = observation.plantName,
                        contentScale = ContentScale.Crop,
                        modifier = Modifier.fillMaxSize()
                    )
                    // Optional: Add a scrim for better text readability on image
                    Box(modifier = Modifier
                        .fillMaxSize()
                        .align(Alignment.BottomCenter)
                        .background(Color.Black.copy(alpha = 0.5f)))

                    Column(
                        modifier = Modifier
                            .align(Alignment.TopStart)
                            .padding(12.dp) // Increased padding
                            .fillMaxWidth() // Allow column to influence width within padding
                    ) {
                        Text(
                            text = observation.plantName,
                            color = Color.White,
                            fontWeight = FontWeight.Bold,
                            style = MaterialTheme.typography.titleMedium
                            // fontSize = 16.sp // Prefer typography style
                        )
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = observation.date,
                            color = Color.White,
                            style = MaterialTheme.typography.bodySmall
                            // fontSize = 12.sp // Prefer typography style
                        )
                        Text(
                            text = observation.location,
                            color = Color.White,
                            style = MaterialTheme.typography.bodySmall
                            // fontSize = 12.sp // Prefer typography style
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = observation.description,
                            color = Color.White,
                            style = MaterialTheme.typography.bodySmall,
                            // fontSize = 12.sp, // Prefer typography style
                            maxLines = 2, // Keep maxLines
                            overflow = TextOverflow.Ellipsis // Add ellipsis for overflow
                        )
                    }
                    // Use M3 Button
                    Button(
                        onClick = { /* Observation Details */ },
                        modifier = Modifier
                            .align(Alignment.BottomEnd)
                            .padding(12.dp), // Increased padding
                        // Use M3 ButtonDefaults and containerColor
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF4CAF50)) // Example Green
                    ) {
                        Text(
                            text = "Observation Details",
                            color = Color.White,
                            style = MaterialTheme.typography.labelSmall // Use M3 typography
                            // fontSize = 12.sp // Prefer typography style
                        )
                    }
                }
            }
        }
    }
}

// Data class remains the same
data class Observation(
    val plantName: String,
    val date: String,
    val location: String,
    val description: String
)
