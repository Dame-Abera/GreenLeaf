package com.example.greenleaf.presentation.navigation

sealed class Screen(val route: String) {
    object Login : Screen("login")
    object SignUp : Screen("signup")
    object Home : Screen("home")
    object Profile : Screen("profile")
    object PlantDetail : Screen("plant_detail/{plantId}") {
        fun createRoute(plantId: String) = "plant_detail/$plantId"
    }
    object ObservationDetail : Screen("observation_detail/{observationId}") {
        fun createRoute(observationId: String) = "observation_detail/$observationId"
    }
    // Screen.kt
    object AddEditPlant : Screen("add_edit_plant?plantId={plantId}") {
        fun createRoute(plantId: String?): String =
            if (plantId != null) "add_edit_plant?plantId=$plantId"
            else                        "add_edit_plant"
    }

    // in com.example.greenleaf.presentation.navigation.Screen
    object AddEditObservation : Screen("add_edit_observation?observationId={observationId}") {
        fun createRoute(observationId: String?): String =
            if (observationId != null) "add_edit_observation?observationId=$observationId"
            else                        "add_edit_observation"
    }

    object AdminDashboard : Screen("admin_dashboard")
    object EditProfile : Screen("edit_profile")

}