package com.example.greenleaf.presentation.ui.signup

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.example.greenleaf.R
import com.example.greenleaf.presentation.viewmodels.SignUpViewModel
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.Icons
import androidx.compose.runtime.key

@Composable
fun SignUpScreen(viewModel: SignUpViewModel, onNavigateToLogin: () -> Unit) {
    val uiState by viewModel.uiState.collectAsState()

    Column(modifier = Modifier.fillMaxSize()) {
        // Top Image Banner with Overlapping IconButton
        Box {
            Image(
                painter = painterResource(id = R.drawable.greenleaf),
                contentDescription = "GreenLeaf Logo",
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
                    .clip(RoundedCornerShape(bottomStart = 24.dp, bottomEnd = 24.dp))
            )

            IconButton(
                onClick = { onNavigateToLogin() },
                modifier = Modifier
                    .padding(8.dp)
                    .align(Alignment.TopStart)
            ) {
                Icon(
                    imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                    contentDescription = "Back",
                    tint = Color.White
                )
            }
        }

        // Back to Login Text Row
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier
                .padding(horizontal = 16.dp)
                .clickable { onNavigateToLogin() }
        ) {
            IconButton(onClick = { onNavigateToLogin() }) {
                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
            }
            Spacer(modifier = Modifier.width(4.dp))
            Text(text = "Back to login", color = Color.Black)
        }

        Spacer(modifier = Modifier.height(16.dp))

        Box(modifier = Modifier.fillMaxSize()) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text("Sign Up", style = MaterialTheme.typography.headlineSmall)

                Spacer(Modifier.height(16.dp))

                GreenInputField(
                    value = uiState.email,
                    onValueChange = { viewModel.onEvent(SignUpEvent.EmailChanged(it)) },
                    label = "Email",
                    icon = Icons.Default.Email
                )

                Spacer(Modifier.height(8.dp))

                GreenInputField(
                    value = uiState.password,
                    onValueChange = { viewModel.onEvent(SignUpEvent.PasswordChanged(it)) },
                    label = "Password",
                    icon = Icons.Default.Lock
                )

                Spacer(Modifier.height(8.dp))

                GreenInputField(
                    value = uiState.confirmPassword, // Now using confirmPassword
                    onValueChange = { viewModel.onEvent(SignUpEvent.ConfirmPasswordChanged(it)) }, // New event
                    label = "Confirm Password",
                    icon = Icons.Default.Lock
                )

                uiState.error?.let {
                    Spacer(Modifier.height(8.dp))
                    Text(it, color = Color.Red)
                }
            }

            // Sign Up Button at Bottom
            Button(
                onClick = { viewModel.onEvent(SignUpEvent.Submit) },
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .fillMaxWidth()
                    .padding(start = 16.dp, end = 16.dp, bottom = 64.dp)
                    .height(48.dp),
                shape = RoundedCornerShape(24.dp),
                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00E676))
            ) {
                if (uiState.isLoading)
                    CircularProgressIndicator(modifier = Modifier.size(24.dp), color = Color.White)
                else
                    Text("Sign Up", color = Color.White)
            }
        }
    }
}

// --- GreenInputField is OUTSIDE now  ---


// --- GreenInputField is OUTSIDE now  ---

@Composable
fun GreenInputField(
    value: String,
    onValueChange: (String) -> Unit,
    label: String,
    icon: androidx.compose.ui.graphics.vector.ImageVector
) {
    key(label) { // Add key outside the OutlinedTextField
        OutlinedTextField(
            value = value,
            onValueChange = onValueChange,
            placeholder = { Text(label, color = Color.DarkGray) },
            leadingIcon = {
                Icon(icon, contentDescription = null, tint = Color.DarkGray)
            },
            modifier = Modifier
                .fillMaxWidth()
                .background(Color(0xFFDFFFE1), shape = RoundedCornerShape(16.dp)), // light green
            colors = OutlinedTextFieldDefaults.colors(
                focusedBorderColor = Color.Transparent,
                unfocusedBorderColor = Color.Transparent,
                disabledBorderColor = Color.Transparent,
                errorBorderColor = Color.Transparent
            ),
            shape = RoundedCornerShape(16.dp),
            singleLine = true
        )
    }
}