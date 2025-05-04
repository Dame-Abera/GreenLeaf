package com.example.greenleaf.presentation.navigation

import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import com.example.greenleaf.presentation.ui.login.LoginScreen
import com.example.greenleaf.presentation.ui.login.SignUpScreen
import com.example.greenleaf.presentation.ui.home.HomeScreen
import com.example.greenleaf.presentation.viewmodels.SignUpViewModel
import androidx.hilt.navigation.compose.hiltViewModel
import com.example.greenleaf.presentation.viewmodels.LoginViewModel

@Composable
fun NavigationGraph(navController: NavHostController) {
    NavHost(navController = navController, startDestination = Screen.Login.route) {
        composable(Screen.Login.route) {
            LoginScreen(
                navController = navController,
                onSignUpClick = { navController.navigate(Screen.SignUp.route) },
                onLoginSuccess = { navController.navigate(Screen.Home.route){
                    popUpTo(Screen.Login.route) { inclusive = true }
                } }
            )
        }
        composable(Screen.SignUp.route) {
            val viewModel: SignUpViewModel = viewModel() // Using ViewModel here
            SignUpScreen(viewModel = viewModel, onNavigateToLogin = {
                navController.popBackStack() // Navigate back to Login
            })
        }
        composable(Screen.Home.route) {
            HomeScreen() // Define your HomeScreen here
        }
    }
}