
package com.example.greenleaf.presentation.ui.login

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize

import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import com.example.greenleaf.presentation.viewmodels.SignUpViewModel
import com.example.greenleaf.ui.theme.GreenLeafTheme

class LoginActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            GreenLeafTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = colorScheme.background
                ) {
                    SignUpScreenWrapper()
                }
            }
        }
    }
}

@Composable
fun SignUpScreenWrapper(){
    val signUpViewModel: SignUpViewModel = viewModel()
    SignUpScreen(viewModel = signUpViewModel, onNavigateToLogin = {})
}