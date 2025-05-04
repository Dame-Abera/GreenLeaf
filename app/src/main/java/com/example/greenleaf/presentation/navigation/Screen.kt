package com.example.greenleaf.presentation.navigation



sealed class Screen(val route: String) {
    object Login : Screen("login")
    object SignUp : Screen("signup")
    object Home : Screen("home") // if you already have Home screen
}
