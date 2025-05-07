package com.example.greenleaf.presentation.navigation

import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import com.example.greenleaf.presentation.ui.admin.AdminDashboardScreen
import com.example.greenleaf.presentation.ui.home.HomeScreen
import com.example.greenleaf.presentation.ui.login.LoginScreen
import com.example.greenleaf.presentation.ui.observation.AddEditObservationScreen
import com.example.greenleaf.presentation.ui.observation.ObservationDetailScreen
import com.example.greenleaf.presentation.ui.plant.AddEditPlantScreen
import com.example.greenleaf.presentation.ui.plant.PlantDetailScreen
import com.example.greenleaf.presentation.ui.profile.EditProfileScreen
import com.example.greenleaf.presentation.ui.profile.ProfileScreen
import com.example.greenleaf.presentation.ui.signup.SignUpScreen
import com.example.greenleaf.presentation.viewmodels.*

@Composable
fun NavigationGraph(navController: NavHostController) {
    NavHost(navController = navController, startDestination = Screen.Login.route) {

        // --- Login & Signup ---
        composable(Screen.Login.route) {
            LoginScreen(
                navController = navController,
                onSignUpClick = { navController.navigate(Screen.SignUp.route) },
                onLoginSuccess = {
                    navController.navigate(Screen.Home.route) {
                        popUpTo(Screen.Login.route) { inclusive = true }
                    }
                }
            )
        }

        composable(Screen.SignUp.route) {
            val signUpVm: SignUpViewModel = viewModel()
            SignUpScreen(
                viewModel = signUpVm,
                onNavigateToLogin = { navController.popBackStack() }
            )
        }

        // --- Main Tabs ---
        composable(Screen.Home.route) {
            HomeScreen(navController = navController)
        }

        composable(Screen.Profile.route) {
            ProfileScreen(navController = navController)
        }

        // --- Plant Screens ---

        composable(
            route = Screen.AddEditPlant.route,
            arguments = listOf(
                navArgument("plantId") {
                    type = NavType.StringType
                    nullable = true
                    defaultValue = null
                }
            )
        ) { backStack ->
            val plantId = backStack.arguments?.getString("plantId")
            val addEditPlantVm: AddEditPlantViewModel = viewModel()
            AddEditPlantScreen(
                navController = navController,
                viewModel = addEditPlantVm,
                plantId = plantId  // pass it along
            )
        }


        // --- Observation Screens ---
        // replace your current AddEditObservation block with this:

        composable(
            route = Screen.AddEditObservation.route,
            arguments = listOf(
                navArgument("observationId") {
                    type = NavType.StringType
                    nullable = true
                    defaultValue = null
                }
            )
        ) { backStack ->
            val obsId = backStack.arguments?.getString("observationId")
            val vm: AddEditObservationViewModel = viewModel()
            AddEditObservationScreen(
                navController = navController,
                observationId = obsId,
                observationViewModel = vm // Corrected parameter name
            )
        }



        // --- Admin & Profile Edit ---
        composable(Screen.AdminDashboard.route) {
            AdminDashboardScreen(navController = navController)
        }

        composable(
            route = Screen.PlantDetail.route,
            arguments = listOf(navArgument("plantId") {
                type = NavType.StringType
            })
        ) { backStack ->
            val plantId = backStack.arguments!!.getString("plantId")!!
            PlantDetailScreen(navController, plantId)
        }

        // Observation detail – register exactly "observation_detail/{observationId}"
        composable(
            route = Screen.ObservationDetail.route,
            arguments = listOf(navArgument("observationId") {
                type = NavType.StringType
            })
        ) { backStack ->
            val obsId = backStack.arguments!!.getString("observationId")!!
            ObservationDetailScreen(navController, obsId)
        }
        composable("edit_profile") {
            val vm: EditProfileViewModel = viewModel()
            EditProfileScreen(navController, vm)
        } }
}
